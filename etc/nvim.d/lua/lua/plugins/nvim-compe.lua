local compe = require("compe")
compe.setup({autocomplete = true, debug = false, documentation = true, enabled = true, incomplete_delay = 400, max_abbr_width = 100, max_kind_width = 100, max_menu_width = 100, min_lenght = 1, preselect = "enable", source = {buffer = true, calc = true, love = true, nvim_lsp = true, omni = true, path = true, treesitter = true, ultisnips = true}, source_timeout = 200, throttle_time = 80})
local function rtc(s)
  return vim.api.nvim_replace_termcodes(s, true, true, true)
end
do
  local ZEST_VLUA_0_
  do
    local ZEST_ID_0_ = "_60_116_97_98_62_"
    local function _0_()
      if (1 == vim.fn.pumvisible()) then
        return rtc("<c-n>")
      else
        return rtc("<tab>")
      end
    end
    _G._zest["keymap"][ZEST_ID_0_] = _0_
    ZEST_VLUA_0_ = ("v:lua._zest.keymap." .. ZEST_ID_0_)
  end
  local ZEST_RHS_0_ = string.format("%s()", ZEST_VLUA_0_)
  for ZEST_M_0_ in string.gmatch("is", ".") do
    vim.api.nvim_set_keymap(ZEST_M_0_, "<tab>", ZEST_RHS_0_, {expr = true, noremap = true})
  end
end
do
  local ZEST_VLUA_0_
  do
    local ZEST_ID_0_ = "_60_115_45_116_97_98_62_"
    local function _0_()
      if (1 == vim.fn.pumvisible()) then
        return rtc("<c-p>")
      else
        return rtc("<s-tab>")
      end
    end
    _G._zest["keymap"][ZEST_ID_0_] = _0_
    ZEST_VLUA_0_ = ("v:lua._zest.keymap." .. ZEST_ID_0_)
  end
  local ZEST_RHS_0_ = string.format("%s()", ZEST_VLUA_0_)
  for ZEST_M_0_ in string.gmatch("is", ".") do
    vim.api.nvim_set_keymap(ZEST_M_0_, "<s-tab>", ZEST_RHS_0_, {expr = true, noremap = true})
  end
end
local ZEST_VLUA_0_
do
  local ZEST_ID_0_ = "_60_99_114_62_"
  local function _0_()
    return vim.fn["compe#confirm"]("\n")
  end
  _G._zest["keymap"][ZEST_ID_0_] = _0_
  ZEST_VLUA_0_ = ("v:lua._zest.keymap." .. ZEST_ID_0_)
end
local ZEST_RHS_0_ = string.format("%s()", ZEST_VLUA_0_)
for ZEST_M_0_ in string.gmatch("i", ".") do
  vim.api.nvim_set_keymap(ZEST_M_0_, "<cr>", ZEST_RHS_0_, {expr = true, noremap = true})
end
return nil