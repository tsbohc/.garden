local PATH = vim.fn.stdpath('data') .. '/site/pack/ice/opt/'
local GITHUB = 'https://github.com/'
local packages = { }
local M = { }
local active_gits = 0
local Log
Log = function(...)
	return print('Ice:', ...)
end
M.git = function(repo)
	local dir = PATH .. repo:gsub('/', '_')
	if vim.fn.isdirectory(dir) == 1 then
		return false
	end
	active_gits = active_gits + 1
	local handle
	handle = vim.loop.spawn('git', {
		args = {
			'clone',
			GITHUB .. repo .. '.git',
			dir
		}
	}, vim.schedule_wrap(function()
		active_gits = active_gits - 1
		Log('clone', repo)
		if active_gits == 0 then
			Log('install complete!')
		end
		return handle:close()
	end))
	return true
end
M.load = function(repo)
	return vim.cmd('packadd! ' .. repo:gsub('/', '_'))
end
M.ice = function(...)
	local repo, hook, should
	local a = {
		...
	}
	if #a == 1 then
		repo = ...
	elseif #a == 2 then
		if type(a[1]) == 'string' then
			repo = a[1]
			hook = a[2]
			should = true
		elseif type(a[2]) == 'string' then
			should = a[1]
			repo = a[2]
			hook = false
		end
	elseif #a == 3 then
		should = a[1]
		repo = a[2]
		hook = a[3]
	else
		Log('expected 3 arguments or less!')
		return
	end
	packages[repo] = true
	local dir = PATH .. repo:gsub('/', '_')
	if vim.fn.isdirectory(dir) == 1 then
		if should then
			M.load(repo)
			if hook then
				return hook()
			end
		end
	end
end
M.install = function(repo)
	local status = false
	for repo, _ in pairs(packages) do
		if M.git(repo) then
			status = true
		end
	end
	if status == false then
		return Log('all good!')
	end
end
vim.cmd([[command! IceInstall lua require'M'.install()]])
return M
