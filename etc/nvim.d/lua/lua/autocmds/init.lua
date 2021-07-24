do
  vim.api.nvim_command(("augroup " .. "smart-cursorline"))
  vim.api.nvim_command("autocmd!")
  do
    do
      local ZEST_VLUA_0_
      do
        local ZEST_ID_0_ = ("_" .. _G._zest.autocmd["#"])
        local function _0_()
          vim.opt["cursorline"] = false
          return nil
        end
        _G._zest["autocmd"][ZEST_ID_0_] = _0_
        _G._zest["autocmd"]["#"] = (_G._zest.autocmd["#"] + 1)
        ZEST_VLUA_0_ = ("v:lua._zest.autocmd." .. ZEST_ID_0_)
      end
      local ZEST_RHS_0_ = string.format(":call %s()", ZEST_VLUA_0_)
      vim.api.nvim_command(("au " .. "InsertEnter,BufLeave,FocusLost" .. " " .. "*" .. " " .. ZEST_RHS_0_))
    end
    local ZEST_VLUA_0_
    do
      local ZEST_ID_0_ = ("_" .. _G._zest.autocmd["#"])
      local function _0_()
        if (vim.fn.mode() ~= "i") then
          vim.opt["cursorline"] = true
          return nil
        end
      end
      _G._zest["autocmd"][ZEST_ID_0_] = _0_
      _G._zest["autocmd"]["#"] = (_G._zest.autocmd["#"] + 1)
      ZEST_VLUA_0_ = ("v:lua._zest.autocmd." .. ZEST_ID_0_)
    end
    local ZEST_RHS_0_ = string.format(":call %s()", ZEST_VLUA_0_)
    vim.api.nvim_command(("au " .. "InsertLeave,BufEnter,FocusGained" .. " " .. "*" .. " " .. ZEST_RHS_0_))
  end
  vim.api.nvim_command("augroup END")
end
do
  vim.api.nvim_command(("augroup " .. "restore-position"))
  vim.api.nvim_command("autocmd!")
  do
    local ZEST_VLUA_0_
    do
      local ZEST_ID_0_ = ("_" .. _G._zest.autocmd["#"])
      local function _0_()
        if ((vim.fn.line("'\"") > 1) and (vim.fn.line("'\"") <= vim.fn.line("$"))) then
          return vim.cmd("normal! g'\"")
        end
      end
      _G._zest["autocmd"][ZEST_ID_0_] = _0_
      _G._zest["autocmd"]["#"] = (_G._zest.autocmd["#"] + 1)
      ZEST_VLUA_0_ = ("v:lua._zest.autocmd." .. ZEST_ID_0_)
    end
    local ZEST_RHS_0_ = string.format(":call %s()", ZEST_VLUA_0_)
    vim.api.nvim_command(("au " .. "BufReadPost" .. " " .. "*" .. " " .. ZEST_RHS_0_))
  end
  vim.api.nvim_command("augroup END")
end
do
  vim.api.nvim_command(("augroup " .. "flash-yank"))
  vim.api.nvim_command("autocmd!")
  do
    local ZEST_VLUA_0_
    do
      local ZEST_ID_0_ = ("_" .. _G._zest.autocmd["#"])
      local function _0_()
        return vim.highlight.on_yank({higroup = "Search", timeout = 100})
      end
      _G._zest["autocmd"][ZEST_ID_0_] = _0_
      _G._zest["autocmd"]["#"] = (_G._zest.autocmd["#"] + 1)
      ZEST_VLUA_0_ = ("v:lua._zest.autocmd." .. ZEST_ID_0_)
    end
    local ZEST_RHS_0_ = string.format(":call %s()", ZEST_VLUA_0_)
    vim.api.nvim_command(("au " .. "TextYankPost" .. " " .. "*" .. " " .. ZEST_RHS_0_))
  end
  vim.api.nvim_command("augroup END")
