setup() {
  link "autostart" "~/.config/herbstluftwm/autostart"
  herbstclient reload
}

remove() {
  unlink "~/.config/herbstluftwm/autostart"
}
