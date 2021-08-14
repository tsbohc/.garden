local function _0_()
  local compe = require("compe")
  compe.setup({autocomplete = true, debug = false, documentation = true, enabled = true, incomplete_delay = 400, max_abbr_width = 100, max_kind_width = 100, max_menu_width = 100, min_lenght = 1, preselect = "enable", source = {buffer = true, calc = true, love = true, nvim_lsp = true, omni = true, path = true, treesitter = true, ultisnips = true}, source_timeout = 200, throttle_time = 80})
  local function rtc(s)
    return vim.api.nvim_replace_termcodes(s, true, true, true)
  end
  do
    -- zest.def-keymap-fn
    local zest_uid_0_ = "is_60tab62"
    local zest_mod_0_ = "is"
    local zest_opt_0_ = {expr = true, noremap = true}
    local zest_lhs_0_ = "<tab>"
    local zest_rhs_0_ = "v:lua.zest.keymap.is_60tab62()"
    local function _1_()
      if (1 == vim.fn.pumvisible()) then
        return rtc("<c-n>")
      else
        return rtc("<tab>")
      end
    end
    _G.zest.keymap[zest_uid_0_] = _1_
    for m_0_ in string.gmatch(zest_mod_0_, ".") do
      vim.api.nvim_set_keymap(m_0_, zest_lhs_0_, zest_rhs_0_, zest_opt_0_)
    end
  end
  do
    -- zest.def-keymap-fn
    local zest_uid_1_ = "is_60s45tab62"
    local zest_mod_1_ = "is"
    local zest_opt_1_ = {expr = true, noremap = true}
    local zest_lhs_1_ = "<s-tab>"
    local zest_rhs_1_ = "v:lua.zest.keymap.is_60s45tab62()"
    local function _1_()
      if (1 == vim.fn.pumvisible()) then
        return rtc("<c-p>")
      else
        return rtc("<s-tab>")
      end
    end
    _G.zest.keymap[zest_uid_1_] = _1_
    for m_0_ in string.gmatch(zest_mod_1_, ".") do
      vim.api.nvim_set_keymap(m_0_, zest_lhs_1_, zest_rhs_1_, zest_opt_1_)
    end
  end
  -- zest.def-keymap-fn
  local zest_uid_2_ = "i_60cr62"
  local zest_mod_2_ = "i"
  local zest_opt_2_ = {expr = true, noremap = true}
  local zest_lhs_2_ = "<cr>"
  local zest_rhs_2_ = "v:lua.zest.keymap.i_60cr62()"
  local function _1_()
    return vim.fn["compe#confirm"]("\n")
  end
  _G.zest.keymap[zest_uid_2_] = _1_
  for m_0_ in string.gmatch(zest_mod_2_, ".") do
    vim.api.nvim_set_keymap(m_0_, zest_lhs_2_, zest_rhs_2_, zest_opt_2_)
  end
  return nil
end
return _0_