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

local function same(index)
   return f(function(arg)
      print(vim.inspect(arg))
      return ''
   end, { index })
end

local function feedkeys(key, mode)
   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local function Snippet(...)
   local args = {...}
   local keymap = table.remove(args, #args)
   local snippet = s(...)
   vim.keymap.set({ 'n' }, 's' .. keymap, function()
      ls.snip_expand(snippet)
   end)
   vim.keymap.set({ 'v' }, 's' .. keymap, function()
      feedkeys('<c-c>', 'x')
      -- require('luasnip.util.util').store_selection()
      -- vim.cmd[[norm! gv"_s]]
      ls.snip_expand(snippet)
   end)
   return snippet
end

-- snippets that are actually good

local _require = Snippet('req', fmt([[
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

local _local = Snippet('local', fmt([[
      local {1} = {2}
   ]], {
      [1] = i(1, 'x'),
      [2] = i(2, '1')
   }
), 'l')

local function super(position)
   is_dyn = true

   local dyn = d(position, function(_, snip)
      if #snip.env.SELECT_DEDENT > 0 then
         local sa = {} -- NB: we clone here lest the indent will keep stacking on every update
         for _, v in ipairs(snip.env.SELECT_DEDENT) do table.insert(sa, v) end

         return isn(nil, {
            t(sa)
         }, '\t')
      else
         is_dyn = false
      end
   end, { 1, 2 })

   if is_dyn then
      print('dyn')
      return dyn
   else
      return t('foo')
   end

   -- dyn = d(position, function(args, _)
   --    return isn(nil, {
   --       t('woo')
   --    }, '\t')
   -- end, { 1, 2 })
   --
   -- return dyn
end

local _local_function = s('if', fmt([[
      local function {1}({2})
         {3}{4}
      end
   ]], {
      [1] = i(1, 'fn'),
      [2] = i(2, '...'),
      [3] = super(3),
      [4] = i(0)
   }
))

return {
   _test,
   _foo,
   _bar,
   _local,
   _local_function,
   _require,
   _print,
   _isn2,
}

-- return {
--    s('req', fmt([[
--       local {1} = require('{2}')
--    ]], {
--       -- TODO replace f() with a jumpable node
--       [1] = f(function(import_name)
--          local parts = vim.split(import_name[1][1], '.', true)
--          if parts[#parts] == '' and parts[#parts-1] then
--             return parts[#parts-1]
--          else
--             return parts[#parts]
--          end
--       end, { 1 }),
--       [2] = i(1, 'm')
--    })),
--
   -- s('sametest', fmt([[
   --    example: {}, function: {}
   -- ]], {
   --    i(1),
   --    same(1)
   -- })),

   -- function
   -- s('f', fmt([[
   --    {1}function {2}({3})
   --       --
   --    end
   -- ]], {
   --    c(1, { t 'local ', t '' }),
   --    i(2, 'f'),
   --    i(3, '...'),
   -- })),





-- local _local_function = s('fn', fmt([[
--       local function {1}({2})
--          {3}
--       end
--    ]], {
--       i(1, 'fn'),
--       i(2, '...'),
--       indent(3, { t('woo') }, '  '),
--       -- isn(3, {
--       --    f(function(_, snip)
--       --       print(vim.inspect(snip.env.SELECT_DEDENT))
--       --       return snip.env.SELECT_DEDENT
--       --    end, {})
--       -- }, '$PARENT_INDENT    ')
--    })
-- )

-- local _isn2 = s("tt", {
--    isn(1, {
--       f(function(args, snip)
--          return snip.env.SELECT_RAW
--       end)
--    }, "$PARENT_INDENT")
-- })


-- ouch

-- local _print = Snippet("print", fmt([[
--       print({})
--    ]], {
--       d(1, function(_, snip)
--          if snip.env.SELECT_RAW then
--             return sn(1, t(snip.env.SELECT_RAW))
--          else
--             return sn(1, i(1, [['s']]))
--          end
--       end)
--    }
-- ), 'p')

-- local _selected_text = Snippet("selected_text", {
--    f(function(_, snip) return '-' .. snip.env.TM_SELECTED_TEXT[1] .. '-' end, {})
-- }, 'ss')






-- }


      -- [3] = d(3, function(args, snip)
      --    -- print(vim.inspect(snip.env.SELECT_DEDENT))
      --    -- return isn(1, t(snip.env.SELECT_DEDENT
      --    --    or ([[print('fn:]] .. args[1][1] .. [[', ]] .. args[2][1] .. [[)]])), '\t')
      --    if snip.env.SELECT_DEDENT then
      --       return isn(1, {
      --          t(snip.env.SELECT_DEDENT)
      --       }, '\t')
      --    else
      --       return sn(1, {
      --          i(1, [[print('fn:]] .. args[1][1] .. [[', ]] .. args[2][1] .. [[)]]) -- try string.format here
      --       })
      --    end
      -- end, { 1, 2 }),


      -- bugfree (i think)
      -- [3] = d(3, function(_, snip)
      --    -- print(vim.inspect(snip.env.SELECT_DEDENT))
      --    if #snip.env.SELECT_DEDENT > 0 then
      --       return isn(nil, {
      --          t(snip.env.SELECT_DEDENT)
      --       }, '\t')
      --    else
      --       -- print(vim.inspect(args))
      --       return sn(nil, {
      --          i(1, '--')
      --       })
      --    end
      -- end),

