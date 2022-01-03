local cmp = require 'cmp'
local luasnip = require 'luasnip'
local ki = require 'lib.ki'

local function feedkeys(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function check_back_space()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

local kind_icons = {
  Text = " ",
  Method = "",
  Function = "ƒ",
  Constructor = "",
  Field = "·",
  Variable = "◇", -- ⬡
  Class = "",
  Interface = "",
  Module = "",
  Property = "·",
  Unit = "∫",
  Value = "›", -- ⊻
  Enum = "∑", -- ehh...
  Keyword = "⚍",
  Snippet = "⇋",
  Color = "",
  File = "□",
  Reference = "",
  Folder = "◪",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = ""
}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- allow cmp to expand lsp snippets
    end
  },

  mapping = {
    ['<C-b>'] = cmp.config.disable,
    ['<C-f>'] = cmp.config.disable,
    ['<C-Space>'] = cmp.config.disable,
    ['<C-y>'] = cmp.config.disable,
    ['<C-e>'] = cmp.config.disable,
    --['<Tab>'] = cmp.config.disable,
    --['<S-Tab>'] = cmp.config.disable,
    --['<CR>'] = cmp.config.disable,

    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      --elseif luasnip.expand_or_jumpable() then
      --  luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      --elseif luasnip.jumpable(-1) then
      --  luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<CR>'] = cmp.mapping.confirm({ select = false }),
     -- { select = false } makes it so that <cr> doesn't accept a menu item unless one has
     -- been explicitly selected
  },

  sources = cmp.config.sources({
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'nvim_lua' },
    { name = 'buffer' },
  }),

  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, vim_item)
      if kind_icons[vim_item.kind] ~= '' then
        vim_item.kind = kind_icons[vim_item.kind]
      end

      vim_item.menu = ({
        buffer = "<buf>",
        nvim_lsp = "<lsp>",
        luasnip = "<snp>",
        nvim_lua = "<vim>",
        latex_symbols = "<tex>",
      })[entry.source.name]
      return vim_item
    end
  }
}

--cmp.setup.cmdline('/', {
--  sources = {
--    { name = 'buffer' }
--  }
--})

cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- load snippets
require('luasnip.loaders.from_snipmate').load {
  paths = '~/.garden/etc/nvim/lua/snp' -- FIXME get rid of the abs path
}

-- snippet keymaps (the (b)back and (w)ord mnemonic)
ki.is('<c-w>', function()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  end
  return ''
end, { 'expr' })

ki.is('<c-b>', function()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  end
  return ''
end, { 'expr' })
