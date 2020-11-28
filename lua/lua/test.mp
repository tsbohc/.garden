-- ?

A = {}

setmetatable(A, {
  __index: (k) =>
    return k

  __newindex: (k, v) =>
    print 'new', k, v

  __call: (val) =>
    if type(val) == 'string'
      print 'cal', val
    else
      for k, v in pairs val
        print k, v
})

set = (k, v) ->
  print 'set', k, type(v)

print = print

setfenv(1, A)

A noshowmode
A synmaxcol: 256

return

--o = setmetatable({
--  set: (k) =>
--    print 'set', k
--}, {
--  __index: (k) =>
--    print 'set', k
--
--  __newindex: (k, v) =>
--    print 'set', k, 'to', v
--})
--
--S = ->
--  return
--
--s = {
--  o.noshowmode
--  o.nocompatible
--  arst: 250
--}
--

--  set = vim.api.nvim_set_option
--  get = vim.api.nvim_get_option
--
--  v = setmetatable({
--    --_set: (k) =>
--  }, {
--    __index: (k) =>
--      --@_set k
--      if k\sub(1, 2) == 'no'
--        k = k\sub(3, -1)
--        if get(k) != nil
--          set(k, false)
--          print 'set', k, 'to false'
--      else
--        set(k, true)
--        print 'set', k, 'to true'
--
--    __newindex: (k, v) =>
--      print 'set', k, 'to', v
--  })
--
--  v.noshowmode
--  v.nocompatible
--
--


