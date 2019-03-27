xrdb ~/.Xresources
feh --bg-fill ~/Pictures/wallpaper
xinput set-prop 11 281 1
xmodmap -e "clear Lock"
xmodmap -e "keycode 66 = Escape NoSymbol Escape"
compton --config ~/.config/compton.conf &
nmcli d connect wlp2s0
polybar top &
i3
