```
       _                              
  /   //         /                    
 /__ //  . . _  /__ _  __  __  __  ,  
/_) </_ (_/_</_/_) </_/ (_/ (_/ (_/_ ❤
                                 /    
                                '
```
new machine bootstrap script, featuring: symlinks, aur bundles, nvim plugs, and more. single file with no extra dependencies 

## about
- bashrc:
    - simple git aware prompt
    - tty colors are read from .Xresources
    - cancellable xorg autostart
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
    - skywind3000/z.lua
    - junegunn/fzf
    - keyboard layout switcher
    - tinyfetch
- aliases:
    - archive extraction

## usage
```
perform:
   i, install     perform installation
   d, dry         just print without running includes all options
   u, update      sync to or from a git repo
   e, edit        fzf into $EDITOR in the script location
                  runs when no arguments are given

install:
  -p, --packages  install package bundles
  -v, --vim       set up nvim via plug
```

## todo
- add firefox theme
- add a cool gif
- look into tldr pages and explain shell

crafted with love
