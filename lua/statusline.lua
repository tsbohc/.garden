V.au({
	'BufEnter',
	'BufLeave',
	'BufWritePost',
	'CursorMoved',
	'CursorMovedI',
	'InsertEnter',
	'InsertLeave'
}, '*', function()
	return V.redrawstatus()
end)
local b = vim.b
G.home = os.getenv('HOME')
__modules = { }
S = {
	mod = function(event, name, command)
		if __modules[name] then
			print('S.mod: module with the name \'' .. name .. '\' already exists!')
			print('skipping...')
			return
		end
		__modules[name] = command
		if type(event) == 'string' then
			if event:match('User ') then
				return V.au(event, '', function()
					b[name] = __modules[name]()
				end)
			else
				return V.au(event, '*', function()
					b[name] = __modules[name]()
				end)
			end
		else
			return V.au(event, '*', function()
				b[name] = __modules[name]()
			end)
		end
	end
}
S.mod('User UndoRedo', 'undotime', function()
	return V.getundotime()
end)
S.mod('BufEnter', 'readonly', function()
	return [[%{&readonly?' readonly ':''}]]
end)
S.mod('BufEnter,BufWritePost', 'filetype', function()
	return vim.bo.filetype
end)
S.mod('BufEnter,BufWritePost', 'cwd', function()
	b.info = vim.fn.getbufinfo()[b.bufnr]
	if b.info.name == '' then
		local path = os.capture('pwd')
		return path:gsub(G.home, '~') .. '/'
	else
		return b.info.name:gsub(G.home, '~'):match('(.*[/\\])')
	end
end)
S.mod('BufEnter,BufWritePost', 'filename', function()
	b.info = vim.fn.getbufinfo()[b.bufnr]
	if b.info.name == '' then
		return ''
	else
		local name = string.match(b.info.name, "^.+/(.+)$")
		return '‹‹ ' .. name .. ' ››'
	end
end)
S.mod('User UndoRedo,BufEnter,BufWritePost', 'saved', function()
	b.info = vim.fn.getbufinfo()[b.bufnr]
	if b.info.name ~= '' then
		return [[%{&modified?'':',, saved'}]]
	end
end)
S.mod({
	'InsertEnter',
	'InsertLeave',
	'TextChangedI',
	'CursorMoved'
}, 'layout', function()
	if not G.previous_layout then
		return 'us'
	else
		return G.previous_layout
	end
end)
local out
out = function(data)
	local _out = ''
	for _, k in pairs(data) do
		_out = _out .. k
	end
	return _out
end
local _ = ' '
statusline = function(bufnr)
	b.bufnr = bufnr
	return out({
		'%#CursorLine#',
		'%L',
		_,
		b.filename,
		_,
		'%#LineNr#',
		_,
		b.undotime,
		b.saved,
		_,
		'%#Search#',
		b.readonly,
		'%#LineNr#',
		_,
		'%=',
		'%<',
		b.cwd,
		_,
		'%#CursorLine#',
		_,
		b.layout,
		_,
		'%2p%%',
		_,
		'%#LineNr#'
	})
end
