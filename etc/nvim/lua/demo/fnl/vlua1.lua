local v
do
  local ZEST_N_0_ = _G._zest.v["#"]
  local ZEST_ID_0_ = ("_" .. ZEST_N_0_)
  _G._zest["v"][ZEST_ID_0_] = my_fn
  _G._zest["v"]["#"] = (ZEST_N_0_ + 1)
  v = ("v:lua._zest.v." .. ZEST_ID_0_)
end
return 42