vim.api.nvim_command(("au " .. "BufNewFile,BufRead" .. " " .. "*.html,*.xml" .. " " .. "setlocal nowrap"))
return 42