local function def_test(name, x, y)
  if (x == y) then
    return print((name .. ": passed"))
  else
    return print((name .. ": failed"))
  end
end
def_test("just a string", "foobar", "foobar")
def_test("table with strings", "foobar", "foobar")
local table_with_strings = "bar"
return def_test("table with strings", table.concat({"foo", table_with_strings, "baz"}, " "), "foo bar baz")