--        .
--  __   __)
-- (. | /o ______  __  _.
--    |/<_/ / / <_/ (_(__
--    |
--

-- TODO os.getenv("DOTGARDEN") or something?


-- I need the hori setup to check if init.lua is linked to bayleaf's cache dir, and if it isn't or doesn't exist, do an initial compilation
-- setup automagic fennel compilation
vim.cmd([[
augroup bayleaf
  autocmd!
  autocmd BufWritePost /home/tsbohc/.garden/etc/nvim/config/*.fnl :silent !bayleaf "%:p"
  autocmd BufWritePost /home/tsbohc/.garden/etc/nvim/config/*.lua :silent !bayleaf "%:p"
augroup END]])

-- should be a separate module that's loaded if something goes wrong
-- do i need this though? bayleaf won't let me break the config anyway
--local function rescue()
--  local keys = {
--    n = 'j',
--    e = 'k',
--    I = '$',
--    H = '0',
--    N = '<c-d>',
--    E = '<c-u>',
--
--    ['<c-h>'] = '<c-w>h',
--    ['<c-n>'] = '<c-w>j',
--    ['<c-e>'] = '<c-w>k',
--    ['<c-i>'] = '<c-w>l',
--
--    ['//'] = ':nohlsearch<cr>',
--
--    U = '<c-r>',
--    ['<c-j>'] = 'J',
--
--    i = 'l',
--
--    l = 'i',
--    L = 'I',
--
--    f = 'e',
--    F = 'E',
--
--    j = 'f',
--    J = 'F',
--
--    k = 'n',
--    K = 'N',
--  }
--
--  for k, v in pairs(keys) do
--    vim.api.nvim_set_keymap('n', k, v, { noremap = true })
--    vim.api.nvim_set_keymap('v', k, v, { noremap = true })
--    vim.api.nvim_set_keymap('o', k, v, { noremap = true })
--  end
--end
--rescue() -- make this a :Cmd that requires a file


-- plugins

local g = vim.g

-- ensure packer is installed
local packer_path = vim.fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', packer_path})
end

vim.cmd('packadd packer.nvim')
local packer = require('packer')

packer.startup({function(use)
  use {
    "wbthomason/packer.nvim",
    event = "VimEnter",
  }

  use { vim.env.HOME .. '/code/limestone',
    requires = 'rktjmp/lush.nvim'
  }

  use { vim.env.HOME .. '/code/slate',
    requires = 'rktjmp/lush.nvim'
  }

  vim.api.nvim_command('set termguicolors')
  vim.api.nvim_command('colo limestone')

  -- code
  use { 'Yggdroot/indentLine',
    config = function()
      vim.g.indentLine_setColors = 0
      vim.g.indentLine_char = '·'
      vim.g.indentLine_fileTypeExclude = { 'markdown' }
    end
  }

  use { 'https://github.com/lervag/vimtex' }

  -- nvim 0.6
  --use { 'lukas-reineke/virt-column.nvim',
  --  config = function()
  --    require('virt-column').setup({ char = '·' })
  --    vim.cmd([[set colorcolumn=80]])
  --  end
  --}

  -- lisp
  use { 'guns/vim-sexp',
    ft = { 'fennel' }
  }

  -- fennel
  use { 'bakpakin/fennel.vim',
    ft = { 'fennel' } }

  -- {{{
  vim.g.sexp_filetypes = 'fennel'
  vim.g.sexp_mappings = {
    sexp_outer_list =                "",
    sexp_inner_list =                "",
    sexp_outer_top_list =            "aF",
    sexp_inner_top_list =            "mF",
    sexp_outer_string =              "as",
    sexp_inner_string =              "ms",
    sexp_outer_element =             "ae",
    sexp_inner_element =             "me",
    sexp_move_to_prev_bracket =      "(",
    sexp_move_to_next_bracket =      ")",
    sexp_move_to_prev_element_head = "B",
    sexp_move_to_next_element_head = "W",
    sexp_move_to_prev_element_tail = "gF",
    sexp_move_to_next_element_tail = "F",
    sexp_flow_to_prev_close =        "",
    sexp_flow_to_next_open =         "",
    sexp_flow_to_prev_open =         "",
    sexp_flow_to_next_close =        "",
    sexp_flow_to_prev_leaf_head =    "",
    sexp_flow_to_next_leaf_head =    "",
    sexp_flow_to_prev_leaf_tail =    "",
    sexp_flow_to_next_leaf_tail =    "",
    sexp_move_to_prev_top_element =  "[[",
    sexp_move_to_next_top_element =  "]]",
    sexp_select_prev_element =       "",
    sexp_select_next_element =       "",
    sexp_indent =                    "==",
    sexp_indent_top =                "=-",
    sexp_round_head_wrap_list =      "sf(",
    sexp_round_tail_wrap_list =      "sf)",
    sexp_square_head_wrap_list =     "sf[",
    sexp_square_tail_wrap_list =     "sf]",
    sexp_curly_head_wrap_list =      "sf{",
    sexp_curly_tail_wrap_list =      "sf}",
    sexp_round_head_wrap_element =   "se(",
    sexp_round_tail_wrap_element =   "se)",
    sexp_square_head_wrap_element =  "se[",
    sexp_square_tail_wrap_element =  "se]",
    sexp_curly_head_wrap_element =   "se{",
    sexp_curly_tail_wrap_element =   "se}",
    sexp_insert_at_list_head =       "<L",
    sexp_insert_at_list_tail =       ">L",
    sexp_splice_list =               "ds",
    sexp_convolute =                 "",
    sexp_raise_list =                "",
    sexp_raise_element =             "",
    sexp_swap_list_backward =        "<f",
    sexp_swap_list_forward =         ">f",
    sexp_swap_element_backward =     "<e",
    sexp_swap_element_forward =      ">e",
    sexp_emit_head_element =         ">(",
    sexp_emit_tail_element =         ">)",
    sexp_capture_prev_element =      "<(",
    sexp_capture_next_element =      "<)",
  }
  -- }}}

  -- treesitter
  use { 'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = "maintained",
        highlight = { enable = true }
      }
    end
  }

  -- lsp
  use { 'neovim/nvim-lspconfig' }

  -- $ npm i -g bash-language-server
  require'lspconfig'.bashls.setup{}

  use { 'jose-elias-alvarez/null-ls.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      local null_ls = require('null-ls')
      null_ls.config({
          sources = {
            null_ls.builtins.diagnostics.shellcheck.with({
              diagnostics_format = '#{m} #{c}'
            }),
            null_ls.builtins.formatting.fnlfmt,
            null_ls.builtins.completion.vsnip,
            --null_ls.builtins.diagnostics.proselint,
          },
      })

      require("lspconfig")["null-ls"].setup({})
      --require("lspconfig")["null-ls"].setup({
      --  capabilities = capabilities
      --})
    end
  }

  vim.fn.sign_define("DiagnosticSignError", { text = "◆", texthl = "DiagnosticSignError" })
  vim.fn.sign_define("DiagnosticSignWarn", { text = "◇", texthl = "DiagnosticSignWarn" })
  vim.fn.sign_define("DiagnosticSignInformation", { text = "·", texthl = "DiagnosticSignInfo" })
  vim.fn.sign_define("DiagnosticSignHint", { text = "·", texthl = "DiagnosticSignHint" })

  -- completion

  use { 'hrsh7th/vim-vsnip' }
  use { 'hrsh7th/cmp-vsnip',
    opt = true,
    event = { 'InsertEnter', 'CmdlineEnter' },
  }

  use { 'hrsh7th/nvim-cmp',
    --opt = true,
    --event = { 'InsertEnter', 'CmdlineEnter' },
    requires = {
      'hrsh7th/vim-vsnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-buffer',
    },
    config = function()
      local cmp = require'cmp'

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local feedkey = function(key, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
      end

      cmp.setup {
         snippet = {
           expand = function(args)
             vim.fn["vsnip#anonymous"](args.body)
           end,
         },
         mapping = {
           ["<Tab>"] = cmp.mapping(function(fallback)
             if cmp.visible() then
               cmp.select_next_item()
             elseif vim.fn["vsnip#available"](1) == 1 then
               feedkey("<Plug>(vsnip-expand-or-jump)", "")
             elseif has_words_before() then
               cmp.complete()
             else
               fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
             end
           end, { "i", "s" }),
           ["<S-Tab>"] = cmp.mapping(function()
             if cmp.visible() then
               cmp.select_prev_item()
             elseif vim.fn["vsnip#jumpable"](-1) == 1 then
               feedkey("<Plug>(vsnip-jump-prev)", "")
             end
           end, { "i", "s" }),
         },
         sources = cmp.config.sources({
           --{ name = 'treesitter' },
           { name = 'nvim_lsp' },
           { name = 'buffer' },
           { name = 'vsnip' },
         }, {
           { name = 'path' },
         })
       }
       cmp.setup.cmdline('/', {
         sources = {
           { name = 'buffer' }
         }
       })
       cmp.setup.cmdline(':', {
         sources = cmp.config.sources({
           { name = 'path' }
         }, {
           { name = 'cmdline' }
         })
       })
    end
  }

end,
config = {
  display = {
    open_fn = require('packer.util').float,
  }
}})





local modules = {
--  "plugins",
  "core.keymaps",
  "core.options",
  "core.autocmds",
  "core.statusline",
--  "core.textobjects",
--  "core.operators",
--  "test"
}


for _, m in ipairs(modules) do
  local ok, out = pcall(require, m)
  if not ok then
    print("Error while loading '" .. m .. "':\n" .. out)
  end
end

vim.g.tex_flavor = 'latex'
vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_compiler_latexmk = {
  executable = 'latexmk',
  options = {
    '-xelatex',
    '-file-line-error',
    '-synctex=1',
    '-interaction=nonstopmode'
  }
}

vim.g.vimtex_quickfix_mode = 0

--local zest = require('zest')

--vim.cmd(lime.vlua_format(':com -nargs=* Mycmd :call %s(<f-args>)', function(a)
--  print('hey, ' .. a)
--end))
--
--st.def_keymap('n', { 'noremap' }, '<c-n>', [[:echo "keymap-str-r"<cr>]])
--
--ki('n', { 'noremap' }, '<c-m>', function()
--  print('keymap-fn-r')
--end)
--
--lime.def_augroup('test-r', function()
--  lime.def_autocmd({ 'BufLeave', 'BufEnter' }, '*', function()
--    print('runtime-augroup-1')
--  end)
--  lime.def_autocmd({ 'BufLeave', 'BufEnter' }, '*', function()
--    print('runtime-augroup-2')
--  end)
--end)
