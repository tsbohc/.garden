#
#    _/_ /
#  o /  /_  __  _  _ 
# <_<__/ /_/ (_</_</_
#

font pango:Tamzen 14px
set $mod Mod4

# -------------------------------------------
# window style
# -------------------------------------------

# class                         border   bg       text     indic    child_border
client.focused                  #00ff00  #151515  #ffffff  #101010  #101010
client.focused_inactive         #101010  #151515  #ffffff  #101010  #101010
client.unfocused                #101010  #151515  #888888  #101010  #101010
client.urgent                   #2f343a  #900000  #ffffff  #101010  #900000
client.placeholder              #101010  #151515  #ffffff  #101010  #101010
client.background               #151515

# remove window titles
new_window pixel 1

#i3-gaps
gaps inner 7
smart_gaps on

# -------------------------------------------
# keybindings
# -------------------------------------------

# apps
bindsym $mod+Return             exec ~/blueberry/sl/st/st #i3-sensible-terminal
bindsym $mod+d                  exec rofi -show run
bindcode Shift+64               exec /home/sean/blueberry/sc/keyboardswitch.sh

# media keys
bindsym XF86MonBrightnessUp     exec xbacklight -inc 10
bindsym XF86MonBrightnessDown   exec xbacklight -set 1
bindsym XF86AudioRaiseVolume    exec pactl -- set-sink-volume 0 +10%
bindsym XF86AudioLowerVolume    exec pactl -- set-sink-volume 0 -10%

# i3 specific
bindsym $mod+Shift+c            reload
bindsym $mod+Shift+r            restart
bindsym $mod+Shift+e            exec "i3-nagbar -t warning -m 'are you sure you want to terminate X?' -B 'yes, terminate' 'i3-msg exit'"

# -------------------------------------------
# window management
# -------------------------------------------

bindsym $mod+Shift+q            kill
floating_modifier               $mod

bindsym $mod+h focus            left
bindsym $mod+j focus            down
bindsym $mod+k focus            up
bindsym $mod+l focus            right

bindsym $mod+Shift+h            move left
bindsym $mod+Shift+j            move down
bindsym $mod+Shift+k            move up
bindsym $mod+Shift+l            move right

bindsym $mod+b                  split h
bindsym $mod+v                  split v

bindsym $mod+f                  fullscreen toggle
bindsym $mod+Shift+space        floating toggle

bindsym $mod+s                  layout stacking
bindsym $mod+w                  layout tabbed
bindsym $mod+e                  layout toggle split

# change focus between tiling / floating windows
#bindsym $mod+space focus mode_toggle

# focus the parent container
#bindsym $mod+a focus parent

# focus the child container
#bindsym $mod+d focus child

# -------------------------------------------
# modes
# -------------------------------------------

# could probably add mode modes :O

bindsym $mod+r mode "resize"

mode "resize" {
        bindsym l               resize shrink width 10 px or 10 ppt
        bindsym k               resize grow height 10 px or 10 ppt
        bindsym j               resize shrink height 10 px or 10 ppt
        bindsym h               resize grow width 10 px or 10 ppt

        bindsym Return          mode "default"
        bindsym Escape          mode "default"
        bindsym $mod+r          mode "default"
}

# -------------------------------------------
# workspaces
# -------------------------------------------

set $ws1 "1"
set $ws2 "2"
set $ws3 "3"
set $ws4 "4"
set $ws5 "5"
set $ws6 "6"
set $ws7 "7"
set $ws8 "8"
set $ws9 "9"

bindsym $mod+1                  workspace $ws1
bindsym $mod+2                  workspace $ws2
bindsym $mod+3                  workspace $ws3
bindsym $mod+4                  workspace $ws4
bindsym $mod+5                  workspace $ws5
bindsym $mod+6                  workspace $ws6
bindsym $mod+7                  workspace $ws7
bindsym $mod+8                  workspace $ws8
bindsym $mod+9                  workspace $ws9

bindsym $mod+Shift+1            move container to workspace $ws1
bindsym $mod+Shift+2            move container to workspace $ws2
bindsym $mod+Shift+3            move container to workspace $ws3
bindsym $mod+Shift+4            move container to workspace $ws4
bindsym $mod+Shift+5            move container to workspace $ws5
bindsym $mod+Shift+6            move container to workspace $ws6
bindsym $mod+Shift+7            move container to workspace $ws7
bindsym $mod+Shift+8            move container to workspace $ws8
bindsym $mod+Shift+9            move container to workspace $ws9

# -------------------------------------------
# i3bar
# -------------------------------------------

#bar {
#        status_command i3status
#}

# -------------------------------------------
# scripts
# -------------------------------------------

exec_always --no-startup-id ~/blueberry/sc/altlayi3
