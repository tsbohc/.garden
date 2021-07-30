do
  vim.cmd("augroup restore-position")
  vim.cmd("autocmd!")
  do
    local ZEST_VLUA_0_
    do
      local ZEST_N_0_ = _G._zest.autocmd["#"]
      local ZEST_ID_0_ = ("_" .. ZEST_N_0_)
      local function _0_()
        if ((vim.fn.line("'\"") > 1) and (vim.fn.line("'\"") <= vim.fn.line("$"))) then
          return vim.cmd("normal! g'\"")
        end
      end
      _G._zest["autocmd"][ZEST_ID_0_] = _0_
      _G._zest["autocmd"]["#"] = (ZEST_N_0_ + 1)
      ZEST_VLUA_0_ = ("v:lua._zest.autocmd." .. ZEST_ID_0_)
    end
    vim.cmd(("autocmd BufReadPost * :call " .. ZEST_VLUA_0_ .. "()"))
  end
  vim.cmd("augroup END")
end
return 42