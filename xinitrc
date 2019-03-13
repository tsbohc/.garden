xrdb ~/.Xresources
feh --bg-fill ~/Pictures/wallpaper.png
polybar top &
xinput set-prop 11 280 1
xmodmap -e "clear Lock"
modmap -e "keycode 66 = Escape NoSymbol Escape"
compton --config ~/.config/compton.conf &
nmcli d connect wlp2s0
i3
