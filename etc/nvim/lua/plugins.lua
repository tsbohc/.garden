local function plugins(use, auc)
   -- syntax
   auc { '~/code/slate', requires = 'rktjmp/lush.nvim' }
   auc {
      'nvim-treesitter/nvim-treesitter',
      requires = {
         'nvim-treesitter/playground',
         'nvim-treesitter/nvim-treesitter-textobjects'
      }
   }

   -- completion and snippets
   auc { -- TODO: see about new cmp modules
      'hrsh7th/nvim-cmp',
      requires = {
         { 'hrsh7th/cmp-path' },
         { 'hrsh7th/cmp-cmdline' },
         { 'hrsh7th/cmp-buffer' },
         { 'hrsh7th/cmp-nvim-lua' },
         { 'hrsh7th/cmp-nvim-lsp' },
      }
   }

    use {
      'rafcamlet/nvim-luapad',
      requires = "antoinemadec/FixCursorHold.nvim",
      config = function()
         require('luapad').config({

         })
      end
   }

   use { 'skywind3000/asyncrun.vim', }

   auc { 'arcticicestudio/nord-vim' }

   auc { 'L3MON4D3/LuaSnip', requires = 'saadparwaiz1/cmp_luasnip' }

   -- parensea
   -- auc { 'eraserhd/parinfer-rust', run = 'cargo build --release' }
   auc { 'guns/vim-sexp' }
   auc { 'bakpakin/fennel.vim' }
   auc { 'janet-lang/janet.vim' }

   -- niceties
   use {
      'echasnovski/mini.nvim',
      branch = 'stable',
      config = function()
         local ai = require('mini.ai')
         ai.setup {
            mappings = {
               around = 'a',
               inside = 'm'
            },
            custom_textobjects = {
               b = false,
               f = ai.gen_spec.treesitter { a = '@block.outer', i = '@block.inner' },
               e = ai.gen_spec.argument {
                  brackets = { '%b()', '%b[]', '%b{}' },
                  separators = { '||' },
                  exclude_regions = { '%b""', "%b''", '%b()', '%b[]', '%b{}' }
               },
            }
         }
      end
   }

   use {
      'm-demare/hlargs.nvim',
      requires = { 'nvim-treesitter/nvim-treesitter' },
      config = function()
         require('hlargs').setup {}
      end
   }

   use {
      'kyazdani42/nvim-tree.lua',
      -- requires = {
      --    'kyazdani42/nvim-web-devicons', -- optional, for file icons
      -- }
      config = function()
         require('nvim-tree').setup({

         })
      end
   }

   use {
      'chaoren/vim-wordmotion',
      config = function()
         vim.g.wordmotion_nomap = true
         vim.keymap.set({ 'n', 'x', 'o' }, 'w', '<Plug>WordMotion_w')
         -- vim.keymap.set({ 'n', 'x', 'o' }, 'W', '<Plug>WordMotion_W')
         vim.keymap.set({ 'n', 'x', 'o' }, 'b', '<Plug>WordMotion_b')
         -- vim.keymap.set({ 'n', 'x', 'o' }, 'B', '<Plug>WordMotion_B')
         vim.keymap.set({ 'n', 'x', 'o' }, 'f', '<Plug>WordMotion_e')
         -- vim.keymap.set({ 'n', 'x', 'o' }, 'F', '<Plug>WordMotion_E')
         vim.keymap.set({ 'n', 'x', 'o' }, 'gf', '<Plug>WordMotion_ge')
         -- vim.keymap.set({ 'n', 'x', 'o' }, 'gF', '<Plug>WordMotion_gE')
         vim.keymap.set({ 'x', 'o' }, 'aw', '<Plug>WordMotion_aw')
         -- vim.keymap.set({ 'x', 'o' }, 'aW', '<Plug>WordMotion_aW')
         vim.keymap.set({ 'x', 'o' }, 'mw', '<Plug>WordMotion_iw')
         -- vim.keymap.set({ 'x', 'o' }, 'iW', '<Plug>WordMotion_iW')
      end
   }

   -- use { 'RRethy/vim-illuminate' }
   use {
      'AckslD/nvim-trevJ.lua',
      config = function()
         require('trevj').setup({})

         vim.keymap.set('n', '<leader>j', function()
            require('trevj').format_at_cursor()
         end)
      end
   }

   use {
      'lukas-reineke/virt-column.nvim',
      config = function()
         require('virt-column').setup({
            char = '│'
         })
      end
   }
   auc { 'lukas-reineke/indent-blankline.nvim' }
   auc { 'svban/YankAssassin.vim' }
   auc {
      'windwp/nvim-autopairs',
      config = function()
         require('nvim-autopairs').setup({})
      end
   }

   -- misc
   auc { 'numToStr/Comment.nvim' }
   auc { 'dhruvasagar/vim-table-mode' }

   -- fuzzy
   -- use {
   --   'ibhagwan/fzf-lua',
   --   config = function()
   --     require('fzf-lua').setup {
   --       winopts = {
   --         split = "belowright new"
   --       }
   --     }
   --   end
   -- }
   auc {
      'nvim-telescope/telescope.nvim',
      requires = {
         { 'nvim-lua/plenary.nvim' },
         { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
      },
   }

   -- git
   auc {
      'lewis6991/gitsigns.nvim',
      requires = { 'nvim-lua/plenary.nvim' }
   }

   auc {
      'andymass/vim-matchup',
      config = function()
         -- vim.g.matchup_motion_enabled = 0
         vim.g.matchup_text_obj_enabled = 0
         vim.g.matchup_matchparen_offscreen = {}
      end
   }

   -- lsp
   auc {
      'neovim/nvim-lspconfig',
      requires = {
         'williamboman/mason.nvim',
         'williamboman/mason-lspconfig.nvim',
         'ray-x/lsp_signature.nvim',
         -- {
         --    'smjonas/inc-rename.nvim',
         --    config = function()
         --       require('inc_rename').setup()
         --    end
         -- },
      },
      config = function() require('lsp') end
   }

   auc {
      'jose-elias-alvarez/null-ls.nvim',
      requires = { 'nvim-lua/plenary.nvim' }
   }

   -- tex
   use {
      'lervag/vimtex',
      config = [[vim.g.vimtex_view_method = 'zathura']]
   }

   -- hmm
   use {
      'rlane/pounce.nvim',
      config = function()
         vim.cmd [[
        nmap t <cmd>Pounce<CR>
        nmap T <cmd>PounceRepeat<CR>
        ]]
         require('pounce').setup {
            accept_keys = "NTESIRKVHDOAMCLPUFYWXZQBGJ",
            accept_best_key = "<enter>",
            multi_window = true,
            debug = false,
         }
      end,
   }
end


-- bootstrapping packer
local fn = vim.fn
local path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(path)) > 0 then
   BOOTSTRAP = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', path })
   print 'packer bootstrapped'
end

vim.cmd 'packadd packer.nvim'

local ok, packer = pcall(require, "packer")
if not ok then return end

packer.init {
   display = {
      open_fn = function()
         return require("packer.util").float { border = "rounded" }
      end,
   },
}

vim.cmd([[
  augroup packer_auto_compile
  autocmd!
  autocmd BufWritePost */lua/plugins.lua,*/lua/paq/*.lua source <afile> | PackerCompile
  augroup end
]])

packer.startup(function(use)
   local function auc(package)
      if type(package) == 'string' then package = { package } end
      if not package.config and fn.glob(vim.fn.stdpath('config') .. '/lua/paq/' .. package[1]:gsub('.*/', ''):gsub('-', '_'):gsub('%.', '_') .. '.lua') ~= '' then
         package.config = function(p)
            require('paq.' .. p:gsub('.*/', ''):gsub('-', '_'):gsub('%.', '_'))
         end
      end
      use(package)
   end

   use 'wbthomason/packer.nvim'
   use 'lewis6991/impatient.nvim'
   local ok, impatient = pcall(require, 'impatient')
   if ok then impatient.enable_profile() end

   plugins(use, auc)

   if BOOTSTRAP then packer.sync() end
end)
