local ok, cmp = pcall(require, 'cmp')
if not ok then
  -- TODO xp call this with a stack trace?
  print 'error while loading "cmp"'
  return
end

local ok, luasnip = pcall(require, 'luasnip')
if not ok then
  print 'error while loading "luasnip"'
  return
end

local function feedkeys(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- ·
local kind_icons = {
  Text = " ",
  Method = "",
  Function = "ƒ",
  Constructor = "",
  Field = "",
  Variable = "◇", -- ⬡
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "∫",
  Value = "›", -- ⊻
  Enum = "",
  Keyword = "⚍",
  Snippet = "⇋",
  Color = "",
  File = "▬",
  Reference = "",
  Folder = "▭",
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
      require('luasnip').lsp_expand(args.body)
    end
  },

  mapping = {
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<S-Tab>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<CR>'] = cmp.mapping.confirm({ select = true }),
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
      -- TODO: play around with icons
      if kind_icons[vim_item.kind] ~= '' then
        vim_item.kind = kind_icons[vim_item.kind]
      end

      vim_item.menu = ({
        buffer = "<buf>",
        nvim_lsp = "<lsp>",
        luasnip = "<sni>",
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
require("luasnip.loaders.from_vscode").lazy_load() 
