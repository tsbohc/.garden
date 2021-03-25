```
.                                               /)                    
├── bin   - scripts                 _   _   __  _(/  _ __               
├── etc   - config               o (_/_(_(_/ (_(_(__(/_/ (_             
├── src   - sandbox               .-/                                   
└── tmp   - graveyard            (_/                                    
```
## nvim
<p align="center">
     <img src="https://user-images.githubusercontent.com/36731587/112466929-79432400-8d77-11eb-8920-be5e25683bb8.png">
     <a href="https://github.com/sainnhe/everforest"><code>everforest</code></a> × <code><a href="https://github.com/tonsky/FiraCode">fira code</a></code></p>

#### init.lua
Written in [fennel](https://github.com/bakpakin/Fennel/), a lisp that compiles lua, with the help of [aniseed](https://github.com/Olical/aniseed).

#### zest.fnl
An opinionated library with a primary aim of making nvim configuration feel at home in fennel. Takes advantage of `macros` to turn syntactic sugar into nvim's bultins at compile-time:
```lua
init.fnl                               init.lua

(se- scrolloff 10)                     vim.api.nvim_win_set_option(0, "scrolloff", 10)
(se- nowrap)                 -zest->   vim.api.nvim_win_set_option(0, "wrap", false)
(se- virtualedit "block")              vim.api.nvim_set_option("virtualedit", "block")
```
featuring key mapping to lua functions:
```lua
(k.nvo [expr] :k #(if (> vim.v.count 0) :k :gk))
(k.nvo [expr] :j #(if (> vim.v.count 0) :j :gj))
```
autocommands:
```lua
(au- [InsertLeave BufEnter FocusGained] *
     #(if (not= (vim.fn.mode) :i)
        (se- cursorline)))
```
and my event-based statusline:
```lua
(sl- [BufEnter BufWritePost] [0 0 1 1 :CursorLine]
     #(let [fname (vim.fn.expand "%:t")]
        (if (not= fname "")
          (.. "‹‹ " fname " ››")
          " ‹ new › ")))
```
Data is updated on specified events and cached, while the statusline function simply retrieves it.

## bspwm
WM of choice, made own with scripts based around `bspc subscribe`.

## soap
A bite-sized framework for managing .files with symlinks and hooks. There're plans for a rewrite and adding variable insertion.

## addendum
- I'm not a programmer by trade, but I like writing code. As such, it is very opinionated.
- Feel free to look around, fork, and praise or yell at me in an issue!
- Giving credit is appreciated.

Thanks!
