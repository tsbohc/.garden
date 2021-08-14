-- 16x slowe compared to defining just 10 locals
for i = 1, 10000000 do
  local t = { a = 1, b = 2, c = 3, d = 4, e = 5, f = 6, g = 7, h = 8, i = 9, j = 10 }
end


--for i = 1, 10000000 do
--  local a = {}
--  a.a = 1
--  a.b = 2
--  a.c = 3
--  a.d = 4
--  a.e = 5
--  a.f = 6
--  a.g = 7
--  a.h = 8
--  a.i = 9
--  a.j = 10
--end


--for i = 1, 10000000 do
--  local a = 1
--  local b = 2
--  local c = 3
--  local d = 4
--  local e = 5
--  local f = 6
--  local g = 7
--  local h = 8
--  local i = 9
--  local j = 10
----  local t = { a = a, b = b, c = c, d = d, e = e, f = f, g = g, h = h, i = i, j = j}
--end


-- no real difference: 270ms vs 290ms
--for i = 1, 1000000 do
--  local zest_keymap_2_ = {lhs = "<c-m>", opts = {expr = true, noremap = true}, rhs = "echo 'woo'"}
--  _, _, _ = zest_keymap_2_.lhs, zest_keymap_2_.rhs, zest_keymap_2_.opts
--end
--
--for i = 1, 1000000 do
--  local lhs = "<c-m>"
--  local opts = {expr = true, noremap = true}
--  local rhs = "echo 'woo'"
--  local zest_keymap_2_ = {lhs = lhs, opts = opts, rhs = rhs}
--  _, _, _ = lhs, rhs, opts
--end
