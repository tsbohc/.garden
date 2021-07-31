grow() {
  link "lua/init.lua" "~/.config/nvim/init.lua"
  link "lua/lua" "~/.config/nvim/lua"
}

weed() {
  unlink "~/.config/nvim/init.lua"
  unlink "~/.config/nvim/lua"
}
