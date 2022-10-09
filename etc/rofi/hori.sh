add() {
  link rofi_bk/config.rasi ~/.config/rofi/config.rasi
  link rofi_bk/common.rasi ~/.config/rofi/common.rasi
  link dmenu.rasi ~/.config/rofi/dmenu.rasi
  link scribe.rasi ~/.config/rofi/scribe.rasi
  link rofi_bk/vertical.rasi ~/.config/rofi/vertical.rasi
  link rofi_bk/horizontal.rasi ~/.config/rofi/horizontal.rasi
}

del() {
  unlink ~/.config/rofi/config.rasi
  unlink ~/.config/rofi/common.rasi
  unlink ~/.config/rofi/dmenu.rasi
  unlink ~/.config/rofi/scribe.rasi
  unlink ~/.config/rofi/vertical.rasi
  unlink ~/.config/rofi/horizontal.rasi
}
