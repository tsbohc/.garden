local PATH = vim.fn.stdpath('data') .. '/site/pack/ice/'
local GITHUB = 'https://github.com/'
local packages = { }
local M = { }
local active_gits = 0
local Log
Log = function(...)
	return print('Ice:', ...)
end
M.git = function(repo, callback)
	local dir = PATH .. 'data/' .. repo:match('/(.*)')
	if vim.fn.isdirectory(dir) == 0 then
		local handle
		handle = vim.loop.spawn('git', {
			args = {
				'clone',
				GITHUB .. repo .. '.git',
				dir
			}
		}, function()
			Log('clone', repo)
			callback()
			return handle:close()
		end)
	end
end
M.load = function(repo)
	local name = repo:match('/(.*)')
	local dir = PATH .. 'opt/' .. name
	if vim.fn.isdirectory(dir) == 1 then
		vim.cmd('packadd! ' .. name)
		return Log('load', name)
	end
end
M.add = function(...)
	local repo, hook, trigger
	local a = {
		...
	}
	if #a == 1 then
		repo = ...
		trigger = true
	elseif #a == 2 then
		if type(a[1]) == 'string' then
			repo = a[1]
			hook = a[2]
			trigger = true
		elseif type(a[2]) == 'string' then
			trigger = a[1]
			repo = a[2]
			hook = false
		end
	elseif #a == 3 then
		trigger = a[1]
		repo = a[2]
		hook = a[3]
	else
		Log('expected 3 arguments or less!')
		return
	end
	packages[repo] = {
		trigger = trigger,
		hook = hook
	}
	if type(trigger) ~= 'function' and type(hook) == 'function' then
		hook()
	end
	if type(trigger) == 'function' then
		if trigger() == true then
			print('here')
			M.load(repo)
			if type(hook) == 'function' then
				return hook()
			end
		end
	end
end
local ln
ln = function(src, dst)
	return os.execute('ln -s ' .. src .. ' ' .. dst)
end
M.link = function(repo, data)
	local name = repo:match('/(.*)')
	local package = PATH .. 'data/' .. name
	if type(data.trigger) == 'function' then
		ln(package, PATH .. 'opt/' .. name)
		return Log('installed', name, 'into opt/')
	else
		ln(package, PATH .. 'start/' .. name)
		return Log('installed', name, 'into start/')
	end
end
M.recompile = function()
	os.execute('rm -rf ' .. PATH .. 'start/')
	os.execute('mkdir ' .. PATH .. 'start/')
	os.execute('rm -rf ' .. PATH .. 'opt/')
	os.execute('mkdir ' .. PATH .. 'opt/')
	for repo, data in pairs(packages) do
		local name = repo:match('/(.*)')
		local package = PATH .. 'data/' .. name
		if vim.fn.isdirectory(package) ~= 1 then
			M.git(repo, function()
				return M.link(repo, data)
			end)
		else
			M.link(repo, data)
		end
	end
end
vim.cmd([[command! IceRecompile lua require'M'.recompile()]])
return M
