local t = require("zest.test")
local zest = require("zest")
_G.zest_tests = {}
local function clear()
  return zest.setup()
end
local function rinput(keys)
  print("\n")
  local raw_keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
  return vim.api.nvim_feedkeys(raw_keys, "mx", false)
end
local function _vlua()
  clear()
  local v
  do
    local ZEST_N_0_ = _G._zest.v["#"]
    local ZEST_ID_0_ = ("_" .. ZEST_N_0_)
    local function _0_()
    end
    _G._zest["v"][ZEST_ID_0_] = _0_
    _G._zest["v"]["#"] = (ZEST_N_0_ + 1)
    v = ("v:lua._zest.v." .. ZEST_ID_0_)
  end
  t["?"](_G._zest.v._1, "store function")
  return t["="](v, "v:lua._zest.v._1", "receive v:lua")
end
_G["zest_tests"]["_vlua"] = _vlua
local function _vlua_format()
  clear()
  local vf
  local function _0_()
    local ZEST_N_0_ = _G._zest.v["#"]
    local ZEST_ID_0_ = ("_" .. ZEST_N_0_)
    local function _1_()
    end
    _G._zest["v"][ZEST_ID_0_] = _1_
    _G._zest["v"]["#"] = (ZEST_N_0_ + 1)
    return ("v:lua._zest.v." .. ZEST_ID_0_)
  end
  vf = string.format(":call %s()", _0_())
  return t["="](vf, ":call v:lua._zest.v._1()", "receive formatted v:lua")
end
_G["zest_tests"]["_vlua-format"] = _vlua_format
local function _smart_concat()
  local s = "bar"
  t["="]("foobar", "foobar", "just a string")
  local _0_
  if (type(s) == "string") then
    _0_ = s
  else
    _0_ = table.concat(s, "")
  end
  t["="]("bar", _0_, "just a var")
  t["="]("foobar", "foobar", "xs with strings")
  t["="]("foobarbaz", ("foo" .. s .. "baz"), "xs with strings and vars")
  t["="]("barbar", (s .. s), "xs with vars")
  t["="]("foo,bar,baz", table.concat({"foo", s, "baz"}, ","), "xs with strings and vars delimited")
  return t["="]("foo", "foo", "string with a delimiter")
end
_G["zest_tests"]["_smart-concat"] = _smart_concat
local function _def_keymap()
  local KEY = "<F4>"
  local CMD = ":lua vim.g.zest_received = true<cr>"
  local TAB = {[KEY] = CMD}
  do
    vim.api.nvim_set_keymap("n", "<F4>", ":lua vim.g.zest_received = true<cr>", {noremap = true, silent = true})
    rinput("<F4>")
    t["?"](vim.g.zest_received, "str -> str")
    vim.g["zest_received"] = false
  end
  do
    vim.api.nvim_set_keymap("n", KEY, CMD, {noremap = true, silent = true})
    rinput("<F4>")
    t["?"](vim.g.zest_received, "var -> var")
    vim.g["zest_received"] = false
  end
  do
    do
      local ZEST_OPTS_0_ = {noremap = true, silent = true}
      vim.api.nvim_set_keymap("n", "<F4>", ":lua vim.g.zest_received = true<cr>", ZEST_OPTS_0_)
    end
    rinput("<F4>")
    t["?"](vim.g.zest_received, " -> tab {str str}")
    vim.g["zest_received"] = false
  end
  do
    local ZEST_OPTS_0_ = {noremap = true, silent = true}
    vim.api.nvim_set_keymap("n", KEY, CMD, ZEST_OPTS_0_)
  end
  rinput("<F4>")
  t["?"](vim.g.zest_received, " -> tab {var var}")
  vim.g["zest_received"] = false
  return nil
end
_G["zest_tests"]["_def-keymap"] = _def_keymap
local function _def_keymap_fn()
  local KEY = "<F4>"
  do
    clear()
    do
      local ZEST_VLUA_0_
      do
        local ZEST_ID_0_ = "_60_70_52_62_110_"
        local function _0_()
          vim.g.zest_received = true
          return nil
        end
        _G._zest["keymap"][ZEST_ID_0_] = _0_
        ZEST_VLUA_0_ = ("v:lua._zest.keymap." .. ZEST_ID_0_)
      end
      local ZEST_RHS_0_ = (":call " .. ZEST_VLUA_0_ .. "()<cr>")
      vim.api.nvim_set_keymap("n", "<F4>", ZEST_RHS_0_, {noremap = true, silent = true})
    end
    rinput("<F4>")
    t["?"](vim.g.zest_received, "str -> bod")
    vim.g["zest_received"] = false
  end
  clear()
  do
    local ZEST_VLUA_0_
    do
      local ZEST_ID_0_
      local function _0_(ZEST_C_0_)
        return (string.byte(ZEST_C_0_) .. "_")
      end
      ZEST_ID_0_ = ("_" .. string.gsub((KEY .. "n"), ".", _0_))
      local function _1_()
        vim.g.zest_received = true
        return nil
      end
      _G._zest["keymap"][ZEST_ID_0_] = _1_
      ZEST_VLUA_0_ = ("v:lua._zest.keymap." .. ZEST_ID_0_)
    end
    local ZEST_RHS_0_ = (":call " .. ZEST_VLUA_0_ .. "()<cr>")
    vim.api.nvim_set_keymap("n", KEY, ZEST_RHS_0_, {noremap = true, silent = true})
  end
  rinput("<F4>")
  t["?"](vim.g.zest_received, "var -> bod")
  vim.g["zest_received"] = false
  return nil
