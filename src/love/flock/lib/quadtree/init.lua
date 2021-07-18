--[[
Copyright (c) 2017 raidho36/rcoaxil <coaxilthedrug@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the Software
is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.
]]

pathprefix = (...)
local Pool = require ( pathprefix .. ".pool" )
pathprefix = nil

local quadpool, nodepool, listpool
local mabs = math.abs

local mode_k, mode_v, mode_kv = { __mode = "k" }, { __mode = "v" }, { __mode = "kv" }

local Quadtree = setmetatable ( { }, { __call = function ( class, ... ) return class.new ( ... ) end } )
Quadtree.__index = Quadtree

local Quadnode = setmetatable ( { }, { __call = function ( class, ... ) return class.new ( ... ) end } )
Quadnode.__index = Quadnode

local quadlist = setmetatable ( { }, mode_k )
local nodelist = setmetatable ( { }, mode_k )
local objlist  = setmetatable ( { }, mode_k )

do
	local _generator

	_generator = function ( )
		local self = setmetatable ( { }, Quadtree )
		self.quads = setmetatable ( { }, mode_v )
		return self
	end
	quadpool = Pool ( _generator )

	_generator = function ( )
		local self = setmetatable ( { }, Quadnode )
		self.quads = setmetatable ( { }, mode_v )
		return self
	end
	nodepool = Pool ( _generator )
end
listpool = Pool ( )

function Quadtree.new ( x1, y1, x2, y2 )
	local self = quadpool:pop ( )
	self.x1 = x1 or 0
	self.x2 = x2 or 0
	self.y1 = y1 or 0
	self.y2 = y2 or 0
	self.x = ( x1 + x2 ) / 2
	self.y = ( y1 + y2 ) / 2
	--self.par = nil
	for i = 0, 4 do
		self.quads[ i ] = nil
	end
	return self
end

function Quadtree:insert ( obj, x, y )
	if not quadlist[ self ] then
		quadlist[ self ] = setmetatable ( { }, mode_k )
		nodelist[ self ] = setmetatable ( { }, mode_k )
		objlist[ self ]  = setmetatable ( { }, mode_kv )
	end

	local node = nodelist[ self ][ obj ]
	if not node then
		node = Quadnode ( x, y )
		nodelist[ self ][ obj ] = node
		objlist[ self ][ node ] = obj
		return self:_insert ( self, node )
	else
		node.x = x
		node.y = y
		return node:update ( self )
	end
end

function Quadtree:remove ( obj )
	local node = nodelist[ self ][ obj ]
	if not node then return end

	node.quads[ 0 ].quads[ node.pos ] = nil
	node.quads[ 0 ]:_simplify ( self )
	node.quads[ 0 ] = nil

	objlist[ self ][ node ] = nil
	nodelist[ self ][ obj ] = nil
	nodepool:push ( node )
end

function Quadtree:search ( x1, y1, x2, y2 )
	local list = listpool:pop ( )
	list[ 0 ] = 0
	for i = 1, 4 do
		list[ i ] = nil
	end
	return self:_search ( self, x1, y1, x2, y2, list )
end

