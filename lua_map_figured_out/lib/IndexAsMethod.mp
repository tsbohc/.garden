global class IndexAsMethod
  new: (callback) =>
    setmetatable(self, {
      __index: (index) =>
        self[index] = (...) ->
          callback index, ...
        rawget self, index
    })
