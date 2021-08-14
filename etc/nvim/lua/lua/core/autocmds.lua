do
  vim.cmd("augroup smart-cursorline")
  vim.cmd("autocmd!")
  do
    do
      -- zest.def-autocmd-fn
      local zest_idx_0_
      do
        local zest_len_0_ = _G.zest["#"]
        local zest_idx_1_ = ("_" .. zest_len_0_)
        _G.zest["#"] = (zest_len_0_ + 1)
        zest_idx_0_ = zest_idx_1_
      end
      local zest_eve_0_ = "InsertEnter,BufLeave,FocusLost"
      local zest_pat_0_ = "*"
      local zest_rhs_0_ = (":call v:lua.zest.autocmd." .. zest_idx_0_ .. "()")
      local function _0_()
        vim.opt.cursorline = false
        return nil
      end
      _G.zest.autocmd[zest_idx_0_] = _0_
      vim.cmd(("autocmd " .. zest_eve_0_ .. " " .. zest_pat_0_ .. " " .. zest_rhs_0_))
    end
    -- zest.def-autocmd-fn
    local zest_idx_2_
    do
      local zest_len_1_ = _G.zest["#"]
      local zest_idx_3_ = ("_" .. zest_len_1_)
      _G.zest["#"] = (zest_len_1_ + 1)
      zest_idx_2_ = zest_idx_3_
    end
    local zest_eve_1_ = "InsertLeave,BufEnter,FocusGained"
    local zest_pat_1_ = "*"
    local zest_rhs_1_ = (":call v:lua.zest.autocmd." .. zest_idx_2_ .. "()")
    local function _0_()
      if (vim.fn.mode() ~= "i") then
        vim.opt.cursorline = true
        return nil
      end
    end
    _G.zest.autocmd[zest_idx_2_] = _0_
    vim.cmd(("autocmd " .. zest_eve_1_ .. " " .. zest_pat_1_ .. " " .. zest_rhs_1_))
  end
  vim.cmd("augroup END")
end
do
  vim.cmd("augroup restore-position")
  vim.cmd("autocmd!")
  do
    -- zest.def-autocmd-fn
    local zest_idx_0_
    do
      local zest_len_0_ = _G.zest["#"]
      local zest_idx_1_ = ("_" .. zest_len_0_)
      _G.zest["#"] = (zest_len_0_ + 1)
      zest_idx_0_ = zest_idx_1_
    end
    local zest_eve_0_ = "BufReadPost"
    local zest_pat_0_ = "*"
    local zest_rhs_0_ = (":call v:lua.zest.autocmd." .. zest_idx_0_ .. "()")
    local function _0_()
      if ((vim.fn.line("'\"") > 1) and (vim.fn.line("'\"") <= vim.fn.line("$"))) then
        return vim.cmd("normal! g'\"")
      end
    end
    _G.zest.autocmd[zest_idx_0_] = _0_
    vim.cmd(("autocmd " .. zest_eve_0_ .. " " .. zest_pat_0_ .. " " .. zest_rhs_0_))
  end
  vim.cmd("augroup END")
end
do
  vim.cmd("augroup flash-yank")
  vim.cmd("autocmd!")
  do
    -- zest.def-autocmd-fn
    local zest_idx_0_
    do
      local zest_len_0_ = _G.zest["#"]
      local zest_idx_1_ = ("_" .. zest_len_0_)
      _G.zest["#"] = (zest_len_0_ + 1)
      zest_idx_0_ = zest_idx_1_
    end
    local zest_eve_0_ = "TextYankPost"
    local zest_pat_0_ = "*"
    local zest_rhs_0_ = (":call v:lua.zest.autocmd." .. zest_idx_0_ .. "()")
    local function _0_()
      return vim.highlight.on_yank({higroup = "Search", timeout = 100})
    end
    _G.zest.autocmd[zest_idx_0_] = _0_
    vim.cmd(("autocmd " .. zest_eve_0_ .. " " .. zest_pat_0_ .. " " .. zest_rhs_0_))
  end
  vim.cmd("augroup END")
