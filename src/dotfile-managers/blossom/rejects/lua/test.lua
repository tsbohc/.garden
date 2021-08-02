#!/usr/bin/env lua

inspect = require "inspect"

-- {{{
local Set = {}
function Set.new()
  local reverse = {}
  local set = {}

  return setmetatable(set, {
    __index = {
      insert = function(set, value)
        if not reverse[value] then
          table.insert(set, value)
          reverse[value] = #set
        end
      end,
      remove = function(set, value)
        local index = reverse[value]
        if index then
          reverse[value] = nil
          -- pop the top element off the set
          local top = table.remove(set)
          if top ~= value then
            -- if it's not the element that we actually want to remove,
            -- put it back into the set at the index of the element that we
            -- do want to remove, replacing it
            reverse[top] = index
            set[index] = top
          end
        end
      end,
      contains = function(set, value)
        return reverse[value] ~= nil
      end
    }
  })
end
-- }}}

function with(path, mode, fn)
  local file = io.open(path, mode)
  fn(file)
  file:close()
end

function get(f)
  local v = _G
  for w in string.gmatch(f, "[%w_]+") do
    if v == nil then
      return nil
    else
      v = v[w]
    end
  end
  return v
end

do
  function lit(str)
    return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function(c) return "%" .. c end)
  end
  local mt = getmetatable("")
  mt.__index["lit"] = lit
end


syntax = {
  p = { l = "{@:-",  r = "-:@}" },
  v = { l = "{",     r = "}" },
  e = { l = "{@!-",  r = "-!@}" }
}

varsets = {}


-------------- varset --------------

Varset = {}
function Varset.load(varset)
  if not varsets[varset] == nil then return end
  varsets[varset] = {}

  with("varsets/" .. varset, "r", function(f)
    for line in f:lines() do
      -- skip comments and empty lines
      if not line:match("%s*!") and line ~= "" then
        local key, value = line:match("(%w+):%s*(%w+)")
        varsets[varset][key] = value
      end
    end
  end)
end

function Varset.get(node_path)

end






(print (inspect (varset :kohi)))

-------------- template --------------

Template = {}
function Template.parse(str)
  local varsets = Set.new()
  local patterns = {}

  for pattern in str:gmatch(string.lit("{@:-") .. "(.-)" .. string.lit("-:@}")) do
    -- patterns are deterministic, no use keeping doubles
    if patterns[pattern] == nil then
      local parsed = pattern

      -- if needed, replace {var} with var's value
      local variable = parsed:match("{" .. "(.-)" .. "}")
      if variable ~= nil then
        local value = get(variable)
        if value ~= nil then
          parsed = parsed:gsub("{" .. variable .. "}", value)
        else
          print("variable '" .. variable .. "' is not defined!")
        end
      end

      -- grab varset's name
      local varset = parsed:match("(%a+)%.")
      if varset ~= nil then
        Varset.load(varset)
        parsed = get("varsets." .. parsed)
      end

      patterns[syntax.p.l .. pattern .. syntax.p.r] = parsed
    end
  end
  return patterns
end



font = {
  family = "fira"
}

colo = "whoah"



local f = assert(io.open("testrc", "rb"))
local content = f:read("*all")
patterns = Template.parse(content)

print(inspect(patterns))
print(inspect(varsets))

f:close()

--local function slurp(path)
--    local f = io.open(path)
--    local s = f:read("*a")
--    f:close()
--    return s
--end
--
--function literalize(str)
--    return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function(c) return "%" .. c end)
--end
--
--with("rc", "r+", function(file)
--  local collecting = false
--  local block_id = 0
--  local result = {}
--  local linenr = 0
--  local file_str = slurp("rc")
--
--  for line in file:lines() do
--    linenr = linenr + 1
--    if line == "-!@}" then
--      collecting = false
--      result[block_id].enda = linenr
--    end
--    if collecting then
--      --local l = line:gsub("=> ", "p:target ")
--      local l = line
--      result[block_id].data = result[block_id].data .. l .. "\n"
--    end
--    if line == "{@!-" then
--      collecting = true
--      block_id = block_id + 1
--      result[block_id] = {}
--      result[block_id].data = ""
--      result[block_id].start = linenr
--    end
--  end
--  --print(inspect(result))
--  _a = load(result[1].data) -- method should be very secure else it could loop on itself or call something else, should also be local
--  r = _a()
--
--  file_str = string.gsub(file_str, literalize("{@!-" .. "\n" .. result[1].data .. "-!@}"), r)
--  print(file_str)
--end)























