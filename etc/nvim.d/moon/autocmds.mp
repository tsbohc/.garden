CursorMoved = 'CursorMoved'

InsertEnter = 'InsertEnter'
InsertLeave = 'InsertLeave'

BufEnter = 'BufEnter'
BufLeave = 'BufLeave'

BufReadPost = 'BufReadPost'
BufWritePost = 'BufWritePost'

FocusLost = 'FocusLost'
FocusGained = 'FocusGained'

TextYankPost = 'TextYankPost'

FileType = 'FileType'

-- cursorline
V.au { InsertEnter, InsertLeave, BufLeave, FocusLost }, '*', ->
  V.set.nocul!

V.au { InsertLeave, FocusGained }, '*', ->
  if vim.fn.mode! != 'i'
    V.set.cul!

-- yank flash
V.au TextYankPost, '*', ->
  vim.highlight.on_yank { higroup: "Search", timeout: 100 }

-- recompile config
V.au BufWritePost, '~/blueberry/etc/nvim.d/moon/*.mp', ->
  filepath = vim.fn.expand('%:p')
  out = V.capture '!moonshine "' .. filepath .. '"'
  if V.eval('v:shell_error') == 1
    print out

-- force english layout in non-insert modes
--V.au 'InsertLeave', '*', ->
--  G.previous_layout = os.capture [[ setxkbmap -query | awk '/layout/ { print $2 }' ]]
--  if G.previous_layout == 'ru'
--    os.execute [[ setxkbmap us -variant colemak ]]
--
--V.au 'InsertEnter', '*', ->
--  if G.previous_layout == 'ru'
--    os.execute [[ setxkbmap ru ]]

-- open help in a vertical split
V.au FileType, 'help', ->
  V.exec 'wincmd L'

-- default filetype to text
V.au BufEnter, '*', ->
  if vim.bo.filetype == ''
    vim.bo.filetype = 'txt'

return
