```
                                                  /)                      
                                    _   _   __  _(/  _ __               
                                 . (_/_(_(_/ (_(_(__(/_/ (_             
                                  .-/                                   
                                 (_/                                    
```
## nvim

#### init.lua
Written in [fennel](https://github.com/bakpakin/Fennel/), a lisp that compiles lua, via [zest](https://github.com/tsbohc/zest.nvim).

```clojure
; options
(se- scrolloff 10)                  ; cursor padding in window
(se- nowrap)                        ; do not wrap long lines

; smart v-line movement
(ki- [nvo :expr] :e (fn [] (if (> vim.v.count 0) :k :gk)))
(ki- [nvo :expr] :n (fn [] (if (> vim.v.count 0) :j :gj)))

; search for selected text
(ki- [x] :* (fn []
  (norm- "gvy")
  (exec- (.. "/" (eval- "@\"")))
  (norm- "N")))
```

## addendum
- I'm not a programmer by trade, but I like writing code. As such, it is very [opinionated](https://i.redd.it/se5rfanqhqx11.jpg).
- Feel free to look around, fork, and praise or yell at me in an issue!
- Giving credit is appreciated.

Thanks!
