setup() {
  # if link toinit.lua doesn't exist, link the init lua there from config
  :
  #link "~/.cache/bayleaf/actual/init.lua" "~/.config/nvim/init.lua"
  #link "~/.cache/bayleaf/actual/lua" "~/.config/nvim/lua"
}

remove() {
  :
  #unlink "~/.config/nvim/init.lua"
  #unlink "~/.config/nvim/lua"
}