end
do
  vim.api.nvim_command(("augroup " .. "split-settings"))
  vim.api.nvim_command("autocmd!")
  do
    do
      local ZEST_VLUA_0_
      do
        local ZEST_ID_0_ = ("_" .. _G._zest.autocmd["#"])
        local function _0_()
          if (#vim.fn.tabpagebuflist() > 1) then
            return vim.api.nvim_command("wincmd =")
          end
        end
        _G._zest["autocmd"][ZEST_ID_0_] = _0_
        _G._zest["autocmd"]["#"] = (_G._zest.autocmd["#"] + 1)
        ZEST_VLUA_0_ = ("v:lua._zest.autocmd." .. ZEST_ID_0_)
      end
      local ZEST_RHS_0_ = string.format(":call %s()", ZEST_VLUA_0_)
      vim.api.nvim_command(("au " .. "VimResized" .. " " .. "*" .. " " .. ZEST_RHS_0_))
    end
    vim.api.nvim_command(("au " .. "FileType" .. " " .. "help" .. " " .. "wincmd L"))
  end
  vim.api.nvim_command("augroup END")
end
do
  vim.api.nvim_command(("augroup " .. "filetype-settings"))
  vim.api.nvim_command("autocmd!")
  do
    vim.api.nvim_command(("au " .. "FileType" .. " " .. "text,latex,markdown" .. " " .. "set wrap"))
    local ZEST_VLUA_0_
    do
      local ZEST_ID_0_ = ("_" .. _G._zest.autocmd["#"])
      local function _0_()
        do end (vim.opt.iskeyword):remove(".")
        return (vim.opt.lispwords):append({"string.*", "table.*", "au.no-", "au.fn-", "au.gr-", "ki.no-", "ki.fn-"})
      end
      _G._zest["autocmd"][ZEST_ID_0_] = _0_
      _G._zest["autocmd"]["#"] = (_G._zest.autocmd["#"] + 1)
      ZEST_VLUA_0_ = ("v:lua._zest.autocmd." .. ZEST_ID_0_)
    end
    local ZEST_RHS_0_ = string.format(":call %s()", ZEST_VLUA_0_)
    vim.api.nvim_command(("au " .. "FileType" .. " " .. "fennel" .. " " .. ZEST_RHS_0_))
  end
  vim.api.nvim_command("augroup END")
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
vim.api.nvim_command(("augroup " .. "keyboard-switcher"))
vim.api.nvim_command("autocmd!")
do
  do
    local ZEST_VLUA_0_
    do
      local ZEST_ID_0_ = ("_" .. _G._zest.autocmd["#"])
      local function _0_()
        if (xkbmap_insert.layout and (xkbmap_insert.layout ~= xkbmap_normal.layout)) then
          return set_xkbmap(xkbmap_insert)
        end
      end
      _G._zest["autocmd"][ZEST_ID_0_] = _0_
      _G._zest["autocmd"]["#"] = (_G._zest.autocmd["#"] + 1)
      ZEST_VLUA_0_ = ("v:lua._zest.autocmd." .. ZEST_ID_0_)
    end
    local ZEST_RHS_0_ = string.format(":call %s()", ZEST_VLUA_0_)
    vim.api.nvim_command(("au " .. "InsertEnter" .. " " .. "*" .. " " .. ZEST_RHS_0_))
  end
  local ZEST_VLUA_0_
  do
    local ZEST_ID_0_ = ("_" .. _G._zest.autocmd["#"])
    local function _0_()
      xkbmap_insert = get_xkbmap()
      vim.g["_layout"] = xkbmap_insert.layout
      if (xkbmap_insert.layout ~= xkbmap_normal.layout) then
        return set_xkbmap(xkbmap_normal)
      end
    end
    _G._zest["autocmd"][ZEST_ID_0_] = _0_
    _G._zest["autocmd"]["#"] = (_G._zest.autocmd["#"] + 1)
    ZEST_VLUA_0_ = ("v:lua._zest.autocmd." .. ZEST_ID_0_)
  end
  local ZEST_RHS_0_ = string.format(":call %s()", ZEST_VLUA_0_)
  vim.api.nvim_command(("au " .. "InsertLeave" .. " " .. "*" .. " " .. ZEST_RHS_0_))
end
return vim.api.nvim_command("augroup END")