function Quadtree:_insert ( root, quad )
	--insertion outside of quad bounds
	if quad.x < self.x1 or quad.x > self.x2 or quad.y < self.y1 or quad.y > self.y2 then
		--insert into parent quad if available
		if self.quads[ 0 ] then
			return self.quads[ 0 ]:_insert ( root, quad )
		end

		--copy root quad to new intermediate quad
		local q = Quadtree ( self.x1, self.y1, self.x2, self.y2 )
		quadlist[ root ][ q ] = q
		q.x = self.x
		q.y = self.y
		for i = 1, 4 do
			q.quads[ i ] = self.quads[ i ]
			if q.quads[ i ] then
				q.quads[ i ].quads[ 0 ] = q
			end
		end

		--set root quad as outer root quad
		local xx = self.x2 - self.x1
		local yy = self.y2 - self.y1
		self.x = quad.x < self.x and self.x1 or self.x2
		self.y = quad.y < self.y and self.y1 or self.y2
		self.x1 = self.x - xx
		self.x2 = self.x + xx
		self.y1 = self.y - yy
		self.y2 = self.y + yy
		for i = 1, 4 do
			self.quads[ i ] = nil
		end

		--self becomes a bigger quad surrounding entire tree
		return self:_insert ( root, q ) and self:_insert ( root, quad )
	end

	--determine position within a quad
	local p = 1 + ( quad.x < self.x and 1 or 0 ) + ( quad.y < self.y and 2 or 0 )
	local q = self.quads[ p ]

	if not q then
		self.quads[ p ] = quad
		quad.quads[ 0 ] = self
		quad.pos = p
		return true
	elseif getmetatable ( q ) == Quadtree then
		return q:_insert ( root, quad )
	else
		--[[
		--this quad tree does not allow identical coordinates
		--if it's guaranteed that objects never overlap or intersect, it's safe to omit this solution
		--otherwise it should be uncommented - having the game/server crash out of this would be unfortunate
		while q.x == quad.x and q.y == quad.y do
			local r = math.random ( )
			if r > 0.5 then
				quad.x = quad.x * ( r > 0.75 and 0.999999 or 1.000001 )
			else
				quad.y = quad.y * ( r < 0.25 and 0.999999 or 1.000001 )
			end
		end
		--]]
		--attempt shift-insert
		if self:_shift_insert ( quad ) then
			return true
		end
		--create intermediate node and insert into parent node, insert both new and old objects into it
		local i = Quadtree (
			quad.x < self.x and self.x1 or self.x,
			quad.y < self.y and self.y1 or self.y,
			quad.x < self.x and self.x or self.x2,
			quad.y < self.y and self.y or self.y2 )
		quadlist[ root ][ i ] = i
		q.quads[ 0 ].quads[ q.pos ] = i
		i.quads[ 0 ] = q.quads[ 0 ]
		i.pos = q.pos

		return i:_insert ( root, q ) and i:_insert ( root, quad )
	end
end

function Quadtree:_shift_insert ( quad )
	local l = listpool:pop ( )
	local c = 1
	l[ 1 ] = quad

	for i = 1, 4 do
		if self.quads[ i ] ~= nil then
			--will not shift if quad contains sub quads
			if getmetatable ( self.quads[ i ] ) == Quadtree then
				listpool:push ( l )
				return false
			end
			c = c + 1
			l[ c ] = self.quads[ i ]
		end
	end

	if c == 2 then
		self.x = ( l[ 1 ].x + l[ 2 ].x ) / 2
		self.y = ( l[ 1 ].y + l[ 2 ].y ) / 2
		l[ 1 ].pos = 1 + ( l[ 1 ].x < self.x and 1 or 0 ) + ( l[ 1 ].y < self.y and 2 or 0 )
		l[ 2 ].pos = 1 + ( l[ 2 ].x < self.x and 1 or 0 ) + ( l[ 2 ].y < self.y and 2 or 0 )

		for i = 1, 4 do
			self.quads[ i ] = nil
		end
		self.quads[ l[ 1 ].pos ] = l[ 1 ]
		self.quads[ l[ 2 ].pos ] = l[ 2 ]
		quad.quads[ 0 ] = self
		listpool:push ( l )
		return true
	elseif c == 3 then
		--all 3 are on the same line
		if ( l[ 1 ].x == l[ 2 ].x and l[ 2 ].x == l[ 3 ].x ) or
		   ( l[ 1 ].y == l[ 2 ].y and l[ 2 ].y == l[ 3 ].y ) then
			listpool:push ( l )
			return false
		end
		self.x = ( l[ 1 ].x + l[ 2 ].x + l[ 3 ].x ) / 3
		self.y = ( l[ 1 ].y + l[ 2 ].y + l[ 3 ].y ) / 3
		l[ 1 ].pos = 1 + ( l[ 1 ].x < self.x and 1 or 0 ) + ( l[ 1 ].y < self.y and 2 or 0 )
		l[ 2 ].pos = 1 + ( l[ 2 ].x < self.x and 1 or 0 ) + ( l[ 2 ].y < self.y and 2 or 0 )
		l[ 3 ].pos = 1 + ( l[ 3 ].x < self.x and 1 or 0 ) + ( l[ 3 ].y < self.y and 2 or 0 )
		for i = 1, 3 do
			local c1 = l[ i ]
			local c2 = l[ i == 3 and 1 or i + 1 ]
			if c1.pos == c2.pos then
				if mabs ( c1.x - c2.x ) > mabs ( c1.y - c2.y ) then
					self.x = ( c1.x + c2.x ) / 2
				else
					self.y = ( c1.y + c2.y ) / 2
				end
				c1.pos = 1 + ( c1.x < self.x and 1 or 0 ) + ( c1.y < self.y and 2 or 0 )
				c2.pos = 1 + ( c2.x < self.x and 1 or 0 ) + ( c2.y < self.y and 2 or 0 )
				break
			end
		end

		for i = 1, 4 do
			self.quads[ i ] = nil
		end
		self.quads[ l[ 1 ].pos ] = l[ 1 ]
		self.quads[ l[ 2 ].pos ] = l[ 2 ]
		self.quads[ l[ 3 ].pos ] = l[ 3 ]
		quad.quads[ 0 ] = self
		listpool:push ( l )
		return true
	elseif c == 4 then
		local x = ( l[ 1 ].x + l[ 2 ].x + l[ 3 ].x + l[ 4 ].x ) / 4
		local y = ( l[ 1 ].y + l[ 2 ].y + l[ 3 ].y + l[ 4 ].y ) / 4
		local l1pos = 1 + ( l[ 1 ].x < x and 1 or 0 ) + ( l[ 1 ].y < y and 2 or 0 )
		local l2pos = 1 + ( l[ 2 ].x < x and 1 or 0 ) + ( l[ 2 ].y < y and 2 or 0 )
		local l3pos = 1 + ( l[ 3 ].x < x and 1 or 0 ) + ( l[ 3 ].y < y and 2 or 0 )
		local l4pos = 1 + ( l[ 4 ].x < x and 1 or 0 ) + ( l[ 4 ].y < y and 2 or 0 )

		if l1pos == l2pos or l1pos == l3pos or l1pos == l4pos or
		   l2pos == l3pos or l2pos == l4pos or l3pos == l4pos then
			listpool:push ( l )
			return false
		else
			self.quads[ l1pos ] = l[ 1 ]
			self.quads[ l2pos ] = l[ 2 ]
			self.quads[ l3pos ] = l[ 3 ]
			self.quads[ l4pos ] = l[ 4 ]
			l[ 1 ].pos = l1pos
			l[ 2 ].pos = l2pos
			l[ 3 ].pos = l3pos
			l[ 4 ].pos = l4pos
			self.x = x
			self.y = y
			quad.quads[ 0 ] = self
			listpool:push ( l )
			return true
		end
	else
		listpool:push ( l )
		return false
	end
