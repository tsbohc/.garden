inspect = require "inspect"

local function setfenv(fn, env)
  local i = 1
  while true do
    local name = debug.getupvalue(fn, i)
    if name == "_ENV" then
      debug.upvaluejoin(fn, i, (function()
        return env
      end), 1)
      break
    elseif not name then
      break
    end

    i = i + 1
  end

  return fn
end

--dsl = {
--  test = function(message)
--    print(message)
--  end
--}
--
--local function blossom(fn, ...)
--  setfenv(fn, dsl)
--  fn(...)
--end
--
--blossom(function()
--  test "woooo"
--end)


local function blossom(fn)
  setfenv(fn, setmetatable({
    var = function(opts)
      return opts
    end,
    lyn = function(opts)
      return opts
    end
  }, {
    __index = function(self, tag_name)
      return function(opts)
        return print(tag_name, inspect(opts))
      end
    end
  }))
  return fn()
end

-- {{{
--
--some_varset_id = "some_varset_name" -- renders as function
--
--blossom(function()
--  alacritty {
--    --v { some_varset_id = 1, { a = 1 } }
--    v { some_varset_id } { test = "woo" },
--    v 'a' { a = 1 }
--  }
--end)
--
--local function alacritty()
--  print 'alacritty'
--end
--
--local function with(varsets, module)
--  print(inspect(varsets))
--  return module(opts)
--end
--
--local function module()
--  print 'called module'
--end
--
--with({some_varset_id},
--  alacritty {
--    print "linking" }
--)


-- }}}

blossom(function()
  -- need to shove this here from global somehow
  CONF = '~/.config/'
  colo = "kohi"
  font = "fira"
  local v = {}
  v.font_size 12 -- this could create v["font_size"] = "font_size" and v["font_size"].value = 12

  alacritty {
    var { colo, font, v.font_size },
    lyn { "alacritty.yml",
          CONF .. 'alacritty/alacritty.yml' }
  }

  --alacritty { colo, font },
  --{ 'alacritty.yml', CONF .. 'alacritty/alacritty.yml' }

end)


--add "alacritty.yml", CONF .. 'alacritty/alacritty.yml'

--
--local function alacritty(a)
--  print(a)
--  return function(opts)
--    print(inspect(opts))
--  end
--end
--
----test("name")({ test_var = 1 })
--
--alacritty:init {
--  v { some_varset_id, { a = 1 } }
--}










--local function blossom()
--  alacritty {
--    var { colo, font, { var = 10 } },
--    lyn { alacritty.yml = ~/.config/alacritty/alacritty.yml }
--  }
--end

--alacritty({
--  var({colo, font, { var = 10 }),
--  lyn({alacritty.yml = ~/.config/alacritty/alacritty.yml})
--})
