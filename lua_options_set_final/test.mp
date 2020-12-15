class IndexAsMethod
  new: (callback) =>
    setmetatable(self, {
      __index: (index) =>
        self[index] = (...) ->
          callback index, ...
        rawget self, index
    })
--
--s = IndexAsMethod (index, ...) ->
--  print index, ...
--
--s.anytext 'argument1', 1, 'argument3'
--s.noarg!
