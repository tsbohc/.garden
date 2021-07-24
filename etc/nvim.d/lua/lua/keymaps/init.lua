vim.g["mapleader"] = " "
do
  local ZEST_VLUA_0_
  do
    local ZEST_ID_0_ = "_101_"
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
  local ZEST_RHS_0_ = string.format("%s()", ZEST_VLUA_0_)
  for ZEST_M_0_ in string.gmatch("nv", ".") do
    vim.api.nvim_set_keymap(ZEST_M_0_, "e", ZEST_RHS_0_, {expr = true, noremap = true})
  end
end
do
  local ZEST_VLUA_0_
  do
    local ZEST_ID_0_ = "_110_"
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
  local ZEST_RHS_0_ = string.format("%s()", ZEST_VLUA_0_)
  for ZEST_M_0_ in string.gmatch("nv", ".") do
    vim.api.nvim_set_keymap(ZEST_M_0_, "n", ZEST_RHS_0_, {expr = true, noremap = true})
  end
end
do
  vim.api.nvim_set_keymap("o", "n", "j", {noremap = true})
  vim.api.nvim_set_keymap("o", "e", "k", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "E", "<c-u>", {noremap = true})
  vim.api.nvim_set_keymap("v", "E", "<c-u>", {noremap = true})
  vim.api.nvim_set_keymap("n", "N", "<c-d>", {noremap = true})
  vim.api.nvim_set_keymap("v", "N", "<c-d>", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "H", "0", {noremap = true})
  vim.api.nvim_set_keymap("v", "H", "0", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "I", "$", {noremap = true})
  vim.api.nvim_set_keymap("v", "I", "$", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "<ScrollWheelUp>", "<c-y>", {noremap = true})
  vim.api.nvim_set_keymap("v", "<ScrollWheelUp>", "<c-y>", {noremap = true})
  vim.api.nvim_set_keymap("n", "<ScrollWheelDown>", "<c-e>", {noremap = true})
  vim.api.nvim_set_keymap("v", "<ScrollWheelDown>", "<c-e>", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "<c-h>", "<c-w>h", {noremap = true})
  vim.api.nvim_set_keymap("n", "<c-i>", "<c-w>l", {noremap = true})
  vim.api.nvim_set_keymap("n", "<c-e>", "<c-w>k", {noremap = true})
  vim.api.nvim_set_keymap("n", "<c-n>", "<c-w>j", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "//", ":nohlsearch<cr>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("v", "//", ":nohlsearch<cr>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "*", "*N", {noremap = true, silent = true})
end
do
  local ZEST_VLUA_0_
  do
    local ZEST_ID_0_ = "_42_"
    local function _0_()
      vim.cmd("norm! gvy")
      vim.cmd(("/" .. vim.api.nvim_eval("@\"")))
      return vim.cmd("norm! N")
    end
    _G._zest["keymap"][ZEST_ID_0_] = _0_
    ZEST_VLUA_0_ = ("v:lua._zest.keymap." .. ZEST_ID_0_)
  end
  local ZEST_RHS_0_ = string.format(":call %s()<cr>", ZEST_VLUA_0_)
  for ZEST_M_0_ in string.gmatch("x", ".") do
    vim.api.nvim_set_keymap(ZEST_M_0_, "*", ZEST_RHS_0_, {noremap = true})
  end
end
do
  vim.api.nvim_set_keymap("n", "<leader>r", ":%s///g<left><left>", {noremap = true})
end
do
  vim.api.nvim_set_keymap("x", "<leader>r", ":s///g<left><left>", {noremap = true})
end
do
  vim.api.nvim_set_keymap("x", "<", "<gv", {noremap = true})
  vim.api.nvim_set_keymap("x", ">", ">gv", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "Y", "y$", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "U", "<c-r>", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "<c-j>", "J", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "i", "l", {noremap = true})
  vim.api.nvim_set_keymap("v", "i", "l", {noremap = true})
  vim.api.nvim_set_keymap("n", "l", "i", {noremap = true})
  vim.api.nvim_set_keymap("v", "l", "i", {noremap = true})
end
vim.api.nvim_set_keymap("n", "k", "n", {noremap = true})
vim.api.nvim_set_keymap("v", "k", "n", {noremap = true})
vim.api.nvim_set_keymap("o", "k", "n", {noremap = true})
vim.api.nvim_set_keymap("n", "f", "e", {noremap = true})
vim.api.nvim_set_keymap("v", "f", "e", {noremap = true})
vim.api.nvim_set_keymap("o", "f", "e", {noremap = true})
vim.api.nvim_set_keymap("n", "j", "f", {noremap = true})
vim.api.nvim_set_keymap("v", "j", "f", {noremap = true})
vim.api.nvim_set_keymap("o", "j", "f", {noremap = true})
vim.api.nvim_set_keymap("n", "F", "E", {noremap = true})
vim.api.nvim_set_keymap("v", "F", "E", {noremap = true})
vim.api.nvim_set_keymap("o", "F", "E", {noremap = true})
vim.api.nvim_set_keymap("n", "J", "F", {noremap = true})
vim.api.nvim_set_keymap("v", "J", "F", {noremap = true})
vim.api.nvim_set_keymap("o", "J", "F", {noremap = true})
vim.api.nvim_set_keymap("n", "L", "I", {noremap = true})
vim.api.nvim_set_keymap("v", "L", "I", {noremap = true})
vim.api.nvim_set_keymap("o", "L", "I", {noremap = true})
vim.api.nvim_set_keymap("n", "K", "N", {noremap = true})
vim.api.nvim_set_keymap("v", "K", "N", {noremap = true})
return vim.api.nvim_set_keymap("o", "K", "N", {noremap = true})