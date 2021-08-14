do
  local packer_path = (vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim")
  if (vim.fn.empty(vim.fn.glob(packer_path)) > 0) then
    vim.fn.system({"git", "clone", "https://github.com/wbthomason/packer.nvim", packer_path})
  end
end
vim.cmd("packadd packer.nvim")
local ok_3f, packer = pcall(require, "packer")
if ok_3f then
  local plugins = require("plugins")
  local function _0_()
    use { 'wbthomason/packer.nvim', opt = true }
    for _, p in ipairs(plugins) do
      use(p)
    end
    return nil
  end
  return packer.startup(_0_)
end