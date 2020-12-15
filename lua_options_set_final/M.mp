PATH = vim.fn.stdpath('data') .. '/site/pack/ice/'
GITHUB = 'https://github.com/'

packages = {}
M = {}

active_gits = 0

Log = (...) ->
  print 'Ice:', ...

M.git = (repo, callback) ->
  dir = PATH .. 'data/' .. repo\match '/(.*)'

  if vim.fn.isdirectory(dir) == 0
    local handle
    handle = vim.loop.spawn 'git', args: {
      'clone'
      GITHUB .. repo .. '.git'
      dir
    --}, vim.schedule_wrap ->
    }, ->
      Log 'clone', repo
      callback!
      handle\close!

M.load = (repo) ->
  name = repo\match '/(.*)'
  dir = PATH .. 'opt/' .. name
  if vim.fn.isdirectory(dir) == 1
    --vim.cmd 'set runtimepath+=' .. dir
    vim.cmd 'packadd! ' .. name
    Log 'load', name

M.add = (...) ->
  local repo, hook, trigger
  a = {...}
  if #a == 1
    repo = ...
    trigger = true
  elseif #a == 2
    if type(a[1]) == 'string'
      repo = a[1]
      hook = a[2]
      trigger = true
    elseif type(a[2]) == 'string'
      trigger = a[1]
      repo = a[2]
      hook = false
  elseif #a == 3
    trigger = a[1]
    repo = a[2]
    hook = a[3]
  else
    Log 'expected 3 arguments or less!'
    return

  packages[repo] = { :trigger, :hook }

  if type(trigger) != 'function' and type(hook) == 'function'
    hook!

  if type(trigger) == 'function'
    if trigger! == true
      print 'here'
      M.load repo
      if type(hook) == 'function'
        hook!

  --dir = PATH .. 'opt/' .. repo\gsub '/', '_'

  --if vim.fn.isdirectory(dir) == 1
  --  if trigger
  --    M.load repo
  --    if hook
  --      hook!

ln = (src, dst) ->
  os.execute('ln -s ' .. src .. ' ' .. dst)

M.link = (repo, data) ->
  name = repo\match '/(.*)'
  package = PATH .. 'data/' .. name

  if type(data.trigger) == 'function'
    ln package, PATH .. 'opt/' .. name
    Log 'installed', name, 'into opt/'
    -- add to rtp
  else
    ln package, PATH .. 'start/' .. name
    Log 'installed', name, 'into start/'

M.recompile = ->
  -- todo
  os.execute('rm -rf ' .. PATH .. 'start/')
  os.execute('mkdir ' .. PATH .. 'start/')
  os.execute('rm -rf ' .. PATH .. 'opt/')
  os.execute('mkdir ' .. PATH .. 'opt/')

  for repo, data in pairs packages

    name = repo\match '/(.*)'
    package = PATH .. 'data/' .. name

    if vim.fn.isdirectory(package) != 1
      M.git repo, ->
        M.link repo, data
    else
      M.link repo, data

  --Log 'recompile complete!'

--vim.cmd [[command! IceInstall lua require'M'.install()]]
vim.cmd [[command! IceRecompile lua require'M'.recompile()]]

return M
