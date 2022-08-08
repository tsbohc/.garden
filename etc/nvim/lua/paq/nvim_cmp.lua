local cmp = require 'cmp'

-- local function feedkeys(key, mode)
--    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
-- end

local function has_words_before()
   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- local function t(str)
--    return vim.api.nvim_replace_termcodes(str, true, true, true)
-- end

-- local function check_back_space()
--    local col = vim.fn.col('.') - 1
--    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
--       return true
--    else
--       return false
--    end
-- end

local kind_icons = {
   Text = " ",
   Method = "m",
   Function = "f",
   Constructor = "",
   Field = "·",
   Variable = "v", -- ⬡
   Class = "",
   Interface = "i",
   Module = "m",
   Property = "·",
   Unit = "u",
   Value = "v", -- ⊻
   Enum = "e", -- ehh...
   Keyword = "⚍",
   Snippet = "⇋",
   Color = "",
   File = "-",
   Reference = "",
   Folder = "+",
   EnumMember = "",
   Constant = "",
   Struct = "s",
   Event = "",
   Operator = "o",
   TypeParameter = ""
}

cmp.setup {
   snippet = {
      expand = function(args)
         require('luasnip').lsp_expand(args.body)
      end
   },

   window = {
    completion = {
      winhighlight = 'Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None',
    },
    documentation = {
      winhighlight = 'Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None',
    },
   },

   -- experimental = {
   --    ghost_text = { hl_group = 'Conceal' }
   -- },

   mapping = {
      ['<Tab>'] = cmp.mapping(function(fallback)
         if cmp.visible() then
            cmp.select_next_item()
         elseif has_words_before() then
            cmp.complete()
         else
            fallback()
         end
      end, { 'i', 's' }),

      ['<S-Tab>'] = cmp.mapping(function(fallback)
         if cmp.visible() then
            cmp.select_prev_item()
         else
            fallback()
         end
      end, { 'i', 's' }),

      ['<CR>'] = cmp.mapping.confirm({ select = false }),
      -- { select = false } makes it so that <cr> doesn't accept a menu item unless one has
      -- been explicitly selected
   },

   sources = cmp.config.sources(
   {
      { name = 'luasnip', trigger_characters = { '.' } }, -- NOTE very important!! this fixes lsp overriding postfix snippets beginning with this character
      { name = 'nvim_lsp' },
      { name = 'path' },
      { name = 'nvim_lua' },
   }, {
      { name = 'buffer', option = { keyword_length = 5 } },
   }
   ),

   formatting = {
      fields = { 'kind', 'abbr', 'menu' },
      format = function(entry, vim_item)
         if kind_icons[vim_item.kind] ~= '' then
            vim_item.kind = kind_icons[vim_item.kind]
         end

         vim_item.menu = ({
            luasnip = "snp",
            buffer = "buf",
            nvim_lsp = "lsp",
            nvim_lua = "vim",
            latex_symbols = "tex",
         })[entry.source.name]
         return vim_item
      end
   }
}

cmp.setup.cmdline('/', {
   mapping = cmp.mapping.preset.cmdline(),
   sources = {
      { name = 'buffer' }
   }
})

cmp.setup.cmdline(':', {
   mapping = cmp.mapping.preset.cmdline(),
   sources = cmp.config.sources({
      { name = 'path' }
   }, {
      { name = 'cmdline' }
   })
})
