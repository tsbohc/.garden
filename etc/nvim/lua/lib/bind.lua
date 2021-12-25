local M = { _n = 0 }

_bindtable = {}

function M.bind(kind, data)
  M._n = M._n + 1
  local id = '_' .. M._n
  if type(data.rhs) == 'function' then
    local vlua = 'v:lua._bindtable.' .. id .. '.fn'
    if kind == 'autocmd' then
      vlua = ':call ' .. vlua '()'
    elseif kind == 'keymap' then
      if data.opt.expr then
        vlua = vlua .. '()'
      else
        vlua = ':call ' .. vlua .. '()<cr>'
      end
    end
    data.fn = data.rhs
    data.rhs = vlua
  end
  _bindtable[id] = data
  return data
end

return M.bind
