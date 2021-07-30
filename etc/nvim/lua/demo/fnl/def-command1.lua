do
  local ZEST_VLUA_0_
  do
    local ZEST_ID_0_ = "_77_121_67_109_100_"
    local function _0_(...)
      return print(...)
    end
    _G._zest["command"][ZEST_ID_0_] = _0_
    ZEST_VLUA_0_ = ("v:lua._zest.command." .. ZEST_ID_0_)
  end
  vim.cmd(("command -nargs=* MyCmd :call " .. ZEST_VLUA_0_ .. "(<f-args>)"))
end
return 42