local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

return {
   settings = {
      Lua = {
         runtime = {
            version = 'LuaJIT',
            path = runtime_path,
         },
         diagnostics = {
            globals = { 'vim', 'love' },
         },
         completion = {
            keywordSnippet = 'Disable',
            postfix = '',
            autoRequire = false
         },
         workspace = {
            library = {
               '~/.local/share/nvim/lsp_servers/sumneko_lua/extension/server/meta/3rd/love2d/library',
               vim.fn.expand("$VIMRUNTIME/lua"),
               vim.fn.stdpath("config") .. "/lua",
               '~/code/rl/' -- UGHHH FIXME
            },
            checkThirdParty = false -- stop asking about LOVE
         },
         telemetry = {
            enable = false,
         },
      },
   },
}