find all petals in ENV directory
  loop over petals -- petal.install
    open path
    determine target

    loop over patterns file contents -- petal.patterns
      parse pattern                  -- pattern.parse
      compile pattern                -- pattern.compile
        figure out varset name
        load varset when needed      -- varset.load
        retrieve value from varset   -- Varset.get_value
        put into the table of key =pattern, value =compiled -- pattern.store
    replace based on dict in file string -- petal.compile
      write the output to compiled dir
    symlink the file to destination       -- petal.symlink


petals = {
  { 
    name = "file-name",
    source = "source-path",
    target = "output-target",
    data = { "pattern" = "compiled pattern", ... },
    -- do i need this? do i store string names or tables?
    -- probably tables? but i've already compiled patterns so why?
    -- varsets = { }
  },
  ...
}

detect when petal is modified
  install petal
    warn in the vim split when something goes wrong













---- {{{
--local function setfenv(fn, env)
--  local i = 1
--  while true do
--    local name = debug.getupvalue(fn, i)
--    if name == "_ENV" then
--      debug.upvaluejoin(fn, i, (function()
--        return env
--      end), 1)
--      break
--    elseif not name then
--      break
--    end
--    i = i + 1
--  end
--  return fn
--end
---- }}}
--
--petals = {}
--
--classPetal = {}
--classPetal.__index = classPetal
--
--function classPetal:new(name)
--  return setmetatable({ name = name }, classPetal)  -- make Petal handle lookup
--end
--
--function classPetal:target(target)
--  self.target = target
--end
--
--local function Petal(name)
--  local p = classPetal:new(name)
--  petals[name] = p
--  return p
--end
--
--p = Petal "alacritty"
--p:target "ta"
--
--print(inspect(petals))
--
--
--
--
--
--petals = {}
--
--classPetal = {}
--classPetal.__index = classPetal
--
--function classPetal:new(name)
--  return setmetatable({ name = name }, classPetal)  -- make Petal handle lookup
--end
--
--function classPetal:target(target)
--  self.target = target
--end
--
--local function Petal(name)
--  local p = classPetal:new(name)
--  petals[name] = p
--  return p
--end
--
--p = Petal "alacritty"
--p:target "ta"
--
--print(inspect(petals))
--





--defaults = {
--  inject = true,
--  install = true
--}
--
--
--local function setfenv(fn, env)
--  local i = 1
--  while true do
--    local name = debug.getupvalue(fn, i)
--    if name == "_ENV" then
--      debug.upvaluejoin(fn, i, (function()
--        return env
--      end), 1)
--      break
--    elseif not name then
--      break
--    end
--    i = i + 1
--  end
--  return fn
--end
--
--
--
--
--local function blossom(fn)
--  setfenv(fn, setmetatable({
--    install = function()
--      return { install = true }
--    end,
--    use = function(m)
--      print(inspect(m))
--    end
--  }, {
--    __index = function(self, tag_name)
--      return tag_name
--    end
--  }))
--  return fn()
--end
--
--
--blossom(function()
--  use { alacritty } { install }
--end)

--petals = {}
--local petals.alacritty = function()
--  print "wooo"
--end
--
--petals.alacritty()
--














--Petal = {}
--Petal.__index = Petal
--
--function Petal:new(name)
--  return setmetatable({ name = name }, Petal)  -- make Petal handle lookup
--end
--
--function Petal:target(target)
--  self.target = target
--end
--
--petals = {}
--
--p = Petal:new("aaa")
--p:target("a")
--petals["a"] = p
--
--p = Petal:new("bbb")
--p:target("b")
--petals["b"] = p
--
--s = [[:target "~/.config/alacritty/alacritty.yml"]]
--s = "p" .. s
--
--p = Petal:new "alacritty"
--a = load(s)
--a()
--petals["alacritty"] = p
--
--
--print(inspect(petals))








--local vv = "_v"
--
--local function test(t)
--  print(inspect(t))
--  return function(f)
--    print(inspect(f))
--  end
--end




