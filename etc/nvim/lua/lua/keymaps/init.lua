vim.g["mapleader"] = " "
do
  local ZEST_VLUA_0_
  do
    local ZEST_ID_0_ = "_101_110_118_"
    local function _0_()
      if (vim.v.count > 0) then
        return "k"
      else
        return "gk"
      end
    end
    _G._zest["keymap"][ZEST_ID_0_] = _0_
    ZEST_VLUA_0_ = ("v:lua._zest.keymap." .. ZEST_ID_0_)
  end
  local ZEST_RHS_0_ = (ZEST_VLUA_0_ .. "()")
  local ZEST_OPTS_0_ = {expr = true, noremap = true}
  vim.api.nvim_set_keymap("n", "e", ZEST_RHS_0_, ZEST_OPTS_0_)
  vim.api.nvim_set_keymap("v", "e", ZEST_RHS_0_, ZEST_OPTS_0_)
end
do
  local ZEST_VLUA_0_
  do
    local ZEST_ID_0_ = "_110_110_118_"
    local function _0_()
      if (vim.v.count > 0) then
        return "j"
      else
        return "gj"
      end
    end
    _G._zest["keymap"][ZEST_ID_0_] = _0_
    ZEST_VLUA_0_ = ("v:lua._zest.keymap." .. ZEST_ID_0_)
  end
  local ZEST_RHS_0_ = (ZEST_VLUA_0_ .. "()")
  local ZEST_OPTS_0_ = {expr = true, noremap = true}
  vim.api.nvim_set_keymap("n", "n", ZEST_RHS_0_, ZEST_OPTS_0_)
  vim.api.nvim_set_keymap("v", "n", ZEST_RHS_0_, ZEST_OPTS_0_)
end
do
  local ZEST_OPTS_0_ = {noremap = true}
  vim.api.nvim_set_keymap("o", "n", "j", ZEST_OPTS_0_)
  vim.api.nvim_set_keymap("o", "e", "k", ZEST_OPTS_0_)
end
local n = "m"
do
  local ZEST_VLUA_0_
  do
    local ZEST_ID_0_
    local function _0_(ZEST_C_0_)
      return (string.byte(ZEST_C_0_) .. "_")
    end
    ZEST_ID_0_ = ("_" .. string.gsub((n .. "nv"), ".", _0_))
    local function _1_()
      return print("ya")
    end
    _G._zest["keymap"][ZEST_ID_0_] = _1_
    ZEST_VLUA_0_ = ("v:lua._zest.keymap." .. ZEST_ID_0_)
  end
  local ZEST_RHS_0_ = (":call " .. ZEST_VLUA_0_ .. "()<cr>")
  local ZEST_OPTS_0_ = {noremap = true}
  vim.api.nvim_set_keymap("n", n, ZEST_RHS_0_, ZEST_OPTS_0_)
  vim.api.nvim_set_keymap("v", n, ZEST_RHS_0_, ZEST_OPTS_0_)
end
do
  local ZEST_OPTS_0_ = {noremap = true}
  vim.api.nvim_set_keymap("n", "E", "<c-u>", ZEST_OPTS_0_)
  vim.api.nvim_set_keymap("v", "E", "<c-u>", ZEST_OPTS_0_)
  vim.api.nvim_set_keymap("n", "N", "<c-d>", ZEST_OPTS_0_)
  vim.api.nvim_set_keymap("v", "N", "<c-d>", ZEST_OPTS_0_)
end
do
  local ZEST_OPTS_0_ = {noremap = true}
  vim.api.nvim_set_keymap("n", "H", "0", ZEST_OPTS_0_)
  vim.api.nvim_set_keymap("v", "H", "0", ZEST_OPTS_0_)
end
do
  local ZEST_OPTS_0_ = {noremap = true}
  vim.api.nvim_set_keymap("n", "I", "$", ZEST_OPTS_0_)
  vim.api.nvim_set_keymap("v", "I", "$", ZEST_OPTS_0_)
end
do
  local ZEST_OPTS_0_ = {noremap = true}
  vim.api.nvim_set_keymap("n", "<ScrollWheelUp>", "<c-y>", ZEST_OPTS_0_)
  vim.api.nvim_set_keymap("v", "<ScrollWheelUp>", "<c-y>", ZEST_OPTS_0_)
  vim.api.nvim_set_keymap("n", "<ScrollWheelDown>", "<c-e>", ZEST_OPTS_0_)
  vim.api.nvim_set_keymap("v", "<ScrollWheelDown>", "<c-e>", ZEST_OPTS_0_)
end
do
  local ZEST_OPTS_0_ = {noremap = true}
  vim.api.nvim_set_keymap("n", "<c-h>", "<c-w>h", ZEST_OPTS_0_)
  vim.api.nvim_set_keymap("n", "<c-i>", "<c-w>l", ZEST_OPTS_0_)
  vim.api.nvim_set_keymap("n", "<c-e>", "<c-w>k", ZEST_OPTS_0_)
  vim.api.nvim_set_keymap("n", "<c-n>", "<c-w>j", ZEST_OPTS_0_)