end

function Quadtree:_simplify ( root )
	--root quad can not be simplified away
	if self.quads[ 0 ] == nil then return end

	local q = nil
	--see if there are sub-quads or if there are more than 1 nodes
	for i = 1, 4 do
		if self.quads[ i ] then
			--if getmetatable ( self.quads[ i ] ) == Quadtree then return end
			--only 1 node is allowed to simplify
			if not q then q = self.quads[ i ] else return end
		end
	end
	--simplify away current quad by putting its only node as parent quad's node
	if q then
		self.quads[ 0 ].quads[ self.pos ] = q
		q.quads[ 0 ] = self.quads[ 0 ]
		q.pos = self.pos
		if getmetatable ( q ) == Quadtree then
			q:_resizerecursive ( self.x1, self.y1, self.x2, self.y2 )
		end
	--quad has no nodes left - remove it from parent quad
	else
		self.quads[ 0 ].quads[ self.pos ] = nil
	end
	q = self.quads[ 0 ]
	quadlist[ root ][ self ] = nil
	quadpool:push ( self )
	q:_simplify ( root )
end

function Quadtree:_resizerecursive ( x1, y1, x2, y2 )
	self.x1 = x1
	self.x2 = x2
	self.y1 = y1
	self.y2 = y2
	local x, y = self.x, self.y
	for i = 1, 4 do
		local q = self.quads[ i ]
		if q and getmetatable ( q ) == Quadtree then
			q:_resizerecursive (
				q.x < x and x1 or x, q.y < y and y1 or y,
				q.x < x and x or x2, q.y < y and y or y2 )
		end
	end
end

function Quadtree:_search ( root, x1, y1, x2, y2, list )
	for i = 1, 4 do
		local q = self.quads[ i ]
		if q then
			if getmetatable ( q ) == Quadtree then
				if x1 <= q.x2 and x2 >= q.x1 and y1 <= q.y2 and y2 >= q.y1 then
					q:_search ( root, x1, y1, x2, y2, list )
				end
			else
				list[ 0 ] = list[ 0 ] + 1
				list[ list[ 0 ] ] = objlist[ root ][ q ]
			end
		end
	end
	return list
end

function Quadnode.new ( x, y )
	local self = nodepool:pop ( )
	self.x = x
	self.y = y
	self.quads[ 0 ] = nil
	return self
end

function Quadnode:update ( root )
	local q = self.quads[ 0 ]
	if not q then return end

	q.quads[ self.pos ] = nil
	local res = q:_insert ( root, self )
	if q ~= self.quads[ 0 ] then q:_simplify ( root ) end
	return res
end

return Quadtree

