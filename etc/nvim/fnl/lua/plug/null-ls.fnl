(fn []
  (local null-ls (require :null-ls))
  (local lspconfig (require :lspconfig))

  (null-ls.config
    {:sources [(null-ls.builtins.diagnostics.shellcheck.with
                 {:diagnostics_format "#{m} #{c}"})
               null-ls.builtins.formatting.fnlfmt]})
  (lspconfig.null-ls.setup {})

  (vim.fn.sign_define :LspDiagnosticsSignError {:text "░" :texthl "LspDiagnosticsSignError"})
  (vim.fn.sign_define :LspDiagnosticsSignWarning {:text "░" :texthl "LspDiagnosticsSignWarning"})
  (vim.fn.sign_define :LspDiagnosticsSignInformation {:text "░" :texthl "LspDiagnosticsSignInformation"})
  (vim.fn.sign_define :LspDiagnosticsSignHint {:text "░" :texthl "LspDiagnosticsSignHint"}))
