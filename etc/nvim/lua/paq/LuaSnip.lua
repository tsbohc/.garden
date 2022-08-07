-- {{{
local ls = require('luasnip')

local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node

local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local fmt = require("luasnip.extras.fmt").fmt
local m = require("luasnip.extras").m
local lambda = require("luasnip.extras").l
local dlambda = require("luasnip.extras").dynamic_lambda
local rep = require("luasnip.extras").rep -- repeat a node
local postfix = require("luasnip.extras.postfix").postfix

local util = require("luasnip.util.util")
local types = require("luasnip.util.types")
-- }}}

-- FIXME figure out why lsp is overriding snippets
-- TODO add while loop thing

ls.config.setup({
   history = true,
   update_events = 'TextChanged,TextChangedI',
   -- region_check_events = "InsertEnter",
   -- delete_check_events = "TextChanged,InsertLeave",
   store_selection_keys = "<c-c>",
   ext_opts = {
      [types.choiceNode] = {
         active = {
            virt_text = { { '◆', 'MyLuaSnipChoice' } }
         }
      }
   }
})


function Leave_snippet()
   if
      ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
      and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
      and not require('luasnip').session.jump_active
   then
      require('luasnip').unlink_current()
   end
end

-- NB can't put this into a group
vim.api.nvim_command([[autocmd ModeChanged * lua Leave_snippet()]])


-- snippets

-- load snipmate snippets
-- require('luasnip.loaders.from_snipmate').load {
--    paths = '~/.garden/etc/nvim/lua/snp' -- FIXME get rid of the abs path
-- }

-- require('luasnip.loaders.from_lua').load {
--    paths = '~/.garden/etc/nvim/lua/snp' -- FIXME get rid of the abs path
-- }

-- keymaps

vim.keymap.set({ 'i', 's' }, '<c-n>', function()
   if ls.expand_or_locally_jumpable() then
      ls.expand_or_jump()
   end
end, { silent = true })

vim.keymap.set({ 'i', 's' }, '<c-e>', function()
   if ls.jumpable(-1) then
      ls.jump(-1)
   end
end, { silent = true })

vim.keymap.set('i', '<c-t>', function()
   if ls.choice_active() then
      ls.change_choice(1)
   end
end)

-- snippets (for real this time)

local snippets = {}

