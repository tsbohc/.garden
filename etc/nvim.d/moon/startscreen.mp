image = '/home/sean/phos.txt'

setlocal = (opt) ->
  vim.cmd 'setlocal ' .. opt

append = (line) ->
  vim.fn.append('$', line)

print_center = (data) ->
  max_length = 0
  for k, v in pairs data
    --v_len = v\len!
    _, v_len = string.gsub(v, "[^\128-\193]", "")
    if max_length < v_len
      max_length = v_len

  W = vim.fn.winwidth(0)
  padding = ' '\rep((W - max_length) / 2)

  for k, v in pairs data
    append padding .. v

startscreen = () ->
  if vim.fn.argc() == 1
    return
  if vim.fn.line2byte('$') != -1
    return
  if vim.o.insertmode
    return
  setlocal 'bufhidden=wipe'
  setlocal 'buftype=nofile'
  setlocal 'nobuflisted'
  setlocal 'nocursorcolumn'
  setlocal 'nocursorline'
  setlocal 'nolist'
  setlocal 'nonumber'
  setlocal 'noswapfile'
  setlocal 'norelativenumber'
  --setlocal 'laststatus=0'
  --setlocal 'noshowmode'
  --setlocal 'noshowcmd'
  --setlocal 'cmdheight=1'

  vim.cmd [[syntax match StNumber /\v\s*\[\zs\d\ze\]/]]
  vim.cmd [[syntax match StBracket /\v\s*\[.*\]/ contains=StNumber]]
  vim.cmd [[syntax match StSlash /\v\//]]
  vim.cmd [[syntax match StPath /\s\zs.*\/\ze/ contains=StSlash]]

  vim.cmd [[highlight link StBracket Conceal]]
  vim.cmd [[highlight link StNumber None]]
  vim.cmd [[highlight link StSlash Conceal]]
  vim.cmd [[highlight link StPath Comment]]

  W = vim.fn.winwidth(0)

  ilines = {}
  for line in io.lines(image)
    table.insert(ilines, line)

  print_center(ilines)

  append ' '

  oldfiles_string = vim.api.nvim_get_vvar('oldfiles')
  oldfiles = {}

  oldfiles_length = 0
  count = 0
  for k, v in pairs oldfiles_string
    if count > 8
      break
    if v\match('/runtime/doc/') -- ignore docs
      continue
    v_len = v\len!
    if oldfiles_length < v_len
      oldfiles_length = v_len

  oldfiles_padding = ' '\rep((W - oldfiles_length) / 2 + 5)

  count = 0
  for k, v in pairs oldfiles_string
    if count > 8
      break
    if v\match('/runtime/doc/') -- ignore docs
      continue
    count += 1
    append oldfiles_padding .. '[' .. count .. ']' .. ' ' .. vim.fn.fnamemodify(v, ':~')
    --V.map.n tostring(count), ':edit ' .. v .. '<cr>'
    vim.cmd 'nnoremap <buffer><silent> ' .. tostring(count) .. ' :edit ' .. v .. '<cr>'

  setlocal 'nomodifiable'
  setlocal 'nomodified'

  vim.api.nvim_exec(
[[
nnoremap <buffer><silent> l :enew <bar> startinsert<CR>
nnoremap <buffer><silent> o :enew <bar> startinsert<CR>
nnoremap <buffer><silent> a :enew <bar> startinsert<CR>
nnoremap <buffer><silent> s :enew <bar> startinsert<CR>
nnoremap <buffer><silent> q :q<CR>
]], false)


V.au 'VimEnter', '*', startscreen

--V.au 'VimEnter', '*', ->
--  oldfiles = vim.api.nvim_get_vvar('oldfiles')
--  for k, v in pairs oldfiles
--    if k > 9
--      return
--    print k, v




