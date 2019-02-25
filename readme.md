```
       _                              
  /   //         /                    
 /__ //  . . _  /__ _  __  __  __  ,  
/_) </_ (_/_</_/_) </_/ (_/ (_/ (_/_ ❤
                                 /    
```
~/ is where the &lt;3 is

## about

- symlinks everything, creating dirs as needed; asks to back up non-symlinks it stumbles across
- has a dry install option
- installs yay from git, uses it to get packages
- can reap dots, cloning config files into the repo
- shows when local branch has diffs, is able to pull/push changes 
- my first python project, loosely based on vibhavp/dotty

## todo

- add the ability to install only a single dotfile
- push an alias into bashrc
- retroarch configs
- redo folder creation to allow reap to do that
- switch dict menu
- add firefox theme
- add a cool gif

## config.json

```js
{
    "mkdir": [
        "~/downloads",
        "~/pictures",
        "~/projects"
    ],

    "link": {
        "bashrc": "~/.bashrc",
        "bash_profile": "~/.bash_profile",
        "xinitrc": "~/.xinitrc",
        "Xresources": "~/.Xresources",
        "vimrc": "~/.vimrc",
        "vim/colors/jellybeans.vim": "~/.vim/colors/jellybeans.vim",

        "neofetch/neofetch.conf": "~/.config/neofetch/config.conf",
        "neofetch/punpun": "~/.config/neofetch/punpun",

        "i3": "~/.config/i3/config",
        "compton": "~/.config/compton.conf",
        "polybar": "~/.config/polybar/config"
    },

    "install": [
        "nitrogen"
    ],

    "run": [
        "echo 'woo'"
    ]
}
```
