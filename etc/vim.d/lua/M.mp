PATH = vim.fn.stdpath('data') .. '/site/pack/ice/opt/'
GITHUB = 'https://github.com/'

packages = {}
M = {}

active_gits = 0

Log = (...) ->
  print 'Ice:', ...

M.git = (repo) ->
  dir = PATH .. repo\gsub '/', '_'

  if vim.fn.isdirectory(dir) == 1
    return false

  active_gits += 1

  local handle
  handle = vim.loop.spawn 'git', args: {
    'clone'
    GITHUB .. repo .. '.git'
    dir
  }, vim.schedule_wrap ->
    active_gits -= 1
    Log 'clone', repo
    if active_gits == 0
      Log 'install complete!'
    handle\close!

  return true

M.load = (repo) ->
  vim.cmd 'packadd! ' .. repo\gsub '/', '_'
  --Log 'load', repo

M.ice = (...) ->
  local repo, hook, should
  a = {...}
  if #a == 1
    repo = ...
  elseif #a == 2
    if type(a[1]) == 'string'
      repo = a[1]
      hook = a[2]
      should = true
    elseif type(a[2]) == 'string'
      should = a[1]
      repo = a[2]
      hook = false
  elseif #a == 3
    should = a[1]
    repo = a[2]
    hook = a[3]
  else
    Log 'expected 3 arguments or less!'
    return

  packages[repo] = true

  dir = PATH .. repo\gsub '/', '_'

  if vim.fn.isdirectory(dir) == 1
    if should
      M.load repo
      if hook
        hook!

M.install = (repo) ->
  status = false
  for repo, _ in pairs packages
    if M.git repo
      status = true
  if status == false
    Log 'all good!'

vim.cmd [[command! IceInstall lua require'M'.install()]]

return M
