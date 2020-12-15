tbl = {}

hand = {
  __index = function(tbl, name)
    tbl[name] = function(...)
      return print(name, ...)
    end
    return rawget(tbl, name) 
  end
}
setmetatable(tbl, hand)

tbl.help("banana","goat")
