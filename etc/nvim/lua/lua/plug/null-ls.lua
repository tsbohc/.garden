local function _0_()
  local null_ls = require("null-ls")
  local lspconfig = require("lspconfig")
  null_ls.config({sources = {null_ls.builtins.diagnostics.shellcheck.with({diagnostics_format = "#{m} #{c}"}), null_ls.builtins.formatting.fnlfmt}})
  lspconfig["null-ls"].setup({})
  vim.fn.sign_define("LspDiagnosticsSignError", {text = "\226\150\145", texthl = "LspDiagnosticsSignError"})
  vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "\226\150\145", texthl = "LspDiagnosticsSignWarning"})
  vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "\226\150\145", texthl = "LspDiagnosticsSignInformation"})
  return vim.fn.sign_define("LspDiagnosticsSignHint", {text = "\226\150\145", texthl = "LspDiagnosticsSignHint"})
end
return _0_