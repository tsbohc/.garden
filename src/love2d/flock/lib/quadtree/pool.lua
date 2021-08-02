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

local ffiloaded, ffi

if type(jit) == "table" and jit.status() then
	ffiloaded, ffi = pcall ( require, "ffi" )
end

local Pool = setmetatable ( { }, { __call = function ( class, ... ) return class.new ( ... ) end } )
Pool.__index = Pool

-- accepts custom generator function, nil, lua table, 
-- ffi cdecl, ffi ctype for object generator
function Pool.new ( generator )
	local self = setmetatable ( { }, Pool )
	if type ( generator ) == "function" then
		self.generator = generator
	elseif ffiloaded and ( type ( generator ) == "string" or type ( generator ) == "cdata" ) then
		self.generator = ffi.typeof ( generator )
	elseif generator == nil or type ( generator ) == "table" then
		self.generator = function ( ) return setmetatable ( { }, generator ) end
	end
	self.pool = { [ 0 ] = 0 } 
	return self
end

-- retreive object if available
function Pool:pop2 ( )
	-- return table.remove ( self.pool )
	if self.pool[ 0 ] == 0 then return nil end
	local obj = self.pool[ self.pool[ 0 ] ]
	self.pool[ self.pool[ 0 ] ] = nil
	self.pool[ 0 ] = self.pool[ 0 ] - 1
	return obj
end

-- allocate new object if none available, always returns an object
function Pool:pop ( )
	--return table.remove ( self.pool ) or self.generator ( )
	if self.pool[ 0 ] == 0 then return self.generator ( ) end
	local obj = self.pool[ self.pool[ 0 ] ]
	self.pool[ self.pool[ 0 ] ] = nil
	self.pool[ 0 ] = self.pool[ 0 ] - 1
	return obj
end

-- discard used object for later reuse
function Pool:push ( obj )
	--table.insert ( self.pool, obj )
	if obj == nil then return end
	self.pool[ 0 ] = self.pool[ 0 ] + 1
	self.pool[ self.pool[ 0 ] ] = obj
end

-- preallocate objects
function Pool:generate ( num )
	--for i = 1, num do table.insert ( self.pool, self.generator ( ) ) end
	for i = self.pool[ 0 ] + 1, self.pool[ 0 ] + num do self.pool[ i ] = self.generator ( ) end
	self.pool[ 0 ] = self.pool[ 0 ] + num
end

-- clear references
function Pool:clear ( )
	--while #self.pool > 1 do table.remove ( self.pool ) end
	for i = self.pool[ 0 ], 1, -1 do self.pool[ i ] = nil end
	self.pool[ 0 ] = 0
end

return Pool
