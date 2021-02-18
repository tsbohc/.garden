-- statusline!

-- TODO: add ft

-- {{{
CursorMoved = 'CursorMoved'
InsertEnter = 'InsertEnter'
InsertLeave = 'InsertLeave'
BufReadPost = 'BufReadPost'
BufEnter = 'BufEnter'
BufWritePost = 'BufWritePost'
-- }}}

add = V.sl.add
initialize = V.sl.init

-- total lines
add { 0, 0, 0, 1, hl: 'CursorLine' }, '%L'

-- filename
add BufEnter, BufWritePost, { 0, 0, 0, 1, hl: 'CursorLine' }, ->
  fname = vim.fn.expand('%:t')
  if fname != ''
    return '‹‹ ' .. fname .. ' ››'

-- saved
add BufEnter, { 1, 0, 0, 0 }, ->
  name = vim.fn.expand('%:t')
  -- TODO find a better way to check if file exists
  if name != '' --and file_exists name
    return [[%{&modified?'':'saved'}]]

-- readonly
add BufEnter, { 1, 0, 1, 1, hl: 'Search' }, ->
  if vim.bo.readonly
    return 'readonly'

-- right hand side
add '%=%<'

-- file location
add BufEnter, BufWritePost, ->
  return vim.fn.expand('%:p:~:h')

-- filetype
add BufReadPost, BufWritePost, { 1, 0, 0, 0 }, ->
  return vim.bo.filetype

-- scroll percentage
add { 1, 0, 1, 1, hl: 'CursorLine' }, '%2p%%'

initialize!
return
