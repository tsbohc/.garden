local function plugins()
  use({"wbthomason/packer.nvim"})
  use({"Olical/aniseed"})
  use({"/home/sean/code/zest"})
  use({"/home/sean/code/limestone"})
  use({"morhetz/gruvbox"})
  use({"junegunn/fzf.vim"})
  use({"neovim/nvim-lspconfig"})
  use({"huyvohcmc/atlas.vim"})
  local function _0_()
    local null_ls = require("null-ls")
    local lspconfig = require("lspconfig")
    null_ls.config({sources = {null_ls.builtins.diagnostics.shellcheck.with({diagnostics_format = "#{m} #{c}"}), null_ls.builtins.formatting.fnlfmt}})
    return lspconfig["null-ls"].setup({})
  end
  use({"jose-elias-alvarez/null-ls.nvim", config = _0_, requires = {"nvim-lua/plenary.nvim", "neovim/nvim-lspconfig"}})
  local function _1_()
    local ts = require("nvim-treesitter.configs")
    return ts.setup({highlight = {enable = true}})
  end
  use({"nvim-treesitter/nvim-treesitter", config = _1_, event = "BufRead", run = ":TSUpdate"})
  use({"nvim-treesitter/playground", after = "nvim-treesitter"})
  local function _2_()
    return require("plugins.nvim-compe")
  end
  use({"hrsh7th/nvim-compe", config = _2_, event = "InsertEnter"})
  use({"rktjmp/lush.nvim"})
  local function _3_()
    vim.g["tex_flavor"] = "latex"
    vim.g["vimtex_compiler_latexmk"] = {executable = "latexmk", options = {"-xelatex", "-file-line-error", "-synctex=1", "-interaction=nonstopmode"}}
    vim.g["vimtex_view_method"] = "zathura"
    vim.g["vimtex_quickfix_mode"] = 0
    vim.g["tex_conceal"] = ""
    return nil
  end
  use({"lervag/vimtex", config = _3_})
  use({"guns/vim-sexp"})
  require("plugins.vim-sexp")
  local function _4_()
    vim.g["indentLine_setColors"] = 0
    vim.g["indentLine_char"] = "\194\183"
    vim.g["indentLine_fileTypeExclude"] = {"markdown"}
    return nil
  end
  use({"Yggdroot/indentLine", config = _4_})
  return use({"tweekmonster/startuptime.vim", cmd = "StartupTime"})
end
local p = require("packer")
return p.startup(plugins)