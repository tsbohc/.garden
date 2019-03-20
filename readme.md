```
       _                              
  /   //         /                    
 /__ //  . . _  /__ _  __  __  __  ,  
/_) </_ (_/_</_/_) </_/ (_/ (_/ (_/_ ❤
                                 /    
                                '
usage: blueberry [install | update | dry] [-p] [-v]

perform:
   i, install     perform installation
   u, update      sync to or from a git repo
   d, dry         just print without running
                  default, includes all options
install:
  -p, --packages  install package bundles
  -v, --vim       set up nvim via plug
```
new machine bootstrap script, featuring: symlinks, aur bundles, nvim plugs, and more, all a couple of keystrokes away. single file with no extra dependencies. 

## about
- bashrc:
    - simple git aware prompt
    - tty colors are read from .Xresources
    - cancellable xorg autostart
- aliases:
    - archive extraction
- nvim: 
    - nanotech/jellybeans.vim
    - valloric/youcompleteme
    - itchyny/lightline
    - terryma/vim-multiple-cursors
- st: 
    - scrollback
    - boxdraw
- i3: 
    - gaps
    - olemartinorg/i3-alternating-layout
- scripts:
    - keyboard layout switcher
    - tinyfetch
- tools:
    - skywind3000/z.lua

## todo
- add firefox theme
- add a cool gif
- look into tldr pages and explain shell

crafted with love
