setup() {
  :
  #link "~/.cache/bayleaf/actual/init.lua" "~/.config/nvim/init.lua"
  #link "~/.cache/bayleaf/actual/lua" "~/.config/nvim/lua"
}

remove() {
  :
  #unlink "~/.config/nvim/init.lua"
  #unlink "~/.config/nvim/lua"
}
