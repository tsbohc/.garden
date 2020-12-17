require 'lib/IndexAsMethod'

-- TODO make debug a table or better pass it during require

debug = false

log = (...) ->
  if debug
    print 'settings -', ...

return IndexAsMethod (index, value) ->
  get_type = (index) ->
    if pcall(-> return vim.api.nvim_get_option(index))
      return 'o'
    elseif pcall(-> return vim.api.nvim_win_get_option(0, index))
      return 'wo'
    elseif pcall(-> return vim.api.nvim_buf_get_option(0, index))
      return 'bo'
    else
      return 'none'

  t = get_type(index)
  if t == 'none'
    if index\sub(1, 2) == 'no'
      index = index\sub(3)
      t = get_type index

      log 'set:', t, index, '=', false
      vim[t][index] = false
      return
    else
      print 'option not found', t, index
      return

  if value
    log 'set:', t, index, '=', value
    vim[t][index] = value
  else
    log 'set:', t, index, '=', true
    vim[t][index] = true --not vim[t][index]
