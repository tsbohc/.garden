vim.g["mapleader"] = " "
do
  -- zest.def-keymap-fn
  local zest_uid_0_ = "nv_e"
  local zest_mod_0_ = "nv"
  local zest_opt_0_ = {expr = true, noremap = true}
  local zest_lhs_0_ = "e"
  local zest_rhs_0_ = "v:lua.zest.keymap.nv_e()"
  local function _0_()
    if (vim.v.count > 0) then
      return "k"
    else
      return "gk"
    end
  end
  _G.zest.keymap[zest_uid_0_] = _0_
  for m_0_ in string.gmatch(zest_mod_0_, ".") do
    vim.api.nvim_set_keymap(m_0_, zest_lhs_0_, zest_rhs_0_, zest_opt_0_)
  end
end
do
  -- zest.def-keymap-fn
  local zest_uid_1_ = "nv_n"
  local zest_mod_1_ = "nv"
  local zest_opt_1_ = {expr = true, noremap = true}
  local zest_lhs_1_ = "n"
  local zest_rhs_1_ = "v:lua.zest.keymap.nv_n()"
  local function _0_()
    if (vim.v.count > 0) then
      return "j"
    else
      return "gj"
    end
  end
  _G.zest.keymap[zest_uid_1_] = _0_
  for m_0_ in string.gmatch(zest_mod_1_, ".") do
    vim.api.nvim_set_keymap(m_0_, zest_lhs_1_, zest_rhs_1_, zest_opt_1_)
  end
end
do
  -- zest.def-keymap-pairs
  local zest_mod_2_ = "o"
  local zest_opt_2_ = {expr = false, noremap = true}
  local zest_tab_0_ = {e = "k", n = "j"}
  for zest_lhs_2_, zest_rhs_2_ in pairs(zest_tab_0_) do
    for m_0_ in string.gmatch(zest_mod_2_, ".") do
      vim.api.nvim_set_keymap(m_0_, zest_lhs_2_, zest_rhs_2_, zest_opt_2_)
    end
  end
end
do
  -- zest.def-keymap-pairs
  local zest_mod_3_ = "nv"
  local zest_opt_3_ = {expr = false, noremap = true}
  local zest_tab_1_ = {E = "<c-u>", H = "0", I = "$", N = "<c-d>"}
  for zest_lhs_3_, zest_rhs_3_ in pairs(zest_tab_1_) do
    for m_0_ in string.gmatch(zest_mod_3_, ".") do
      vim.api.nvim_set_keymap(m_0_, zest_lhs_3_, zest_rhs_3_, zest_opt_3_)
    end
  end
end
do
  -- zest.def-keymap-pairs
  local zest_mod_4_ = "nv"
  local zest_opt_4_ = {expr = false, noremap = true}
  local zest_tab_2_ = {["<ScrollWheelDown>"] = "<c-e>", ["<ScrollWheelUp>"] = "<c-y>"}
  for zest_lhs_4_, zest_rhs_4_ in pairs(zest_tab_2_) do
    for m_0_ in string.gmatch(zest_mod_4_, ".") do
      vim.api.nvim_set_keymap(m_0_, zest_lhs_4_, zest_rhs_4_, zest_opt_4_)
    end
  end
end
do
  -- zest.def-keymap-pairs
  local zest_mod_5_ = "n"
  local zest_opt_5_ = {expr = false, noremap = true}
  local zest_tab_3_ = {["<c-e>"] = "<c-w>k", ["<c-h>"] = "<c-w>h", ["<c-i>"] = "<c-w>l", ["<c-n>"] = "<c-w>j"}
  for zest_lhs_5_, zest_rhs_5_ in pairs(zest_tab_3_) do
    for m_0_ in string.gmatch(zest_mod_5_, ".") do
      vim.api.nvim_set_keymap(m_0_, zest_lhs_5_, zest_rhs_5_, zest_opt_5_)
    end
  end
end
do
  -- zest.def-autocmd-string
  local zest_mod_6_ = "nv"
  local zest_opt_6_ = {expr = false, noremap = true, silent = true}
  local zest_lhs_6_ = "//"
  local zest_rhs_6_ = ":nohlsearch<cr>"
  for m_0_ in string.gmatch(zest_mod_6_, ".") do
    vim.api.nvim_set_keymap(m_0_, zest_lhs_6_, zest_rhs_6_, zest_opt_6_)
  end
