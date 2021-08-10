do
  vim.cmd("augroup smart-cursorline")
  vim.cmd("autocmd!")
  do
    do
      local zest_autocmd_0_
      local function _0_()
        vim.opt.cursorline = false
        return nil
      end
      zest_autocmd_0_ = {cmd = ":call v:lua._zest.autocmd.yCS4gwfw.f()", events = "InsertEnter,BufLeave,FocusLost", f = _0_, patterns = "*"}
      _G._zest.autocmd["yCS4gwfw"] = zest_autocmd_0_
      vim.cmd(("autocmd " .. zest_autocmd_0_.events .. " " .. zest_autocmd_0_.patterns .. " " .. zest_autocmd_0_.cmd))
    end
    local zest_autocmd_0_
    local function _0_()
      if (vim.fn.mode() ~= "i") then
        vim.opt.cursorline = true
        return nil
      end
    end
    zest_autocmd_0_ = {cmd = ":call v:lua._zest.autocmd.MAg611Wl.f()", events = "InsertLeave,BufEnter,FocusGained", f = _0_, patterns = "*"}
    _G._zest.autocmd["MAg611Wl"] = zest_autocmd_0_
    vim.cmd(("autocmd " .. zest_autocmd_0_.events .. " " .. zest_autocmd_0_.patterns .. " " .. zest_autocmd_0_.cmd))
  end
  vim.cmd("augroup END")
end
do
  vim.cmd("augroup restore-position")
  vim.cmd("autocmd!")
  do
    local zest_autocmd_0_
    local function _0_()
      if ((vim.fn.line("'\"") > 1) and (vim.fn.line("'\"") <= vim.fn.line("$"))) then
        return vim.cmd("normal! g'\"")
      end
    end
    zest_autocmd_0_ = {cmd = ":call v:lua._zest.autocmd.OcLomlNr.f()", events = "BufReadPost", f = _0_, patterns = "*"}
    _G._zest.autocmd["OcLomlNr"] = zest_autocmd_0_
    vim.cmd(("autocmd " .. zest_autocmd_0_.events .. " " .. zest_autocmd_0_.patterns .. " " .. zest_autocmd_0_.cmd))
  end
  vim.cmd("augroup END")
end
do
  vim.cmd("augroup flash-yank")
  vim.cmd("autocmd!")
  do
    local zest_autocmd_0_
    local function _0_()
      return vim.highlight.on_yank({higroup = "Search", timeout = 100})
    end
    zest_autocmd_0_ = {cmd = ":call v:lua._zest.autocmd.AptvNAWn.f()", events = "TextYankPost", f = _0_, patterns = "*"}
    _G._zest.autocmd["AptvNAWn"] = zest_autocmd_0_
    vim.cmd(("autocmd " .. zest_autocmd_0_.events .. " " .. zest_autocmd_0_.patterns .. " " .. zest_autocmd_0_.cmd))
  end
  vim.cmd("augroup END")
end
do
  vim.cmd("augroup split-settings")
  vim.cmd("autocmd!")
  do
    do
      local zest_autocmd_0_
      local function _0_()
        if (#vim.fn.tabpagebuflist() > 1) then
          return vim.api.nvim_command("wincmd =")
        end
      end
      zest_autocmd_0_ = {cmd = ":call v:lua._zest.autocmd.qqxdCXwh.f()", events = "VimResized", f = _0_, patterns = "*"}
      _G._zest.autocmd["qqxdCXwh"] = zest_autocmd_0_
      vim.cmd(("autocmd " .. zest_autocmd_0_.events .. " " .. zest_autocmd_0_.patterns .. " " .. zest_autocmd_0_.cmd))
    end
    local zest_autocmd_0_ = {cmd = "wincmd L", events = "FileType", patterns = "help"}
    _G._zest.autocmd["UvSKnzUM"] = zest_autocmd_0_
    vim.cmd(("autocmd " .. zest_autocmd_0_.events .. " " .. zest_autocmd_0_.patterns .. " " .. zest_autocmd_0_.cmd))
  end
  vim.cmd("augroup END")
end
do
  vim.cmd("augroup filetype-settings")
  vim.cmd("autocmd!")
  do
    do
      local zest_autocmd_0_ = {cmd = "set wrap", events = "FileType", patterns = "text,latex,markdown"}
      _G._zest.autocmd["DUi4PaW5"] = zest_autocmd_0_
      vim.cmd(("autocmd " .. zest_autocmd_0_.events .. " " .. zest_autocmd_0_.patterns .. " " .. zest_autocmd_0_.cmd))
    end
    local zest_autocmd_0_
    local function _0_()
      do end (vim.opt.iskeyword):remove(".")
      return (vim.opt.lispwords):append({"string.*", "table.*", "au.no-", "au.fn-", "ki.no-", "ki.fn-"})
    end
    zest_autocmd_0_ = {cmd = ":call v:lua._zest.autocmd.m9dS7Rot.f()", events = "FileType", f = _0_, patterns = "fennel"}
    _G._zest.autocmd["m9dS7Rot"] = zest_autocmd_0_
    vim.cmd(("autocmd " .. zest_autocmd_0_.events .. " " .. zest_autocmd_0_.patterns .. " " .. zest_autocmd_0_.cmd))
  end
  vim.cmd("augroup END")
end
local xkbmap_normal = {layout = "us", variant = "colemak"}
local xkbmap_insert = {}
local function get_xkbmap()
  local handle = assert(io.popen("setxkbmap -query"))
  local function close_handlers_0_(ok_0_, ...)
    handle:close()
    if ok_0_ then
      return ...
    else
      return error(..., 0)
    end
  end
  local function _0_()
    local out = handle:read("*a")
    local xt = {}
    for k, v in out:gmatch("(.-):%s*(.-)%s+") do
      xt[k] = v
    end
    return xt
  end
  return close_handlers_0_(xpcall(_0_, (package.loaded.fennel or debug).traceback))
end
local function set_xkbmap(x)
  return os.execute(("setxkbmap " .. x.layout .. " -variant " .. x.variant))
end
vim.cmd("augroup keyboard-switcher")
vim.cmd("autocmd!")
do
  do
    local zest_autocmd_0_
    local function _0_()
      if (xkbmap_insert.layout and (xkbmap_insert.layout ~= xkbmap_normal.layout)) then
        return set_xkbmap(xkbmap_insert)
      end
    end
    zest_autocmd_0_ = {cmd = ":call v:lua._zest.autocmd.bkgSmzwc.f()", events = "InsertEnter", f = _0_, patterns = "*"}
    _G._zest.autocmd["bkgSmzwc"] = zest_autocmd_0_
    vim.cmd(("autocmd " .. zest_autocmd_0_.events .. " " .. zest_autocmd_0_.patterns .. " " .. zest_autocmd_0_.cmd))
  end
  local zest_autocmd_0_
  local function _0_()
    xkbmap_insert = get_xkbmap()
    vim.g["_layout"] = xkbmap_insert.layout
    if (xkbmap_insert.layout ~= xkbmap_normal.layout) then
      return set_xkbmap(xkbmap_normal)
    end
  end
  zest_autocmd_0_ = {cmd = ":call v:lua._zest.autocmd.ywBkJbRO.f()", events = "InsertLeave", f = _0_, patterns = "*"}
  _G._zest.autocmd["ywBkJbRO"] = zest_autocmd_0_
  vim.cmd(("autocmd " .. zest_autocmd_0_.events .. " " .. zest_autocmd_0_.patterns .. " " .. zest_autocmd_0_.cmd))
end
return vim.cmd("augroup END")