end
do
  vim.cmd("augroup split-settings")
  vim.cmd("autocmd!")
  do
    do
      -- zest.def-autocmd-fn
      local zest_idx_0_
      do
        local zest_len_0_ = _G.zest["#"]
        local zest_idx_1_ = ("_" .. zest_len_0_)
        _G.zest["#"] = (zest_len_0_ + 1)
        zest_idx_0_ = zest_idx_1_
      end
      local zest_eve_0_ = "VimResized"
      local zest_pat_0_ = "*"
      local zest_rhs_0_ = (":call v:lua.zest.autocmd." .. zest_idx_0_ .. "()")
      local function _0_()
        if (#vim.fn.tabpagebuflist() > 1) then
          return vim.api.nvim_command("wincmd =")
        end
      end
      _G.zest.autocmd[zest_idx_0_] = _0_
      vim.cmd(("autocmd " .. zest_eve_0_ .. " " .. zest_pat_0_ .. " " .. zest_rhs_0_))
    end
    -- zest.def-autocmd-string
    local zest_eve_1_ = "FileType"
    local zest_pat_1_ = "help"
    local zest_rhs_1_ = "wincmd L"
    vim.cmd(("autocmd " .. zest_eve_1_ .. " " .. zest_pat_1_ .. " " .. zest_rhs_1_))
  end
  vim.cmd("augroup END")
end
do
  vim.cmd("augroup filetype-settings")
  vim.cmd("autocmd!")
  do
    do
      -- zest.def-autocmd-string
      local zest_eve_0_ = "FileType"
      local zest_pat_0_ = "text,latex,markdown"
      local zest_rhs_0_ = "set wrap"
      vim.cmd(("autocmd " .. zest_eve_0_ .. " " .. zest_pat_0_ .. " " .. zest_rhs_0_))
    end
    -- zest.def-autocmd-fn
    local zest_idx_0_
    do
      local zest_len_0_ = _G.zest["#"]
      local zest_idx_1_ = ("_" .. zest_len_0_)
      _G.zest["#"] = (zest_len_0_ + 1)
      zest_idx_0_ = zest_idx_1_
    end
    local zest_eve_1_ = "FileType"
    local zest_pat_1_ = "fennel"
    local zest_rhs_1_ = (":call v:lua.zest.autocmd." .. zest_idx_0_ .. "()")
    local function _0_()
      do end (vim.opt.iskeyword):remove(".")
      return (vim.opt.lispwords):append({"string.*", "table.*", "au-", "gr-", "se-", "ki-"})
    end
    _G.zest.autocmd[zest_idx_0_] = _0_
    vim.cmd(("autocmd " .. zest_eve_1_ .. " " .. zest_pat_1_ .. " " .. zest_rhs_1_))
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
      -- zest.def-autocmd-fn
      local zest_idx_0_
      do
        local zest_len_0_ = _G.zest["#"]
        local zest_idx_1_ = ("_" .. zest_len_0_)
        _G.zest["#"] = (zest_len_0_ + 1)
        zest_idx_0_ = zest_idx_1_
      end
      local zest_eve_0_ = "InsertEnter"
      local zest_pat_0_ = "*"
      local zest_rhs_0_ = (":call v:lua.zest.autocmd." .. zest_idx_0_ .. "()")
      local function _0_()
        if (xkbmap_insert.layout and (xkbmap_insert.layout ~= xkbmap_normal.layout)) then
          return set_xkbmap(xkbmap_insert)
        end
      end
      _G.zest.autocmd[zest_idx_0_] = _0_
      vim.cmd(("autocmd " .. zest_eve_0_ .. " " .. zest_pat_0_ .. " " .. zest_rhs_0_))
    end
    -- zest.def-autocmd-fn
    local zest_idx_2_
    do
      local zest_len_1_ = _G.zest["#"]
      local zest_idx_3_ = ("_" .. zest_len_1_)
      _G.zest["#"] = (zest_len_1_ + 1)
      zest_idx_2_ = zest_idx_3_
    end
    local zest_eve_1_ = "InsertLeave"
    local zest_pat_1_ = "*"
    local zest_rhs_1_ = (":call v:lua.zest.autocmd." .. zest_idx_2_ .. "()")
    local function _0_()
      xkbmap_insert = get_xkbmap()
      vim.g["_layout"] = xkbmap_insert.layout
      if (xkbmap_insert.layout ~= xkbmap_normal.layout) then
        return set_xkbmap(xkbmap_normal)
      end
    end
    _G.zest.autocmd[zest_idx_2_] = _0_
    vim.cmd(("autocmd " .. zest_eve_1_ .. " " .. zest_pat_1_ .. " " .. zest_rhs_1_))
  end
  vim.cmd("augroup END")
end
vim.cmd("augroup bayleaf")
vim.cmd("autocmd!")
do
  -- zest.def-autocmd-string
  local zest_eve_0_ = "BufWritePost"
  local zest_pat_0_ = "/home/sean/.garden/etc/nvim/fnl/*.fnl"
  local zest_rhs_0_ = ":silent !bayleaf %:p"
  vim.cmd(("autocmd " .. zest_eve_0_ .. " " .. zest_pat_0_ .. " " .. zest_rhs_0_))
end
return vim.cmd("augroup END")