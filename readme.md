```
.                                            /)                    
├── bin - scripts              _   _   __  _(/  _ __               
├── etc - config            o (_/_(_(_/ (_(_(__(/_/ (_             
├── src - sandbox            .-/                                   
└── tmp - graveyard         (_/                                    
```
## nvim
#### init.lua
Written in [fennel](https://github.com/bakpakin/Fennel/), a lisp that compiles lua, with the help of [aniseed](https://github.com/Olical/aniseed).

#### zest.fnl
A library with a primary goal of making nvim configuration feel first class in fennel.  Takes advantage of `macros` to turn syntactic sugar into nvim's bultins at compile-time:
```lua
init.fnl                                init.lua

(se- scrolloff 10)                      vim.api.nvim_win_set_option(0, "scrolloff", 10)
(se- nowrap)                -zest->     vim.api.nvim_win_set_option(0, "wrap", false)
(se- virtualedit block)                 vim.api.nvim_set_option("virtualedit", "block")
```

and so on:

```lua
(k.nvo [expr] :j #(if (> vim.v.count 0) :j :gj))

(au- [InsertLeave BufEnter FocusGained] *
     #(if (not= (vim.fn.mode) :i)
        (se- cursorline)))
```

## bspwm
WM of choice, made own with scripts based around `bspc subscribe`.

## soap
A bite-sized framework for managing .files with symlinks and hooks. There're plans for a rewrite.

### WIP
