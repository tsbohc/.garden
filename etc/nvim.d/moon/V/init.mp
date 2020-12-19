global V = {}

p = io.popen([[find "$HOME/.config/nvim/lua/V" -type f -printf "%f\n"]])
for file in p\lines()
  print fname
  fname = file\gsub('.lua$', '')
  V[fname] = require 'V/' .. fname

return V

--handle = vim.loop.fs_opendir('/home/sean/.config/nvim/lua/V', nil, 99)
--out = vim.loop.fs_readdir(handle)
--
--for k, v in pairs out
--  fname = v.name\gsub('.lua$', '')
--  V[fname] = require 'V/' .. fname
--
--vim.loop.fs_closedir(handle)
