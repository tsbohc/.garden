local b = vim.b
__modules = { }
S = { }
local process_module
process_module = function(name)
	local out = __modules[name]()
	if out then
		b[name] = out
	else
		b[name] = ''
	end
end
S = {
	mod = function(event, name, command)
		if __modules[name] then
			print('S.mod: module with the name \'' .. name .. '\' already exists!')
			print('skipping...')
			return
		end
		__modules[name] = command
		return V.au(event, '*', function()
			return process_module(name)
		end)
	end
}
S.mod('User UndoRedo', 'undotime', function()
	return V.getundotime()
end)
S.mod('BufEnter', 'readonly', function()
	return [[%{&readonly?' readonly ':''}]]
end)
S.mod({
	'BufEnter',
	'BufWritePost'
}, 'filetype', function()
	return vim.bo.filetype
end)
S.mod({
	'BufEnter',
	'BufWritePost'
}, 'cwd', function()
	return fn.expand('%:p:~:h') .. '/'
end)
S.mod({
	'BufEnter',
	'BufWritePost'
}, 'filename', function()
	local name = fn.expand('%:t')
	if name ~= '' then
		return '‹‹ ' .. name .. ' ››'
	end
end)
S.mod({
	'User UndoRedo',
	'BufEnter',
	'BufWritePost'
}, 'saved', function()
	local name = fn.expand('%:t')
	if name ~= '' then
		return [[%{&modified?'':',, saved'}]]
	end
end)
S.mod({
	'InsertEnter',
	'InsertLeave'
}, 'layout', function()
	if G.previous_layout == 'ru' then
		return 'ru '
	end
end)
b.lines = '%L'
b.percentage = '%2p%%'
V.au({
	'BufEnter',
	'BufLeave',
	'BufWritePost',
	'CursorMoved',
	'CursorMovedI',
	'InsertEnter',
	'InsertLeave',
	'TextChanged',
	'TextChangedI'
}, '*', function()
	return V.redrawstatus()
end)
local out
out = function(data)
	local _out = ''
	for _, k in pairs(data) do
		_out = _out .. k
	end
	return _out
end
statusline = function()
	local _ = [[ ]]
	return out({
		'%#CursorLine#',
		b.lines,
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
		b.percentage,
		_,
		'%#LineNr#'
	})
end
