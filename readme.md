```
   ____    ___      __     _____
  /',__\  / __'\  /'__'\  /\ '__'\
 /\__, '\/\ \L\ \/\ \L\.\_\ \ \L\ \
 \/\____/\ \____/\ \__/.\_\  \ ,__/
  \/___/  \/___/  \/__/\/_/ \ \ \/
                             \ \_\
                              \/_/
perform:
   i, install     perform installation
   d, dry         just print without running
   u, update      sync to or from a git repo
   e, edit        fzf into $EDITOR in the script location
                  runs when no arguments are given

install:
  -p, --packages  install package bundles
  -v, --vim       set up nvim via plug
```

# about
soap is the third rewrite of my personal config bootstrap script. it was designed to be a learning project and a way to reality check my current level of bash. it's been with me since day one of using linux

soap reads simple instructions from the top of the file and takes care of the rest. currently it has no extra dependencies (though fzf is advisable) and is able to

- symlink and be kinda smart about it
- set up nvim and plug
- install arch and pip packages
- sync itself to and from the repo
- log pretty things w/ exit statuses and partial live command output

# lantern
is an app launcher/file browser, that indexes ~/ and strives to provide relevant suggestions by tracking and balancing frequency of use. when adding new entries, lantern assigns tags by guessing the best way to act on a file. any entry can be "tabbed" on to show a list of actions. lantern can be launched in an existing terminal or spawn itself in a new window.

powered by fzf, inspired by quicksilver

# .files
the general spirit of this repo is finding the balance between doing it yourself, striving for minimalism, and not overdoing it too much

### present
- bspwm and lemonbar
- vim statusline that pulls colors from xrdb -query

### past
- i3 and polybar

### future
- add a $DOTS global path already
- music

my bash is bashfully bad, but i'm having fun
