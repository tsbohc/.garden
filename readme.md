```
                                                   /)
                                     _   _   __  _(/  _  __
                                  . (_/_(_(_/ (_(_(__(/_/ (_
                                   .-/
                                  (_/
```

![](https://github.com/tsbohc/.garden/blob/master/usr/lush-to-shell-full.png)

## hori-hori

A tiny dotfiles templating and management framework written in pure bash in `100 sloc`:

- Toml-inspired configuration language
- Logicless recursive templating
- Package-like management

See [hori-hori](https://github.com/tsbohc/hori-hori) for more info.

## nvim

### config
Written in [fennel](https://github.com/bakpakin/Fennel/), a lisp that compiles to lua, via [zest](https://github.com/tsbohc/zest.nvim).

```clojure
; options
(se- cursorline)
(se- [:append] completeopt ["menuone" "noselect"])
(se- listchars {:trail "␣"})

; keymaps
(ki- [nv :expr] :e [(if (> vim.v.count 0) "k" "gk")])
(ki- [nv :expr] :n [(if (> vim.v.count 0) "j" "gj")])

(ki- [x] :*
  [(let [p (vim.fn.getpos ".")]
     (vim.cmd "norm! gvy")
     (vim.cmd (.. "/" (vim.api.nvim_eval "@\"")))
     (vim.fn.setpos "." p))])

(ki- [n]
  {:<c-h> "<c-w>h"
   :<c-n> "<c-w>j"
   :<c-e> "<c-w>k"
   :<c-i> "<c-w>l"})

; autocmds
(gr- :smart-cursorline
  (au- [:InsertEnter :BufLeave :FocusLost] "*"
    [(se- cursorline false)])
  (au- [:InsertLeave :BufEnter :FocusGained] "*"
    [(if (not= (vim.fn.mode) :i)
       (se- cursorline))]))
```

## addendum
- I'm not a programmer by trade, but I like writing code. As such, it is very [opinionated](https://i.redd.it/se5rfanqhqx11.jpg).
- Feel free to look around, fork, and praise or yell at me in an issue!
- Giving credit is appreciated.

Thanks!
