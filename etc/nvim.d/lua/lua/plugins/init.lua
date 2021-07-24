local function plugins()
  use({"wbthomason/packer.nvim"})
  use({"/home/sean/code/zest"})
  use({"/home/sean/code/limestone"})
  use({"morhetz/gruvbox"})
  use({"junegunn/fzf.vim"})
  use({"neovim/nvim-lspconfig"})
  use({"huyvohcmc/atlas.vim"})
  local function _0_()
    local ts = require("nvim-treesitter.configs")
    return ts.setup({highlight = {enable = true}})
  end
  use({"nvim-treesitter/nvim-treesitter", config = _0_, event = "BufRead", run = ":TSUpdate"})
  use({"nvim-treesitter/playground", after = "nvim-treesitter"})
  local function _1_()
    return require("plugins.nvim-compe")
  end
  use({"hrsh7th/nvim-compe", config = _1_, event = "InsertEnter"})
  use({"rktjmp/lush.nvim"})
  local function _2_()
    vim.g["tex_flavor"] = "latex"
    vim.g["vimtex_compiler_latexmk"] = {executable = "latexmk", options = {"-xelatex", "-file-line-error", "-synctex=1", "-interaction=nonstopmode"}}
    vim.g["vimtex_view_method"] = "zathura"
    vim.g["vimtex_quickfix_mode"] = 0
    vim.g["tex_conceal"] = ""
    return nil
  end
  use({"lervag/vimtex", config = _2_})
  use({"bakpakin/fennel.vim", ft = {"fennel"}})
  use({"guns/vim-sexp"})
  require("plugins.vim-sexp")
  local function _3_()
    vim.g["indentLine_setColors"] = 0
    vim.g["indentLine_char"] = "\194\183"
    vim.g["indentLine_fileTypeExclude"] = {"markdown"}
    return nil
  end
  use({"Yggdroot/indentLine", config = _3_})
  return use({"tweekmonster/startuptime.vim", cmd = "StartupTime"})
end
local p = require("packer")
return p.startup(plugins)