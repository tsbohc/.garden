local lsp_installer = require 'nvim-lsp-installer'

-- signs
local signs = { Error = "×", Warn = "△", Hint = "·", Info = "·" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

-- vim.api.nvim_create_autocmd('CursorHold', {
--    callback = function()
--       local opts = {
--          focusable = false,
--          close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
--          border = 'single',
--          source = 'always',
--          prefix = ' ',
--          scope = 'cursor',
--       }
--       vim.diagnostic.open_float(nil, opts)
--    end
-- })

-- diagnostics
vim.diagnostic.config({
  virtual_text = {
    prefix = '⥌'
  },
  update_in_insert = false,
})

-- handlers


-- on_attach
local function on_attach(client, bufnr)
   require('lsp_signature').on_attach({
      bind = true,
      doc_lines = 0,
      -- floating_window = false,
      floating_window_off_x = 9,
      floating_window_off_y = 0,
      hi_parameter = "TSFunction",
      hint_prefix = "",
      hint_scheme = "TSFunction",
      hint_enable = false,
      handler_opts = {
         border = "double"   -- double, rounded, single, shadow, none
      },
   }, bufnr)

   -- lsp based hover highlighting
   --if client.resolved_capabilities.document_highlight then
   --  vim.api.nvim_exec(
   --    [[
   --    augroup lsp_document_highlight
   --      autocmd! * <buffer>
   --      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
   --      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
   --    augroup END
   --  ]], false)
   --end
end

-- capabilities
--local capabilities = vim.lsp.protocol.make_client_capabilities()
--
--local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
--if ok then
--  capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
--end

-- lsp_installer

lsp_installer.on_server_ready(function(server)
 local opts = {
   on_attach = on_attach,
   flags = {
     debounce_text_changes = 100,
   },
   --capabilities = capabilities,
 }

 if server.name == "sumneko_lua" then
   opts = vim.tbl_deep_extend("force", require('lsp.sumneko_lua'), opts)
 end

 server:setup(opts)
end)

-- local lspconfig = require('lspconfig')
-- local servers = { 'sumneko_lua' }
--
-- for _, s in ipairs(servers) do
--   lspconfig[s].setup(vim.tbl_deep_extend('force', require('lsp.' .. s), {
--     on_attach = on_attach,
--     flags = {
--       debounce_text_changes = 100,
--     },
--   }))
-- end
