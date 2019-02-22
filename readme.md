```
       _                              
  /   //         /                    
 /__ //  . . _  /__ _  __  __  __  ,  
/_) </_ (_/_</_/_) </_/ (_/ (_/ (_/_ ❤
                                 /    
```

~/ is where the &lt;3 is

## todo

- rewrite echos to simply return strings and redo output into print({arg} woo) etc
- add a command that pushes an alias into bashrc
- retroarch configs
- redo folder creation to allow reap to do that
- switch dict menu
- add firefox theme

## config.json

```js
{
    "mkdir": [
        "~/downloads",
        "~/pictures",
        "~/projects"
    ],

    "link": {
        ".bashrc": "~/.bashrc",
        ".bash_profile": "~/.bash_profile",
        ".xinitrc": "~/.xinitrc",
        ".Xresources": "~/.Xresources",
        ".vimrc": "~/.vimrc",

        "neofetch/config.conf": "~/.config/neofetch/config.conf",
        "neofetch/punpun": "~/.config/neofetch/punpun",

        ".i3": "~/.config/i3/config",
        "compton.conf": "~/.config/compton.conf",
        "polybar": "~/.config/polybar/config"
    },

    "run": [
        "echo 'woo'"
    ]
}
```
