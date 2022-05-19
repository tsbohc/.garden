-- version: 0.0.1
-- code: Ketmar // Avalon Group
-- public domain

-- expand $var and ${var} in string
-- ${var} can call Lua functions: ${string.rep(' ', 10)}
-- `$' can be screened with `\'
-- `...': args for $<number>
-- if `...' is just a one table -- take it as args
function ExpandVars (s, ...)
  local args = {...};
  args = #args == 1 and type(args[1]) == "table" and args[1] or args;
  -- return true if there was an expansion
  local function DoExpand (iscode)
    local was = false;
    local mask = iscode and "()%$(%b{})" or "()%$([%a%d_]*)";
    local drepl = iscode and "\\$" or "\\\\$";
    s = s:gsub(mask, function (pos, code)
      if s:sub(pos-1, pos-1) == "\\" then return "$"..code;
      else was = true; local v, err;
        if iscode then code = code:sub(2, -2);
        else local n = tonumber(code);
          if n then v = args[n]; end;
        end;
        if not v then
          v, err = load("return "..code); if not v then error(err); end;
          v = v();
        end;
        if v == nil then v = ""; end;
        v = tostring(v):gsub("%$", drepl);
        return v;
      end;
    end);
    if not (iscode or was) then s = s:gsub("\\%$", "$"); end;
    return was;
  end;

  repeat DoExpand(true); until not DoExpand(false);
  return s;
end;


list = { "one", field = "hi!" };
name = "Lua"; status = "great"

print(
  ExpandVars(
    "${name} is $status. ${string.rep('#', 3)} \\${!} \\$isn't it? "..
      "${list.field}, ${list [1]}, $_VERSION, ${10/2}, ${'$'}, $1",
    {"arg"}));
