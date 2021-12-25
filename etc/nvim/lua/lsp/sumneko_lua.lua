return {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = {'vim'},
      },
      completion = {
        keywordSnippet = 'Disable' -- disable snippets
      },
      workspace = {
        --library = {
        --  [vim.fn.expand("$VIMRUNTIME/lua")] = true,
        --  [vim.fn.stdpath("config") .. "/lua"] = true,
        --},
        checkThirdParty = false -- stop asking about LOVE
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
