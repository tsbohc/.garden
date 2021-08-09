vim.g["mapleader"] = " "
do
  local zest_keymap_0_
  local function _0_()
    if (vim.v.count > 0) then
      return "k"
    else
      return "gk"
    end
  end
  zest_keymap_0_ = {f = _0_, lhs = "e", modes = "nv", opts = {expr = true, noremap = true}, rhs = "v:lua._zest.keymap.phJHCF2A.f()"}
  _G._zest.keymap["phJHCF2A"] = zest_keymap_0_
  vim.api.nvim_set_keymap("n", zest_keymap_0_.lhs, zest_keymap_0_.rhs, zest_keymap_0_.opts)
  vim.api.nvim_set_keymap("v", zest_keymap_0_.lhs, zest_keymap_0_.rhs, zest_keymap_0_.opts)
end
do
  local zest_keymap_0_
  local function _0_()
    if (vim.v.count > 0) then
      return "j"
    else
      return "gj"
    end
  end
  zest_keymap_0_ = {f = _0_, lhs = "n", modes = "nv", opts = {expr = true, noremap = true}, rhs = "v:lua._zest.keymap.EMCuseZY.f()"}
  _G._zest.keymap["EMCuseZY"] = zest_keymap_0_
  vim.api.nvim_set_keymap("n", zest_keymap_0_.lhs, zest_keymap_0_.rhs, zest_keymap_0_.opts)
  vim.api.nvim_set_keymap("v", zest_keymap_0_.lhs, zest_keymap_0_.rhs, zest_keymap_0_.opts)
end
do
  local zest_opts_0_ = {noremap = true}
  vim.api.nvim_set_keymap("o", "n", "j", zest_opts_0_)
  vim.api.nvim_set_keymap("o", "e", "k", zest_opts_0_)
end
do
  local zest_opts_0_ = {noremap = true}
  vim.api.nvim_set_keymap("n", "I", "$", zest_opts_0_)
  vim.api.nvim_set_keymap("v", "I", "$", zest_opts_0_)
  vim.api.nvim_set_keymap("n", "H", "0", zest_opts_0_)
  vim.api.nvim_set_keymap("v", "H", "0", zest_opts_0_)
  vim.api.nvim_set_keymap("n", "N", "<c-d>", zest_opts_0_)
  vim.api.nvim_set_keymap("v", "N", "<c-d>", zest_opts_0_)
  vim.api.nvim_set_keymap("n", "E", "<c-u>", zest_opts_0_)
  vim.api.nvim_set_keymap("v", "E", "<c-u>", zest_opts_0_)
end
do
  local zest_opts_0_ = {noremap = true}
  vim.api.nvim_set_keymap("n", "<ScrollWheelUp>", "<c-y>", zest_opts_0_)
  vim.api.nvim_set_keymap("v", "<ScrollWheelUp>", "<c-y>", zest_opts_0_)
  vim.api.nvim_set_keymap("n", "<ScrollWheelDown>", "<c-e>", zest_opts_0_)
  vim.api.nvim_set_keymap("v", "<ScrollWheelDown>", "<c-e>", zest_opts_0_)
end
do
  local zest_opts_0_ = {noremap = true}
  vim.api.nvim_set_keymap("n", "<c-h>", "<c-w>h", zest_opts_0_)
  vim.api.nvim_set_keymap("n", "<c-i>", "<c-w>l", zest_opts_0_)
  vim.api.nvim_set_keymap("n", "<c-e>", "<c-w>k", zest_opts_0_)
  vim.api.nvim_set_keymap("n", "<c-n>", "<c-w>j", zest_opts_0_)
end
do
  local zest_keymap_0_ = {lhs = "//", modes = "nv", opts = {noremap = true, silent = true}, rhs = ":nohlsearch<cr>"}
  _G._zest.keymap["wpQxxGbE"] = zest_keymap_0_
  vim.api.nvim_set_keymap("n", zest_keymap_0_.lhs, zest_keymap_0_.rhs, zest_keymap_0_.opts)
  vim.api.nvim_set_keymap("v", zest_keymap_0_.lhs, zest_keymap_0_.rhs, zest_keymap_0_.opts)
end
do
  local zest_keymap_0_
  local function _0_()
    local p = vim.fn.getpos(".")
    vim.cmd("norm! *")
    return vim.fn.setpos(".", p)
  end
  zest_keymap_0_ = {f = _0_, lhs = "*", modes = "n", opts = {noremap = true}, rhs = ":call v:lua._zest.keymap.Uv00QBZB.f()<cr>"}
  _G._zest.keymap["Uv00QBZB"] = zest_keymap_0_
  vim.api.nvim_set_keymap("n", zest_keymap_0_.lhs, zest_keymap_0_.rhs, zest_keymap_0_.opts)
