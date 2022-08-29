local mason = require('mason')
local masonlsp = require('mason-lspconfig')
local lspconfig = require('lspconfig')

-- clean

mason.setup()

masonlsp.setup({
   ensure_installed = {
      'sumneko_lua',
      'yamlls',
      'taplo'
   },
})

local function on_attach(client, bufnr)

   -- vim.api.nvim_exec_autocmds('User', {pattern = 'LspAttached'})

   local bufopts = { noremap=true, silent=true, buffer=bufnr }
   vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)

   require('lsp_signature').on_attach({
      bind = true,
      doc_lines = 0,
      -- floating_window = false,
      floating_window_off_x = 8,
      floating_window_off_y = 0,
      hi_parameter = "TSFunction",
      hint_prefix = "",
      hint_scheme = "TSFunction",
      hint_enable = false,
      handler_opts = {
         border = "double"   -- double, rounded, single, shadow, none
      },
   }, bufnr)

end

--

local lsp_defaults = {
   flags = {
      debounce_text_changes = 250,
   },
   -- capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
   on_attach = on_attach
}

lspconfig.util.default_config = vim.tbl_deep_extend(
  'force',
  lspconfig.util.default_config,
  lsp_defaults
)

-- setup servers
lspconfig.sumneko_lua.setup(require('lsp.sumneko_lua'))
lspconfig.yamlls.setup({})
lspconfig.taplo.setup({})

-- signs
local signs = { Error = "×", Warn = "△", Hint = "·", Info = "·" }
for type, icon in pairs(signs) do
   local hl = "DiagnosticSign" .. type
   vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- diagnostics
vim.diagnostic.config({
   virtual_text = {
      prefix = '⥌'
   },
   underline = true,
   update_in_insert = false,
})

-- handlers

-- -- on_attach
-- local opts = { noremap=true, silent=true }
-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
--
-- -- telescoping this?
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
--
-- -- Use an on_attach function to only map the following keys
-- -- after the language server attaches to the current buffer
-- local function on_attach(client, bufnr)
--    -- Enable completion triggered by <c-x><c-o>
--    -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
--
--    -- See `:help vim.lsp.*` for documentation on any of the below functions
--    local bufopts = { noremap=true, silent=true, buffer=bufnr }
--    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
--    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts) -- telescoped
--    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
--    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
--    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
--    -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
--    -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
--
--    vim.keymap.set('n', '<space>wl', function()
--       print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--    end, bufopts)
--
--    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
--    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
--    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
--    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts) -- telescoped
--    vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
--
--
--
--    -- idek
--    -- local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
--    -- buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
--
--
--    require('lsp_signature').on_attach({
--       bind = true,
--       doc_lines = 0,
--       -- floating_window = false,
--       floating_window_off_x = 9,
--       floating_window_off_y = 0,
--       hi_parameter = "TSFunction",
--       hint_prefix = "",
--       hint_scheme = "TSFunction",
--       hint_enable = false,
--       handler_opts = {
--          border = "double"   -- double, rounded, single, shadow, none
--       },
--    }, bufnr)
--
--    -- lsp based hover highlighting
--    --if client.resolved_capabilities.document_highlight then
--    --  vim.api.nvim_exec(
--    --    [[
--    --    augroup lsp_document_highlight
--    --      autocmd! * <buffer>
--    --      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
--    --      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
--    --    augroup END
--    --  ]], false)
--    --end
-- end
--
-- -- capabilities
--
-- -- TODO what does this even do?
-- -- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- -- capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
--
--
--
--
-- -- -- lsp_installer
-- --
-- -- lsp_installer.on_server_ready(function(server)
-- --    local opts = {
-- --       on_attach = on_attach,
-- --       flags = {
-- --          debounce_text_changes = 200,
-- --       },
-- --       capabilities = capabilities,
-- --    }
-- --
-- --    if server.name == "sumneko_lua" then
-- --       opts = vim.tbl_deep_extend("force", require('lsp.sumneko_lua'), opts)
-- --    end
-- --
-- --    server:setup(opts)
-- -- end)
