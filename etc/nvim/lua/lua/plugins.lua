local sexp = require("plug.vim-sexp")
sexp()
local function _0_()
  vim.g.indentLine_setColors = 0
  vim.g.indentLine_char = "\194\183"
  vim.g.indentLine_fileTypeExclude = {"markdown"}
  return nil
end
return {{"/home/sean/code/zest"}, {"/home/sean/code/limestone", requires = {"rktjmp/lush.nvim"}}, {"nvim-treesitter/nvim-treesitter", branch = "0.5-compat", config = require("plug.nvim-treesitter"), event = {"BufRead", "BufWritePost"}, opt = true, run = ":TSUpdate"}, {"jose-elias-alvarez/null-ls.nvim", config = require("plug.null-ls"), requires = {"nvim-lua/plenary.nvim", "neovim/nvim-lspconfig"}}, {"hrsh7th/nvim-compe", config = require("plug.nvim-compe"), event = "InsertEnter", opt = true}, {"tweekmonster/startuptime.vim", cmd = "StartupTime"}, {"bakpakin/fennel.vim", ft = {"fennel"}}, {"guns/vim-sexp", ft = {"fennel", "fnl"}}, {"Yggdroot/indentLine", config = _0_}}