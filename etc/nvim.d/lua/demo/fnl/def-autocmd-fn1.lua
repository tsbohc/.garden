do
  vim.api.nvim_command(("augroup " .. "restore-position"))
  vim.api.nvim_command("autocmd!")
  do
    local ZEST_VLUA_0_
    do
      local ZEST_ID_0_ = ("_" .. _G._zest.autocmd["#"])
      local function _0_()
        if ((vim.fn.line("'\"") > 1) and (vim.fn.line("'\"") <= vim.fn.line("$"))) then
          return vim.cmd("normal! g'\"")
        end
      end
      _G._zest["autocmd"][ZEST_ID_0_] = _0_
      _G._zest["autocmd"]["#"] = (_G._zest.autocmd["#"] + 1)
      ZEST_VLUA_0_ = ("v:lua._zest.autocmd." .. ZEST_ID_0_)
    end
    local ZEST_RHS_0_ = string.format(":call %s()", ZEST_VLUA_0_)
    vim.api.nvim_command(("au " .. "BufReadPost" .. " " .. "*" .. " " .. ZEST_RHS_0_))
  end
  vim.api.nvim_command("augroup END")
end
return 42