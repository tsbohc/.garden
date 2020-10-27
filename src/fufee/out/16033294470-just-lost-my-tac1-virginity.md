# Just lost my tac(1) virginity

25 | 1603329447.0


    pstree -U | sed "y/└┬/┌┴/" | tac

I was doing some serious business in the shell (above) when this happened: I needed to output my stdout in reverse, friends.

Well, I started doing some `man`s work, ya know. `man sort`, then `man shuf`. Hell, I've even thought there was a `cat` flag for this.

There wasn't. But at the very bottom of the `cat` man page I found this.

    SEE ALSO
       tac(1)

And here we are.
A pure gem.