end
do
  local zest_keymap_0_
  local function _0_()
    local p = vim.fn.getpos(".")
    vim.cmd("norm! gvy")
    vim.cmd(("/" .. vim.api.nvim_eval("@\"")))
    return vim.fn.setpos(".", p)
  end
  zest_keymap_0_ = {f = _0_, lhs = "*", modes = "x", opts = {noremap = true}, rhs = ":call v:lua._zest.keymap.wkYcMQYT.f()<cr>"}
  _G._zest.keymap["wkYcMQYT"] = zest_keymap_0_
  vim.api.nvim_set_keymap("x", zest_keymap_0_.lhs, zest_keymap_0_.rhs, zest_keymap_0_.opts)
end
do
  local zest_keymap_0_ = {lhs = "<leader>r", modes = "n", opts = {noremap = true}, rhs = ":%s///g<left><left>"}
  _G._zest.keymap["tbR5aE0M"] = zest_keymap_0_
  vim.api.nvim_set_keymap("n", zest_keymap_0_.lhs, zest_keymap_0_.rhs, zest_keymap_0_.opts)
end
do
  local zest_keymap_0_ = {lhs = "<leader>r", modes = "x", opts = {noremap = true}, rhs = ":s///g<left><left>"}
  _G._zest.keymap["YsNh2kdV"] = zest_keymap_0_
  vim.api.nvim_set_keymap("x", zest_keymap_0_.lhs, zest_keymap_0_.rhs, zest_keymap_0_.opts)
end
do
  local zest_opts_0_ = {noremap = true}
  vim.api.nvim_set_keymap("x", "<", "<gv", zest_opts_0_)
  vim.api.nvim_set_keymap("x", ">", ">gv", zest_opts_0_)
end
do
  local zest_keymap_0_ = {lhs = "Y", modes = "n", opts = {noremap = true}, rhs = "y$"}
  _G._zest.keymap["peM7FLFT"] = zest_keymap_0_
  vim.api.nvim_set_keymap("n", zest_keymap_0_.lhs, zest_keymap_0_.rhs, zest_keymap_0_.opts)
end
do
  local zest_keymap_0_ = {lhs = "U", modes = "n", opts = {noremap = true}, rhs = "<c-r>"}
  _G._zest.keymap["VXfQLkCi"] = zest_keymap_0_
  vim.api.nvim_set_keymap("n", zest_keymap_0_.lhs, zest_keymap_0_.rhs, zest_keymap_0_.opts)
end
do
  local zest_keymap_0_ = {lhs = "<c-j>", modes = "n", opts = {noremap = true}, rhs = "J"}
  _G._zest.keymap["bm3VNbrR"] = zest_keymap_0_
  vim.api.nvim_set_keymap("n", zest_keymap_0_.lhs, zest_keymap_0_.rhs, zest_keymap_0_.opts)
end
local zest_opts_0_ = {noremap = true}
vim.api.nvim_set_keymap("n", "i", "l", zest_opts_0_)
vim.api.nvim_set_keymap("v", "i", "l", zest_opts_0_)
vim.api.nvim_set_keymap("o", "i", "l", zest_opts_0_)
vim.api.nvim_set_keymap("n", "f", "e", zest_opts_0_)
vim.api.nvim_set_keymap("v", "f", "e", zest_opts_0_)
vim.api.nvim_set_keymap("o", "f", "e", zest_opts_0_)
vim.api.nvim_set_keymap("n", "J", "F", zest_opts_0_)
vim.api.nvim_set_keymap("v", "J", "F", zest_opts_0_)
vim.api.nvim_set_keymap("o", "J", "F", zest_opts_0_)
vim.api.nvim_set_keymap("n", "L", "I", zest_opts_0_)
vim.api.nvim_set_keymap("v", "L", "I", zest_opts_0_)
vim.api.nvim_set_keymap("o", "L", "I", zest_opts_0_)
vim.api.nvim_set_keymap("n", "k", "n", zest_opts_0_)
vim.api.nvim_set_keymap("v", "k", "n", zest_opts_0_)
vim.api.nvim_set_keymap("o", "k", "n", zest_opts_0_)
vim.api.nvim_set_keymap("n", "F", "E", zest_opts_0_)
vim.api.nvim_set_keymap("v", "F", "E", zest_opts_0_)
vim.api.nvim_set_keymap("o", "F", "E", zest_opts_0_)
vim.api.nvim_set_keymap("n", "j", "f", zest_opts_0_)
vim.api.nvim_set_keymap("v", "j", "f", zest_opts_0_)
vim.api.nvim_set_keymap("o", "j", "f", zest_opts_0_)
vim.api.nvim_set_keymap("n", "l", "i", zest_opts_0_)
vim.api.nvim_set_keymap("v", "l", "i", zest_opts_0_)
vim.api.nvim_set_keymap("o", "l", "i", zest_opts_0_)
vim.api.nvim_set_keymap("n", "K", "N", zest_opts_0_)
vim.api.nvim_set_keymap("v", "K", "N", zest_opts_0_)
return vim.api.nvim_set_keymap("o", "K", "N", zest_opts_0_)