function recursive_find_functions( input_table, table_stack, functions )
  functions = functions and functions or {}
  for i,v in pairs(input_table) do
    if type(v) == "function" then
      table.insert(functions,table.concat(table_stack,".").."."..i)
    end
    if type(v) == "table" then
      local new_table_stack = {}
      for _,stackv in pairs(table_stack) do
        table.insert(new_table_stack,stackv)
      end
      table.insert(new_table_stack,i)
      recursive_find_functions( v , new_table_stack, functions )
    end
  end
  return functions
end

fs = recursive_find_functions(love,{"love"})

for _,v in pairs(fs) do
  print(v)
end

love.event.quit()
