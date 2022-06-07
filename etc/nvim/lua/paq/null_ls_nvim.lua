local null_ls = require('null-ls')

null_ls.setup({
  diagnostics_format = "#{m} #{c}",
  sources = {
    null_ls.builtins.diagnostics.shellcheck,
  },
})