local function feedkeys(key, mode)
   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local function Snippet(...)
   local args = {...}
   local keymap = table.remove(args, #args)
   local snippet = s(...)

   -- vim.keymap.set({ 'n' }, 's' .. keymap, function()
   --    ls.snip_expand(snippet)
   -- end)
   --
   vim.keymap.set({ 'v' }, 's' .. keymap, function()
      -- local m = vim.fn.mode()
      -- print(m)
      -- if m == 'v' then
      --    vim.cmd[[norm! V]]
      -- end
      -- vim.cmd[[norm! ^]]
      -- local p = vim.fn.getpos '.'
      -- local p = vim.api.nvim_win_get_cursor(0)
      feedkeys('<c-c>', 'x')
      -- require('luasnip.util.util').store_selection()
      -- vim.cmd[[norm! "_s]]
      -- vim.fn.setpos('.', p)
      -- ls.snip_expand(snippet, {
      --    pos = p
      -- })
      ls.snip_expand(snippet)
   end)
   table.insert(snippets, snippet)
   return snippet
end

local function Postfix(...)
   local snippet = postfix(...)
   table.insert(snippets, snippet)
end

-- require

Snippet('req', fmt([[
      local {1} = require('{2}')
   ]], {
      [1] = d(2, function(import_name)
         local parts = vim.split(import_name[1][1], '.', true)
         local placeholder
         if parts[#parts] == '' and parts[#parts-1] then
            placeholder = parts[#parts-1]
         else
            placeholder = parts[#parts]
         end
         return sn(nil, i(1, placeholder))
      end, { 1 }),
      [2] = i(1, 'm')
   }
), 'r')

local function selection(position, placeholder)
   return d(position, function(_, snip)
      if #snip.env.SELECT_DEDENT > 0 then
         -- TODO what
         -- local sa = {} -- NB: we clone here lest the indent will keep stacking on every update
         -- for _, v in ipairs(snip.env.SELECT_DEDENT) do table.insert(sa, v) end
         -- return isn(nil, {
         --    t(sa)
         -- }, '\t$PARENT_INDENT')
         return isn(nil, {
            t(snip.env.SELECT_DEDENT),
            i(1)
         }, '\t$PARENT_INDENT')
      else
         return sn(nil, { i(1, placeholder) })
      end
   end)
end

-- local

Snippet('local', fmt([[
      local {1} = {2}
   ]], {
      [1] = i(1, 'x'),
      [2] = selection(2, '1')
   }
), 'v')

local function if_choice(position, depth)
   -- to prevent stack overflow
   if depth > 4 then
      return
   end
   depth = depth + 1
   return c(position, {
      t(''),
      sn(nil, {
         i(1),
         sn(2, {
            t({ '', 'else', '\t' }),
            i(1, '--')
         })
      }),
      sn(nil, {
         i(1),
         sn(2, {
            t({ '', 'elseif ' }),
            i(1, 'true'),
            t({ ' then', '\t' }),
            i(2, '--'),
            if_choice(3, depth)
         })
      })
   })
end

Snippet('if', fmt([[
      if {1} then
         {2}{3}
      end
   ]], {
      [1] = i(1, 'true'),
      [2] = selection(2, '--'),
      [3] = if_choice(3, 1)
   }
), 'c')

Snippet('elif', fmt([[
      elseif {1} then
         {2}
      end
   ]], {
      [1] = i(1, 'y'),
      [2] = selection(2, '--'),
   }
), 'e')

-- loops

Snippet('forp', fmt([[
      for {1}, {2} in pairs({3}) do
         {4}
      end
   ]], {
      [1] = i(1, 'k'),
      [2] = i(2, 'v'),
      [3] = i(3, 'xt'),
      [4] = selection(4, '--'),
   }
), 'lp')

Snippet('fori', fmt([[
      for {1}, {2} in ipairs({3}) do
         {4}
      end
   ]], {
      [1] = i(1, '_'),
      [2] = i(2, 'v'),
      [3] = i(3, 'xs'),
      [4] = selection(4, '--'),
   }
), 'li')

Snippet('forn', fmt([[
      for {1} = {2}, {3}, {4} do
         {5}
      end
   ]], {
      [1] = i(1, 'i'),
      [2] = i(2, '1'),
      [3] = i(3, '10'),
      [4] = i(4, '1'),
      [5] = selection(5, '--'),
   }
), 'ln')

-- function

Snippet('fn', fmt([[
      local function {1}({2})
         {3}
      end
   ]], {
      [1] = i(1, 'fn'),
      [2] = i(2, '...'),
      [3] = selection(3, '--'),
   }
), 'f')

-- TODO a 'describe' snippet that can be entered before a function
-- will look up it's param list and (return?)
-- and construct a documentation list

-- Snippet('dfn', fmt([[
--       ---{3}
--       {4}
--       local function {1}({2})
--          {5}
--       end
--    ]], {
--       [1] = i(1, 'fn'),
--       [2] = i(2, '...'),
--       [3] = i(3, 'description'),
--       [4] = d(4, function(args)
--          -- print(vim.inspect(args))
--
--          local xs = {}
--          local id = 1
--
--          for a in string.gmatch(args[1][1], "(%s+)[,%)]") do -- broken
--             table.insert(xs, sn(id, {
--                t({'---@param ' .. a .. ' '}),
--                i(1, 'type'),
--                t({'', ''})
--             }))
--             id = id + 1
--          end
--
--          return sn(nil, xs)
--       end, { 2 }),
--       [5] = selection(5, '--'),
--    }
-- ), 'd')


Snippet('gfn', fmt([[
      function {1}({2})
         {3}
      end
   ]], {
      [1] = i(1, 'fn'),
      [2] = i(2, '...'),
      [3] = selection(3, '--'),
   }
), 'g')

-- postfix

local function postfix_match()
   return f(function(_, parent)
      return parent.snippet.env.POSTFIX_MATCH:match'^%s*(.*)'
   end)
end

Postfix({
      trig = '@print',
      match_pattern = '%s*(.+)$'
   }, fmt([[
      print('{1}', {1})
   ]], {
      [1] = postfix_match(),
   })
)


Postfix('@insert', fmt([[
      table.insert({1}, {2})
   ]], {
      [1] = postfix_match(),
      [2] = i(0, 'x')
   })
)

Postfix('@remove', fmt([[
      table.remove({1}, {2})
   ]], {
      [1] = postfix_match(),
      [2] = i(0, 'x')
   })
)

Postfix({
      trig = '@return',
      match_pattern = '%s*(.+)$'
   }, fmt([[
      return {1}
   ]], {
      [1] = postfix_match()
   })
)

Postfix({
      trig = '@assign',
      match_pattern = '%s*(.+)$'
   }, fmt([[
      local {1} = {2}
   ]], {
      [1] = i(0, 'x'),
      [2] = postfix_match()
   })
)

Postfix('@define', fmt([[
      local {1} = {2}
   ]], {
      [1] = postfix_match(),
      [2] = i(0, '1')
   })
)

Postfix('@not', fmt([[
      not {1}
   ]], {
      [1] = postfix_match()
   })
)

Postfix('@if', fmt([[
      if {1} then
         {2}
      end
   ]], {
      [1] = postfix_match(),
      [2] = i(0, '--')
   })
)

Postfix('@ifnot', fmt([[
      if not {1} then
         {2}
      end
   ]], {
      [1] = postfix_match(),
      [2] = i(0, '--')
   })
)

Postfix('@pairs', fmt([[
      for {1}, {2} in pairs({3}) do
         {4}
      end
   ]], {
      [1] = i(1, 'k'),
      [2] = i(2, 'v'),
      [3] = postfix_match(),
      [4] = i(0, '--')
   })
)

Postfix('@ipairs', fmt([[
      for {1}, {2} in ipairs({3}) do
         {4}
      end
   ]], {
      [1] = i(1, '_'),
      [2] = i(2, 'v'),
      [3] = postfix_match(),
      [4] = i(0, '--')
   })
)

local function modify(operator)
   return fmt([[
      {1} = {1} {2} {3}
   ]], {
      [1] = postfix_match(),
      [2] = operator,
      [3] = i(0, '1'),
   })
end

Postfix('=+', modify('+'))
Postfix('@inc', modify('+'))

Postfix('=-', modify('-'))
Postfix('@dec', modify('-'))

Postfix('=.', modify('..'))
Postfix('@app', modify('..'))

Postfix('@pre', fmt([[
      {1} = {2} .. {1}
   ]], {
      [1] = postfix_match(),
      [2] = i(0, [['s']])
   })
)

Postfix('=*', modify('*'))
Postfix('@mul', modify('*'))

Postfix('=:', modify('/'))
Postfix('@div', modify('/'))



-- Snippet('test', fmt([[
--    
-- ]], {
--    
-- }), 't')











-- load everything

ls.add_snippets('lua', snippets, {
   key = 'luasnip_config_file'
})












-- dumpsterfire





-- Snippet('if', fmt([[
--       if {1} then
--          {2}{3}
--       end
--    ]], {
--       [1] = i(1, 'y'),
--       [2] = d(2, simple_restore, { 1 }),
--       [3] = i(0)
--    }
-- ), 'i')
--
-- Snippet('if', fmt([[
--    {1}
--    {2}
-- ]], {
--    i(1, 'foo'),
--    r(2, 'u')
-- }), {
--    stored = {
--       u = d(1, function(args)
--          return sn(nil, {
--             i(1, 'default ' .. args[1][1])
--          })
--       end, {1})
--    }
-- }, 'i')


-- Snippet("rest", {
--    i(1, "preset"), t{"",""},
--    d(2, simple_restore, 1)
-- }, 'q')


-- Snippet('if', fmt([[
--       if {1} then
--          {2}{3}
--       end
--    ]], {
--       [1] = i(1, 'y'),
--       [2] = wrap(2, { 1 }, function(a)
--          return [[print(']] .. a[1][1] .. [[ is true')]]
--       end),
--       [3] = i(0)
--    }
-- ), 'if')

-- Snippet('ife', fmt([[
--       if {1} then
--          {2}
--       else
--          {3}{4}
--       end
--    ]], {
--       [1] = i(1, 'y'),
--       [2] = wrap(2, { 1 }, function(a)
--          return [[print(']] .. a[1][1] .. [[ is true')]]
--       end),
--       [3] = d(3, function(a)
--          return sn(nil, {
--             i(1, [[print(']] .. a[1][1] .. [[ is false')]])
--          })
--       end, { 1 }),
--       [4] = i(0)
--    }
-- ), 'ie')


-- local function wrap(position, args, placeholder)
--    return d(position, function(a, snip)
--       if #snip.env.SELECT_DEDENT > 0 then
--          local sa = {} -- NB: we clone here lest the indent will keep stacking on every update
--          for _, v in ipairs(snip.env.SELECT_DEDENT) do table.insert(sa, v) end
--          return isn(nil, {
--             t(sa)
--          }, '\t$PARENT_INDENT')
--       else
--          return sn(nil, { i(1, placeholder(a)) })
--       end
--    end, args)
-- end
-- local function simple_restore(args, _)
--    return sn(nil, {
--       i(1, args[1][1]),
--       t(' '),
--       d(2, function(a)
--          print(vim.inspect(a))
--          return sn(nil, {
--             r(1, 'dyn', i(nil, a[1][1] .. '_stay'))
--          })
--       end, ai[1])
--    })
-- end
--
-- local function postfix_match1(pos)
--    return d(pos, function(_, parent)
--       local indent, match = parent.snippet.env.POSTFIX_MATCH:match('(%s*)(.*)')
--       print(vim.inspect({ indent, match }))
--       return isn(nil, t('aa'), (indent or ''))
--    end)
-- end