end
do
  -- zest.def-keymap-fn
  local zest_uid_2_ = "n_42"
  local zest_mod_7_ = "n"
  local zest_opt_7_ = {expr = false, noremap = true}
  local zest_lhs_7_ = "*"
  local zest_rhs_7_ = ":call v:lua.zest.keymap.n_42()<cr>"
  local function _0_()
    local p = vim.fn.getpos(".")
    vim.cmd("norm! *")
    return vim.fn.setpos(".", p)
  end
  _G.zest.keymap[zest_uid_2_] = _0_
  for m_0_ in string.gmatch(zest_mod_7_, ".") do
    vim.api.nvim_set_keymap(m_0_, zest_lhs_7_, zest_rhs_7_, zest_opt_7_)
  end
end
do
  -- zest.def-keymap-fn
  local zest_uid_3_ = "x_42"
  local zest_mod_8_ = "x"
  local zest_opt_8_ = {expr = false, noremap = true}
  local zest_lhs_8_ = "*"
  local zest_rhs_8_ = ":call v:lua.zest.keymap.x_42()<cr>"
  local function _0_()
    local p = vim.fn.getpos(".")
    vim.cmd("norm! gvy")
    vim.cmd(("/" .. vim.api.nvim_eval("@\"")))
    return vim.fn.setpos(".", p)
  end
  _G.zest.keymap[zest_uid_3_] = _0_
  for m_0_ in string.gmatch(zest_mod_8_, ".") do
    vim.api.nvim_set_keymap(m_0_, zest_lhs_8_, zest_rhs_8_, zest_opt_8_)
  end
end
do
  -- zest.def-autocmd-string
  local zest_mod_9_ = "n"
  local zest_opt_9_ = {expr = false, noremap = true}
  local zest_lhs_9_ = "<leader>r"
  local zest_rhs_9_ = ":%s///g<left><left>"
  for m_0_ in string.gmatch(zest_mod_9_, ".") do
    vim.api.nvim_set_keymap(m_0_, zest_lhs_9_, zest_rhs_9_, zest_opt_9_)
  end
end
do
  -- zest.def-autocmd-string
  local zest_mod_10_ = "x"
  local zest_opt_10_ = {expr = false, noremap = true}
  local zest_lhs_10_ = "<leader>r"
  local zest_rhs_10_ = ":s///g<left><left>"
  for m_0_ in string.gmatch(zest_mod_10_, ".") do
    vim.api.nvim_set_keymap(m_0_, zest_lhs_10_, zest_rhs_10_, zest_opt_10_)
  end
end
do
  -- zest.def-keymap-pairs
  local zest_mod_11_ = "x"
  local zest_opt_11_ = {expr = false, noremap = true}
  local zest_tab_4_ = {["<"] = "<gv", [">"] = ">gv"}
  for zest_lhs_11_, zest_rhs_11_ in pairs(zest_tab_4_) do
    for m_0_ in string.gmatch(zest_mod_11_, ".") do
      vim.api.nvim_set_keymap(m_0_, zest_lhs_11_, zest_rhs_11_, zest_opt_11_)
    end
  end
end
do
  -- zest.def-autocmd-string
  local zest_mod_12_ = "n"
  local zest_opt_12_ = {expr = false, noremap = true}
  local zest_lhs_12_ = "Y"
  local zest_rhs_12_ = "y$"
  for m_0_ in string.gmatch(zest_mod_12_, ".") do
    vim.api.nvim_set_keymap(m_0_, zest_lhs_12_, zest_rhs_12_, zest_opt_12_)
  end
end
do
  -- zest.def-autocmd-string
  local zest_mod_13_ = "n"
  local zest_opt_13_ = {expr = false, noremap = true}
  local zest_lhs_13_ = "U"
  local zest_rhs_13_ = "<c-r>"
  for m_0_ in string.gmatch(zest_mod_13_, ".") do
    vim.api.nvim_set_keymap(m_0_, zest_lhs_13_, zest_rhs_13_, zest_opt_13_)
  end
end
do
  -- zest.def-autocmd-string
  local zest_mod_14_ = "n"
  local zest_opt_14_ = {expr = false, noremap = true}
  local zest_lhs_14_ = "<c-j>"
  local zest_rhs_14_ = "J"
  for m_0_ in string.gmatch(zest_mod_14_, ".") do
    vim.api.nvim_set_keymap(m_0_, zest_lhs_14_, zest_rhs_14_, zest_opt_14_)
  end
end
-- zest.def-keymap-pairs
local zest_mod_15_ = "nvo"
local zest_opt_15_ = {expr = false, noremap = true}
local zest_tab_5_ = {F = "E", J = "F", K = "N", L = "I", f = "e", i = "l", j = "f", k = "n", l = "i"}
for zest_lhs_15_, zest_rhs_15_ in pairs(zest_tab_5_) do
  for m_0_ in string.gmatch(zest_mod_15_, ".") do
    vim.api.nvim_set_keymap(m_0_, zest_lhs_15_, zest_rhs_15_, zest_opt_15_)
  end
end
return nil