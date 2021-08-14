do
  -- zest.def-autocmd-fn
  local zest_idx_0_
  do
    local zest_len_0_ = _G.zest["#"]
    local zest_idx_1_ = ("_" .. zest_len_0_)
    _G.zest["#"] = (zest_len_0_ + 1)
    zest_idx_0_ = zest_idx_1_
  end
  local zest_eve_0_ = "foo"
  local zest_pat_0_ = "*"
  local zest_rhs_0_ = (":call v:lua.zest.autocmd." .. zest_idx_0_ .. "()")
  _G.zest.autocmd[zest_idx_0_] = My_dinosaur_function
  vim.cmd(("autocmd " .. zest_eve_0_ .. " " .. zest_pat_0_ .. " " .. zest_rhs_0_))
end
return 42