end
do
  local ZEST_OPTS_0_ = {noremap = true, silent = true}
  vim.api.nvim_set_keymap("n", "//", ":nohlsearch<cr>", ZEST_OPTS_0_)
  vim.api.nvim_set_keymap("v", "//", ":nohlsearch<cr>", ZEST_OPTS_0_)
end
do
  local ZEST_VLUA_0_
  do
    local ZEST_ID_0_ = "_42_110_"
    local function _0_()
      local p = vim.fn.getpos(".")
      vim.cmd("norm! *")
      return vim.fn.setpos(".", p)
    end
    _G._zest["keymap"][ZEST_ID_0_] = _0_
    ZEST_VLUA_0_ = ("v:lua._zest.keymap." .. ZEST_ID_0_)
  end
  local ZEST_RHS_0_ = (":call " .. ZEST_VLUA_0_ .. "()<cr>")
  vim.api.nvim_set_keymap("n", "*", ZEST_RHS_0_, {noremap = true})
end
do
  local ZEST_VLUA_0_
  do
    local ZEST_ID_0_ = "_42_120_"
    local function _0_()
      local p = vim.fn.getpos(".")
      vim.cmd("norm! gvy")
      vim.cmd(("/" .. vim.api.nvim_eval("@\"")))
      return vim.fn.setpos(".", p)
    end
    _G._zest["keymap"][ZEST_ID_0_] = _0_
    ZEST_VLUA_0_ = ("v:lua._zest.keymap." .. ZEST_ID_0_)
  end
  local ZEST_RHS_0_ = (":call " .. ZEST_VLUA_0_ .. "()<cr>")
  vim.api.nvim_set_keymap("x", "*", ZEST_RHS_0_, {noremap = true})
end
vim.api.nvim_set_keymap("n", "<leader>r", ":%s///g<left><left>", {noremap = true})
vim.api.nvim_set_keymap("x", "<leader>r", ":s///g<left><left>", {noremap = true})
do
  local ZEST_OPTS_0_ = {noremap = true}
  vim.api.nvim_set_keymap("x", "<", "<gv", ZEST_OPTS_0_)
  vim.api.nvim_set_keymap("x", ">", ">gv", ZEST_OPTS_0_)
end
vim.api.nvim_set_keymap("n", "Y", "y$", {noremap = true})
vim.api.nvim_set_keymap("n", "U", "<c-r>", {noremap = true})
vim.api.nvim_set_keymap("n", "<c-j>", "J", {noremap = true})
local ZEST_OPTS_0_ = {noremap = true}
vim.api.nvim_set_keymap("n", "i", "l", ZEST_OPTS_0_)
vim.api.nvim_set_keymap("v", "i", "l", ZEST_OPTS_0_)
vim.api.nvim_set_keymap("o", "i", "l", ZEST_OPTS_0_)
vim.api.nvim_set_keymap("n", "f", "e", ZEST_OPTS_0_)
vim.api.nvim_set_keymap("v", "f", "e", ZEST_OPTS_0_)
vim.api.nvim_set_keymap("o", "f", "e", ZEST_OPTS_0_)
vim.api.nvim_set_keymap("n", "J", "F", ZEST_OPTS_0_)
vim.api.nvim_set_keymap("v", "J", "F", ZEST_OPTS_0_)
vim.api.nvim_set_keymap("o", "J", "F", ZEST_OPTS_0_)
vim.api.nvim_set_keymap("n", "L", "I", ZEST_OPTS_0_)
vim.api.nvim_set_keymap("v", "L", "I", ZEST_OPTS_0_)
vim.api.nvim_set_keymap("o", "L", "I", ZEST_OPTS_0_)
vim.api.nvim_set_keymap("n", "k", "n", ZEST_OPTS_0_)
vim.api.nvim_set_keymap("v", "k", "n", ZEST_OPTS_0_)
vim.api.nvim_set_keymap("o", "k", "n", ZEST_OPTS_0_)
vim.api.nvim_set_keymap("n", "F", "E", ZEST_OPTS_0_)
vim.api.nvim_set_keymap("v", "F", "E", ZEST_OPTS_0_)
vim.api.nvim_set_keymap("o", "F", "E", ZEST_OPTS_0_)
vim.api.nvim_set_keymap("n", "j", "f", ZEST_OPTS_0_)
vim.api.nvim_set_keymap("v", "j", "f", ZEST_OPTS_0_)
vim.api.nvim_set_keymap("o", "j", "f", ZEST_OPTS_0_)
vim.api.nvim_set_keymap("n", "l", "i", ZEST_OPTS_0_)
vim.api.nvim_set_keymap("v", "l", "i", ZEST_OPTS_0_)
vim.api.nvim_set_keymap("o", "l", "i", ZEST_OPTS_0_)
vim.api.nvim_set_keymap("n", "K", "N", ZEST_OPTS_0_)
vim.api.nvim_set_keymap("v", "K", "N", ZEST_OPTS_0_)
return vim.api.nvim_set_keymap("o", "K", "N", ZEST_OPTS_0_)