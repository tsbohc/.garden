vim.cmd(("au " .. table.concat({"BufNewFile", my_event}, ",") .. " *.html,*.xml setlocal nowrap"))
return 42