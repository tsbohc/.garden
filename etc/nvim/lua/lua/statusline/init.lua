local sl = require("statusline.sl")
local function _0_()
  local fname = vim.fn.expand("%:t")
  if (fname ~= "") then
    return ("\226\128\185\226\128\185 " .. fname .. " \226\128\186\226\128\186")
  else
    return " \226\128\185 new \226\128\186 "
  end
end
sl.fn({"BufEnter"}, {0, 0, 1, 1, "CursorLine"}, _0_)
local function _1_()
  if (vim.fn.expand("%:t") ~= "") then
    return "%{&modified?'':'saved'}"
  end
end
sl.fn({"BufEnter", "BufWritePost"}, {1, 0, 0, 0}, _1_)
local function _2_()
  if vim.bo.readonly then
    return "readonly"
  end
end
sl.fn({"BufEnter"}, {1, 0, 1, 1, "Search"}, _2_)
sl.st({0, 0, 0, 0}, "%=%<")
local function _3_()
  local n = vim.lsp.diagnostic.get_count(0, "Error")
  if (n > 0) then
    return ("%#LineNr#<%#LspDiagnosticsFloatingError#" .. n .. "%#LineNr#>")
  else
    return ""
  end
end
sl.fn({"VimEnter", "CursorMoved", "CursorMovedI"}, {1, 0, 0, 0, "LspDiagnosticsSignError"}, _3_)
local function _4_()
  local n = vim.lsp.diagnostic.get_count(0, "Warning")
  if (n > 0) then
    return ("%#LineNr#<%#LspDiagnosticsFloatingWarning#" .. n .. "%#LineNr#>")
  else
    return ""
  end
end
sl.fn({"VimEnter", "CursorMoved", "CursorMovedI"}, {1, 0, 0, 0, "LspDiagnosticsSignWarning"}, _4_)
local function _5_()
  return vim.fn.expand("%:p:~:h")
end
sl.fn({"BufEnter", "BufWritePost"}, {1, 0, 0, 0}, _5_)
local function _6_()
  return vim.bo.filetype
end
sl.fn({"BufReadPost", "BufWritePost"}, {1, 0, 0, 0}, _6_)
sl.st({1, 0, 1, 1, "CursorLine"}, "%2p%%")
return sl.init()