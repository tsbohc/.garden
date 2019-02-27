xrdb ~/.Xresources
feh --bg-fill /home/sean/Pictures/wallpaper.png
xinput set-prop 11 281 1
xmodmap -e "clear Lock"
xmodmap -e "keycode 66 = Escape NoSymbol Escape"
nmcli d connect wlp2s0
compton --config /home/sean/.config/compton.conf &
polybar top &
i3
