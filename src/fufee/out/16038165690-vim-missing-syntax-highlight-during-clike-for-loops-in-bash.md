# Vim missing syntax highlight during C-like 'for' loops in Bash

3 | 1603816569.0

I'm a new Vim user and despite some setbacks I had with it...I'm pretty happy I've made the switch. One small thing that really bothers me is the fact that Vim misses C-like for loops in Bash. Here's a snippet of some of my code:

    for (( Opt = $lower_limit ; Opt &lt;= $upper_limit ; Opt++ )) ; do ....

Everything gets highlighted correctly **except** the keyword "for", which just remains white. What is even weirder is that this only happens if a given C-like for loop is **inside** a function. If I declare the same for loop outside of a function, everything gets highlighted correctly. I tried rearranging stuff like spaces when writing the for loop, but it didn't help.

I'm using [gruvbox](https://github.com/morhetz/gruvbox) on dark mode, which makes "for" keywords become dark-red...but that isn't the issue because the same thing happens with a built-in colorscheme (like peachpuff). Also, my vimrc file has only a few key mappings...nothing that could be breaking vim's syntax...and running `:syntax sync fromstart` doesn't fix this issue.

Anyway...has anybody experienced this before? Any guesses?