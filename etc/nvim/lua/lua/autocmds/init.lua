do
  vim.cmd("augroup smart-cursorline")
  vim.cmd("autocmd!")
  do
    do
      local ZEST_VLUA_0_
      do
        local ZEST_N_0_ = _G._zest.autocmd["#"]
        local ZEST_ID_0_ = ("_" .. ZEST_N_0_)
        local function _0_()
          vim.opt["cursorline"] = false
          return nil
        end
        _G._zest["autocmd"][ZEST_ID_0_] = _0_
        _G._zest["autocmd"]["#"] = (ZEST_N_0_ + 1)
        ZEST_VLUA_0_ = ("v:lua._zest.autocmd." .. ZEST_ID_0_)
      end
      vim.cmd(("autocmd InsertEnter,BufLeave,FocusLost * :call " .. ZEST_VLUA_0_ .. "()"))
    end
    local ZEST_VLUA_0_
    do
      local ZEST_N_0_ = _G._zest.autocmd["#"]
      local ZEST_ID_0_ = ("_" .. ZEST_N_0_)
      local function _0_()
        if (vim.fn.mode() ~= "i") then
          vim.opt["cursorline"] = true
          return nil
        end
      end
      _G._zest["autocmd"][ZEST_ID_0_] = _0_
      _G._zest["autocmd"]["#"] = (ZEST_N_0_ + 1)
      ZEST_VLUA_0_ = ("v:lua._zest.autocmd." .. ZEST_ID_0_)
    end
    vim.cmd(("autocmd InsertLeave,BufEnter,FocusGained * :call " .. ZEST_VLUA_0_ .. "()"))
  end
  vim.cmd("augroup END")
end
do
  vim.cmd("augroup restore-position")
  vim.cmd("autocmd!")
  do
    local ZEST_VLUA_0_
    do
      local ZEST_N_0_ = _G._zest.autocmd["#"]
      local ZEST_ID_0_ = ("_" .. ZEST_N_0_)
      local function _0_()
        if ((vim.fn.line("'\"") > 1) and (vim.fn.line("'\"") <= vim.fn.line("$"))) then
          return vim.cmd("normal! g'\"")
        end
      end
      _G._zest["autocmd"][ZEST_ID_0_] = _0_
      _G._zest["autocmd"]["#"] = (ZEST_N_0_ + 1)
      ZEST_VLUA_0_ = ("v:lua._zest.autocmd." .. ZEST_ID_0_)
    end
    vim.cmd(("autocmd BufReadPost * :call " .. ZEST_VLUA_0_ .. "()"))
  end
  vim.cmd("augroup END")
end
do
  vim.cmd("augroup flash-yank")
  vim.cmd("autocmd!")
  do
    local ZEST_VLUA_0_
    do
      local ZEST_N_0_ = _G._zest.autocmd["#"]
      local ZEST_ID_0_ = ("_" .. ZEST_N_0_)
      local function _0_()
        return vim.highlight.on_yank({higroup = "Search", timeout = 100})
      end
      _G._zest["autocmd"][ZEST_ID_0_] = _0_
      _G._zest["autocmd"]["#"] = (ZEST_N_0_ + 1)
      ZEST_VLUA_0_ = ("v:lua._zest.autocmd." .. ZEST_ID_0_)
    end
    vim.cmd(("autocmd TextYankPost * :call " .. ZEST_VLUA_0_ .. "()"))
  end
  vim.cmd("augroup END")
end
do
  vim.cmd("augroup split-settings")
  vim.cmd("autocmd!")
  do
    do
      local ZEST_VLUA_0_
      do
        local ZEST_N_0_ = _G._zest.autocmd["#"]
        local ZEST_ID_0_ = ("_" .. ZEST_N_0_)
        local function _0_()
          if (#vim.fn.tabpagebuflist() > 1) then
            return vim.api.nvim_command("wincmd =")
          end
        end
        _G._zest["autocmd"][ZEST_ID_0_] = _0_
        _G._zest["autocmd"]["#"] = (ZEST_N_0_ + 1)
        ZEST_VLUA_0_ = ("v:lua._zest.autocmd." .. ZEST_ID_0_)
      end
      vim.cmd(("autocmd VimResized * :call " .. ZEST_VLUA_0_ .. "()"))
    end
    vim.cmd("au FileType help wincmd L")
  end
  vim.cmd("augroup END")
end
do
  vim.cmd("augroup filetype-settings")
  vim.cmd("autocmd!")
  do
    vim.cmd("au FileType text,latex,markdown set wrap")
    local ZEST_VLUA_0_
    do
      local ZEST_N_0_ = _G._zest.autocmd["#"]
      local ZEST_ID_0_ = ("_" .. ZEST_N_0_)
      local function _0_()
        do end (vim.opt.iskeyword):remove(".")
        return (vim.opt.lispwords):append({"string.*", "table.*", "au.no-", "au.fn-", "au.gr-", "ki.no-", "ki.fn-"})
      end
      _G._zest["autocmd"][ZEST_ID_0_] = _0_
      _G._zest["autocmd"]["#"] = (ZEST_N_0_ + 1)
      ZEST_VLUA_0_ = ("v:lua._zest.autocmd." .. ZEST_ID_0_)
    end
    vim.cmd(("autocmd FileType fennel :call " .. ZEST_VLUA_0_ .. "()"))
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
do
  vim.cmd("augroup keyboard-switcher")
  vim.cmd("autocmd!")
  do
    do
      local ZEST_VLUA_0_
      do
        local ZEST_N_0_ = _G._zest.autocmd["#"]
        local ZEST_ID_0_ = ("_" .. ZEST_N_0_)
        local function _0_()
          if (xkbmap_insert.layout and (xkbmap_insert.layout ~= xkbmap_normal.layout)) then
            return set_xkbmap(xkbmap_insert)
          end
        end
        _G._zest["autocmd"][ZEST_ID_0_] = _0_
        _G._zest["autocmd"]["#"] = (ZEST_N_0_ + 1)
        ZEST_VLUA_0_ = ("v:lua._zest.autocmd." .. ZEST_ID_0_)
      end
      vim.cmd(("autocmd InsertEnter * :call " .. ZEST_VLUA_0_ .. "()"))
    end
    local ZEST_VLUA_0_
    do
      local ZEST_N_0_ = _G._zest.autocmd["#"]
      local ZEST_ID_0_ = ("_" .. ZEST_N_0_)
      local function _0_()
        xkbmap_insert = get_xkbmap()
        vim.g["_layout"] = xkbmap_insert.layout
        if (xkbmap_insert.layout ~= xkbmap_normal.layout) then
          return set_xkbmap(xkbmap_normal)
        end
      end
      _G._zest["autocmd"][ZEST_ID_0_] = _0_
      _G._zest["autocmd"]["#"] = (ZEST_N_0_ + 1)
      ZEST_VLUA_0_ = ("v:lua._zest.autocmd." .. ZEST_ID_0_)
    end
    vim.cmd(("autocmd InsertLeave * :call " .. ZEST_VLUA_0_ .. "()"))
  end
  vim.cmd("augroup END")
end
vim.cmd("augroup rake")
vim.cmd("autocmd!")
do
  vim.cmd("au BufWritePost /home/sean/.garden/etc/* silent!rake -u %:p")
end
return vim.cmd("augroup END")