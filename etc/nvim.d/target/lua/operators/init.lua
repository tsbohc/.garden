local function commentary(do_3f, s, t)
  local x, y = (vim.bo.commentstring):match("(.-)%s+(.-)")
  local do_comment
  local function _0_(l)
    if ("\n" ~= l) then
      return (x .. " " .. l)
    end
  end
  do_comment = _0_
  local un_comment
  local function _1_(l)
    return l:gsub(("^(%" .. x .. "%s?)"), "")
  end
  un_comment = _1_
  local function _2_()
    if do_3f then
      return do_comment
    else
      return un_comment
    end
  end
  return s:gsub("(.-\n)", _2_())
end
do
  local VLUA_0_
  do
    local ZEST_ID_0_ = "_60_108_101_97_100_101_114_62_99_99_"
    local function _0_(KIND_0_)
      local REG_0_ = vim.api.nvim_eval("@@")
      local REG_TYPE_0_ = vim.fn.getregtype("@@")
      local SELECTION_0_ = vim.opt.selection
      local CLIPBOARD_0_ = vim.opt.clipboard
      local KIND_0_0
      if tonumber(KIND_0_) then
        KIND_0_0 = "count"
      else
        KIND_0_0 = KIND_0_
      end
      local C_V_0_ = vim.api.nvim_replace_termcodes("<c-v>", true, true, true)
      vim.opt["selection"] = "inclusive"
      do end (vim.opt.clipboard):remove("unnamed")
      do end (vim.opt.clipboard):remove("unnamedplus")
      local INPUT_REG_TYPE_0_ = ""
      do
        local _2_ = KIND_0_0
        if (_2_ == "count") then
          vim.api.nvim_command(("norm! V" .. vim.v.count1 .. "$y"))
          INPUT_REG_TYPE_0_ = "l"
        elseif (_2_ == "V") then
          vim.api.nvim_command("norm! gvy")
          INPUT_REG_TYPE_0_ = "l"
        elseif (_2_ == C_V_0_) then
          vim.api.nvim_command("norm! gvy")
          INPUT_REG_TYPE_0_ = "b"
        elseif (_2_ == "v") then
          vim.api.nvim_command("norm! gvy")
          INPUT_REG_TYPE_0_ = "c"
        elseif (_2_ == "line") then
          vim.api.nvim_command("norm! `[V`]y")
          INPUT_REG_TYPE_0_ = "l"
        elseif (_2_ == "block") then
          vim.api.nvim_command("norm! `[<c-v>`]y")
          INPUT_REG_TYPE_0_ = "b"
        elseif (_2_ == "char") then
          vim.api.nvim_command("norm! `[v`]y")
          INPUT_REG_TYPE_0_ = "c"
        end
      end
      local INPUT_0_ = vim.api.nvim_eval("@@")
      local OUTPUT_0_
      local function _3_(...)
        return commentary(true, ...)
      end
      OUTPUT_0_ = _3_(INPUT_0_, KIND_0_0)
      if OUTPUT_0_ then
        vim.fn.setreg("@", OUTPUT_0_, INPUT_REG_TYPE_0_)
        vim.api.nvim_command("norm! gvp")
      end
      vim.fn.setreg("@@", REG_0_, REG_TYPE_0_)
      vim.opt["selection"] = SELECTION_0_
      vim.opt["clipboard"] = CLIPBOARD_0_
      return nil
    end
    _G._zest["operator"][ZEST_ID_0_] = _0_
    VLUA_0_ = ("v:lua._zest.operator." .. ZEST_ID_0_)
  end
  local RHS_TEXTOBJECT_0_ = (":set operatorfunc=" .. VLUA_0_ .. "<cr>g@")
  local RHS_VISUAL_0_ = (":<c-u>call " .. VLUA_0_ .. "(visualmode())<cr>")
  local LHS_DOUBLE_0_ = ("<leader>cc" .. string.sub("<leader>cc", -1))
  local RHS_DOUBLE_0_ = (":<c-u>call " .. VLUA_0_ .. "(v:count1)<cr>")
  vim.api.nvim_set_keymap("n", "<leader>cc", RHS_TEXTOBJECT_0_, {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", LHS_DOUBLE_0_, RHS_DOUBLE_0_, {noremap = true, silent = true})
  vim.api.nvim_set_keymap("v", "<leader>cc", RHS_VISUAL_0_, {noremap = true, silent = true})
end
do
  local VLUA_0_
  do
    local ZEST_ID_0_ = "_60_108_101_97_100_101_114_62_99_117_"
    local function _0_(KIND_0_)
      local REG_0_ = vim.api.nvim_eval("@@")
      local REG_TYPE_0_ = vim.fn.getregtype("@@")
      local SELECTION_0_ = vim.opt.selection
      local CLIPBOARD_0_ = vim.opt.clipboard
      local KIND_0_0
      if tonumber(KIND_0_) then
        KIND_0_0 = "count"
      else
        KIND_0_0 = KIND_0_
      end
      local C_V_0_ = vim.api.nvim_replace_termcodes("<c-v>", true, true, true)
      vim.opt["selection"] = "inclusive"
      do end (vim.opt.clipboard):remove("unnamed")
      do end (vim.opt.clipboard):remove("unnamedplus")
      local INPUT_REG_TYPE_0_ = ""
      do
        local _2_ = KIND_0_0
        if (_2_ == "count") then
          vim.api.nvim_command(("norm! V" .. vim.v.count1 .. "$y"))
          INPUT_REG_TYPE_0_ = "l"
        elseif (_2_ == "V") then
          vim.api.nvim_command("norm! gvy")
          INPUT_REG_TYPE_0_ = "l"
        elseif (_2_ == C_V_0_) then
          vim.api.nvim_command("norm! gvy")
          INPUT_REG_TYPE_0_ = "b"
        elseif (_2_ == "v") then
          vim.api.nvim_command("norm! gvy")
          INPUT_REG_TYPE_0_ = "c"
        elseif (_2_ == "line") then
          vim.api.nvim_command("norm! `[V`]y")
          INPUT_REG_TYPE_0_ = "l"
        elseif (_2_ == "block") then
          vim.api.nvim_command("norm! `[<c-v>`]y")
          INPUT_REG_TYPE_0_ = "b"
        elseif (_2_ == "char") then
          vim.api.nvim_command("norm! `[v`]y")
          INPUT_REG_TYPE_0_ = "c"
        end
      end
      local INPUT_0_ = vim.api.nvim_eval("@@")
      local OUTPUT_0_
      local function _3_(...)
        return commentary(false, ...)
      end
      OUTPUT_0_ = _3_(INPUT_0_, KIND_0_0)
      if OUTPUT_0_ then
        vim.fn.setreg("@", OUTPUT_0_, INPUT_REG_TYPE_0_)
        vim.api.nvim_command("norm! gvp")
      end
      vim.fn.setreg("@@", REG_0_, REG_TYPE_0_)
      vim.opt["selection"] = SELECTION_0_
      vim.opt["clipboard"] = CLIPBOARD_0_
      return nil
    end
    _G._zest["operator"][ZEST_ID_0_] = _0_
    VLUA_0_ = ("v:lua._zest.operator." .. ZEST_ID_0_)
  end
  local RHS_TEXTOBJECT_0_ = (":set operatorfunc=" .. VLUA_0_ .. "<cr>g@")
  local RHS_VISUAL_0_ = (":<c-u>call " .. VLUA_0_ .. "(visualmode())<cr>")
  local LHS_DOUBLE_0_ = ("<leader>cu" .. string.sub("<leader>cu", -1))
  local RHS_DOUBLE_0_ = (":<c-u>call " .. VLUA_0_ .. "(v:count1)<cr>")
  vim.api.nvim_set_keymap("n", "<leader>cu", RHS_TEXTOBJECT_0_, {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", LHS_DOUBLE_0_, RHS_DOUBLE_0_, {noremap = true, silent = true})
  vim.api.nvim_set_keymap("v", "<leader>cu", RHS_VISUAL_0_, {noremap = true, silent = true})
end
local function surround(s)
  local c = vim.fn.nr2char(vim.fn.getchar())
  local _0_ = c
  if (_0_ == "\"") then
    return ("\"" .. s .. "\"")
  elseif (_0_ == "'") then
    return ("'" .. s .. "'")
  elseif (_0_ == "(") then
    return ("( " .. s .. " )")
  elseif (_0_ == ")") then
    return ("(" .. s .. ")")
  elseif (_0_ == "[") then
    return ("[ " .. s .. " ]")
  elseif (_0_ == "]") then
    return ("[" .. s .. "]")
  elseif (_0_ == "{") then
    return ("{ " .. s .. " }")
  elseif (_0_ == "}") then
    return ("{" .. s .. "}")
  elseif (_0_ == "<") then
    return ("< " .. s .. " >")
  elseif (_0_ == ">") then
    return ("<" .. s .. ">")
  end
end
local VLUA_0_
do
  local ZEST_ID_0_ = "_115_"
  local function _0_(KIND_0_)
    local REG_0_ = vim.api.nvim_eval("@@")
    local REG_TYPE_0_ = vim.fn.getregtype("@@")
    local SELECTION_0_ = vim.opt.selection
    local CLIPBOARD_0_ = vim.opt.clipboard
    local KIND_0_0
    if tonumber(KIND_0_) then
      KIND_0_0 = "count"
    else
      KIND_0_0 = KIND_0_
    end
    local C_V_0_ = vim.api.nvim_replace_termcodes("<c-v>", true, true, true)
    vim.opt["selection"] = "inclusive"
    do end (vim.opt.clipboard):remove("unnamed")
    do end (vim.opt.clipboard):remove("unnamedplus")
    local INPUT_REG_TYPE_0_ = ""
    do
      local _2_ = KIND_0_0
      if (_2_ == "count") then
        vim.api.nvim_command(("norm! V" .. vim.v.count1 .. "$y"))
        INPUT_REG_TYPE_0_ = "l"
      elseif (_2_ == "V") then
        vim.api.nvim_command("norm! gvy")
        INPUT_REG_TYPE_0_ = "l"
      elseif (_2_ == C_V_0_) then
        vim.api.nvim_command("norm! gvy")
        INPUT_REG_TYPE_0_ = "b"
      elseif (_2_ == "v") then
        vim.api.nvim_command("norm! gvy")
        INPUT_REG_TYPE_0_ = "c"
      elseif (_2_ == "line") then
        vim.api.nvim_command("norm! `[V`]y")
        INPUT_REG_TYPE_0_ = "l"
      elseif (_2_ == "block") then
        vim.api.nvim_command("norm! `[<c-v>`]y")
        INPUT_REG_TYPE_0_ = "b"
      elseif (_2_ == "char") then
        vim.api.nvim_command("norm! `[v`]y")
        INPUT_REG_TYPE_0_ = "c"
      end
    end
    local INPUT_0_ = vim.api.nvim_eval("@@")
    local OUTPUT_0_ = surround(INPUT_0_, KIND_0_0)
    if OUTPUT_0_ then
      vim.fn.setreg("@", OUTPUT_0_, INPUT_REG_TYPE_0_)
      vim.api.nvim_command("norm! gvp")
    end
    vim.fn.setreg("@@", REG_0_, REG_TYPE_0_)
    vim.opt["selection"] = SELECTION_0_
    vim.opt["clipboard"] = CLIPBOARD_0_
    return nil
  end
  _G._zest["operator"][ZEST_ID_0_] = _0_
  VLUA_0_ = ("v:lua._zest.operator." .. ZEST_ID_0_)
end
local RHS_TEXTOBJECT_0_ = (":set operatorfunc=" .. VLUA_0_ .. "<cr>g@")
local RHS_VISUAL_0_ = (":<c-u>call " .. VLUA_0_ .. "(visualmode())<cr>")
local LHS_DOUBLE_0_ = ("s" .. string.sub("s", -1))
local RHS_DOUBLE_0_ = (":<c-u>call " .. VLUA_0_ .. "(v:count1)<cr>")
vim.api.nvim_set_keymap("n", "s", RHS_TEXTOBJECT_0_, {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", LHS_DOUBLE_0_, RHS_DOUBLE_0_, {noremap = true, silent = true})
return vim.api.nvim_set_keymap("v", "s", RHS_VISUAL_0_, {noremap = true, silent = true})