end
_G["zest_tests"]["_def-keymap-fn"] = _def_keymap_fn
local function _def_autocmd()
  local EVENT = "User"
  local SELECTOR = "ZestTestUserEvent"
  local CMD = ":lua vim.g.zest_received = true"
  do
    do
      vim.cmd("augroup ZestTestAugroup")
      vim.cmd("autocmd!")
      do
        vim.cmd("au User ZestTestUserEvent :lua vim.g.zest_received = true")
      end
      vim.cmd("augroup END")
    end
    vim.cmd("doautocmd User ZestTestUserEvent")
    t["?"](vim.g.zest_received, "str str -> str")
    vim.g["zest_received"] = false
  end
  do
    vim.cmd("augroup ZestTestAugroup")
    vim.cmd("autocmd!")
    do
      local _0_
      if (type(EVENT) == "string") then
        _0_ = EVENT
      else
        _0_ = table.concat(EVENT, ",")
      end
      local _2_
      if (type(SELECTOR) == "string") then
        _2_ = SELECTOR
      else
        _2_ = table.concat(SELECTOR, ",")
      end
      vim.cmd(("au " .. _0_ .. " " .. _2_ .. " " .. CMD))
    end
    vim.cmd("augroup END")
  end
  vim.cmd("doautocmd User ZestTestUserEvent")
  t["?"](vim.g.zest_received, "var var -> var")
  vim.g["zest_received"] = false
  return nil
end
_G["zest_tests"]["_def-autocmd"] = _def_autocmd
local function _def_autocmd_fn()
  local EVENT = "User"
  local SELECTOR = "ZestTestUserEvent"
  do
    clear()
    do
      vim.cmd("augroup ZestTestAugroup")
      vim.cmd("autocmd!")
      do
        local ZEST_VLUA_0_
        do
          local ZEST_N_0_ = _G._zest.autocmd["#"]
          local ZEST_ID_0_ = ("_" .. ZEST_N_0_)
          local function _0_()
            vim.g.zest_received = true
            return nil
          end
          _G._zest["autocmd"][ZEST_ID_0_] = _0_
          _G._zest["autocmd"]["#"] = (ZEST_N_0_ + 1)
          ZEST_VLUA_0_ = ("v:lua._zest.autocmd." .. ZEST_ID_0_)
        end
        vim.cmd(("autocmd User ZestTestUserEvent :call " .. ZEST_VLUA_0_ .. "()"))
      end
      vim.cmd("augroup END")
    end
    vim.cmd("doautocmd User ZestTestUserEvent")
    t["?"](vim.g.zest_received, "str str -> bod")
    vim.g["zest_received"] = false
  end
  clear()
  do
    vim.cmd("augroup ZestTestAugroup")
    vim.cmd("autocmd!")
    do
      local ZEST_VLUA_0_
      do
        local ZEST_N_0_ = _G._zest.autocmd["#"]
        local ZEST_ID_0_ = ("_" .. ZEST_N_0_)
        local function _0_()
          vim.g.zest_received = true
          return nil
        end
        _G._zest["autocmd"][ZEST_ID_0_] = _0_
        _G._zest["autocmd"]["#"] = (ZEST_N_0_ + 1)
        ZEST_VLUA_0_ = ("v:lua._zest.autocmd." .. ZEST_ID_0_)
      end
      local _0_
      if (type(EVENT) == "string") then
        _0_ = EVENT
      else
        _0_ = table.concat(EVENT, ",")
      end
      local _2_
      if (type(SELECTOR) == "string") then
        _2_ = SELECTOR
      else
        _2_ = table.concat(SELECTOR, ",")
      end
      vim.cmd(("autocmd " .. _0_ .. " " .. _2_ .. " :call " .. ZEST_VLUA_0_ .. "()"))
    end
    vim.cmd("augroup END")
  end
  vim.cmd("doautocmd User ZestTestUserEvent")
  t["?"](vim.g.zest_received, "var var -> bod")
  vim.g["zest_received"] = false
  return nil
end
_G["zest_tests"]["_def-autocmd-fn"] = _def_autocmd_fn
for k, v in pairs(_G.zest_tests) do
  print(("" .. k))
  v()
end
return clear()