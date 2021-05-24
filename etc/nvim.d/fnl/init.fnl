;        .
;  __   __)
; (. | /o ______  __  _.
;    |/<_/ / / <_/ (_(__
;    |
;

(local core {})

(fn core.seq? [xs]
  "check if table is a sequence"
  (var i 0)
  (each [_ (pairs xs)]
    (set i (+ i 1))
    (if (= nil (. xs i))
      (lua "return false")))
  true)

(fn core.has? [xt y]
  "check if table contains a value or a key pair"
  (if (core.seq? xt)
    (each [_ v (ipairs xt)]
      (when (= v y)
        (lua "return true")))
    (when (not= nil (. xt y))
      (lua "return true")))
  false)

(require-macros :zest.macros)

(g- python_host_prog :/usr/bin/python2)
(g- python3_host_prog :/usr/bin/python3)

(require :rc.plugins)
(require :rc.options)
(require :rc.keymaps)
(require :rc.aucmds)
(require :rc.excmds)

(fn make-me-suffer [s]
  (var i 0)
  (s:gsub "." (fn [c] (when (not= c " ") (set i (+ 1 i)) (if (= 0 (% i 2)) (c:upper) (c:lower))))))

(local bind (require :zest.bind))

; text object

; line
(te- :il "g_v^")
(te- :al "$v0")

; document
(te- :ig "GVgg")
(te- :ag "GVgg")

; operator

; TODO restore cursor position
(fn comment-op [do? s t]
  (let [(x y) (vim.bo.commentstring:match "(.-)%s+(.-)")
        do-comment (fn [l] (if (and (not= "\n" l)) (.. x " " l)))
        un-comment (fn [l] (l:gsub (.. "^(%" x "%s?)") ""))]
    (s:gsub "(.-\n)" (if do? do-comment un-comment))))

(op- "<leader>u" (partial comment-op false))
(op- "<leader>c" (partial comment-op true))

;


(fn get-cursor-pos []
  (vim.fn.getpos "."))

(fn set-cursor-pos [p]
  (vim.fn.setpos "." p))

(fn char [d]
  "get character under cursor"
  (let [d (or d 0)
        l (vim.fn.getline ".")
        n (+ d (vim.fn.col "."))]
    (vim.fn.strcharpart (l:sub n n) 0 1)))

(fn search [re flags]
  "search for very non-magic 're' and return character under cursor"
  (let [flags (or flags "")
        r (vim.fn.search (.. "\\V" re) flags)]
    (if (not= r 0)
      (char))))

; for quote to work, we need to count all quotes in file before cursor and check if they're even or odd
; <even> | -> we're outside a quote " " | " ", so we look for the next " and start there
; <odd>  | -> we're inside  a quote " " " | ", so we look back for a   " and start there

; precise stuff like i' i" + for backtick
; general "q"uote

; find prev ( -- (find ["(" "[" "[" "<"] :b)
; find next ( -- (find ["(" "[" "{" "<"])
; find prev ) -- (find [")" "]" "}" ">"] :b)
; find next ) -- (find [")" "]" "}" ">"])

; get-type: ")" -> "p", "(" -> "p"
; get-pair: ")" -> "(", "(" -> ")"
; get-valu: ")" -> -1, "(" -> 1

(local ps
  {"(" {:t "p" :v -1 :p ")"}
   ")" {:t "p" :v  1 :p "("}
   "[" {:t "b" :v -1 :p "]"}
   "]" {:t "b" :v  1 :p "["}
   "{" {:t "c" :v -1 :p "}"}
   "}" {:t "c" :v  1 :p "{"}
   "<" {:t "a" :v -1 :p ">"}
   ">" {:t "a" :v  1 :p "<"}})

(fn get [w x] (?. ps x w))

(fn find-next [re flags counts]
  (let [x (search re flags)
        t (get :t x)]
    (when x
      (tset counts t (+ (. counts t) (get :v x)))
      (if (not= 0 (. counts t))
        (find-next re flags counts)
        x))))

(fn find-paren [xs b? cur?]
  (let [c (char)]
    (if (and cur? (core.has? xs c))
      c
      (let [counts {}
            items []
            flags (.. "W" (if b? "b" ""))]
        (each [_ x (ipairs xs)]
          (tset counts (get :t x) (* -1 (get :v x)))
          (table.insert items x)
          (table.insert items (get :p x)))
        (let [re (table.concat items "\\|")]
          (find-next re flags counts))))))

; look forward first because most of the time you're probably writing closer to the end of a file

(fn f [xs seek?]
  (if (not seek?)
    (let [pos (get-cursor-pos)
         c (find-paren xs nil :cursor)]
     (if c
       (let [l (get :p c)]
         (norm- "v")
         (find-paren [l] :back))
       (do
         (set-cursor-pos pos)
         false)))
    (let [pos (get-cursor-pos)
          c (find-paren xs nil :cursor)]
      (if c
        (let [r (get :p c)]
          (norm- "v")
          (when (find-paren [r])
            (norm- "o")
            true))
        (do
          (set-cursor-pos)
          false)))))

(te- "af" (fn [] (f [")" "}" "]" ">"])))
(te- "if" (fn [] (f [")" "}" "]" ">"]) (norm- "loho")))

(te- "a)" (fn [] (f [")"])))
(te- "a(" (fn [] (f ["("] :seek)))
(te- "i)" (fn [] (if (f [")"]) (norm- "loho"))))
(te- "i(" (fn [] (if (f ["("] :seek) (norm- "loho"))))

(te- "a}" (fn [] (f ["}"])))
(te- "a{" (fn [] (f ["{"] :seek)))
(te- "i}" (fn [] (if (f ["}"]) (norm- "loho"))))
(te- "i{" (fn [] (if (f ["{"] :seek) (norm- "loho"))))

(te- "a]" (fn [] (f ["]"])))
(te- "a[" (fn [] (f ["["] :seek)))
(te- "i]" (fn [] (if (f ["]"]) (norm- "loho"))))
(te- "i[" (fn [] (if (f ["["] :seek) (norm- "loho"))))

(te- "a>" (fn [] (f [">"])))
(te- "a<" (fn [] (f ["<"] :seek)))
(te- "i>" (fn [] (if (f [">"]) (norm- "loho"))))
(te- "i<" (fn [] (if (f ["<"] :seek) (norm- "loho"))))


; ; (set _G.find find)

; ; (local pair
; ;   {"(" ")" ")" "("
; ;    "[" "]" "]" "["
; ;    "{" "}" "}" "{"
; ;    "<" ">" ">" "<"})

; ; (fn fm [x flags i]
; ;   "find matching pair"
; ;   (let [i (or i 1)]
; ;     (if (> (or i 1) 0)
; ;       (let [y (. pair x)
; ;             f (find (.. x "\\|" y) flags)]
; ;         (match f
; ;           x (fm x flags (- i 1))
; ;           y (fm x flags (+ i 1))
; ;           nil false))
; ;       true)))

; ; ;(fn find-open-any [xs]
; ; ;  (let [counters {}
; ; ;        items []]
; ; ;    (each [_ v (ipairs xs)]
; ; ;      (tset counters (. ps v :k) (* -1 (. ps v :v)))
; ; ;      )))
; ; ;
; ; ;(fn find-open-any []
; ; ;  (let [xt {:p 0 :b 0 :c 0 :a 0}
; ; ;        re (table.concat ["(" ")" "[" "]" "{" "}" "<" ">"] "\\|")]
; ; ;    ()))
; ; ;
; ; ;(fn find-open-next [done? re]
; ; ;  (when (not done?)
; ; ;    (let [f (find )])))


; ; ; (fn find-matching [xs flags i]
; ; ;   (let [counter {}
; ; ;         pair-s []]
; ; ;     (each [_ v (ipairs xs)]
; ; ;       (tset counter (. ps v :t) 1)
; ; ;       (table.insert pair-s v)
; ; ;       (table.insert pair-s (. ps v :p)))
; ; ;     (var re (table.concat pair-s "\\|")))))))

; ; ; (fn find-next [done? re flags counters]
; ; ;   (if (not done?)
; ; ;     (let [f (find re flags)]
; ; ;       (tset counters (. ps f :t)
; ; ;             (if (= "l" (. ps f :d))
; ; ;               ya))
; ; ;       ; (find-next...)
; ; ;       )
; ; ;     true)
; ; ;   ;(var done? done?)
; ; ;   ; has to be post cycle
; ; ;   ;(each [_ v (ipairs counter)]
; ; ;   ;  (when (= v 0) (set done? true)))
; ; ;   )

; ; ; another idea:
; ; ; keep count for each () [] {} <>
; ; ; change find re to (table.concat ["(" ")" "[" ...] "\\|")?
; ; ; check whech gets to 0 first?

; ; (fn outer [l r]
; ;   (l) (norm- "v") (r))

; ; ; dumb idea
; ; ; get line:col, jump to the other side of viselect, get line:col
; ; ; compare
; ; ; based on that execute h or l
; ; ; jump again, h or l
; ; ; jump to the beginning if needed

; ; (fn inner [l r] ; but what if it's right -> left instead?
; ;   ; FIXME i neeeed a better way of doing this
; ;   (l) (norm- "lv") (r) (norm- "h"))

; ; (fn form-l [x y]
; ;   (let [pos (get-cursor-pos)]
; ;     (if (or (= x (char)) (fm x "bW"))
; ;       true
; ;       (do (set-cursor-pos pos) false))))

; ; (fn fma_ [x inner? seek?]
; ;   (let [y (. pair x)]
; ;     (if (form-l x y)
; ;       (do
; ;         (when inner?
; ;           (norm- "l"))
; ;         (norm- "v")
; ;         (fm y "W")
; ;         (when inner?
; ;           (norm- "h")))
; ;       (when (and seek? (fm x "W"))
; ;         (when inner?
; ;           (norm- "l"))
; ;         (norm- "v")
; ;         (fm y "W")
; ;         (when inner?
; ;           (norm- "h"))))))

; ; (set _G.fma fma)

; ; ;(viml- "nnoremap gv0 `<")
; ; ;(viml- "nnoremap gv$ `>")

; ; ; a) doesn't seek
; ; ; a( seeks

; ; (te- "a)" (fn [] (fma_ "(" false)))
; ; (te- "i)" (fn [] (fma_ "(" true)))
; ; (te- "a(" (fn [] (fma_ "(" false true)))
; ; (te- "i(" (fn [] (fma_ "(" true  true)))

; ; ;(te- "a)" (fn []
; ; ;  (find "(" "zW")
; ; ;  (norm- "v")
; ; ;  (find ")" "bW")))
; ; ;
; ; ;(te- "i)" (fn []
; ; ;  ; wait, this would break when inside parens
; ; ;  (find "(" "zW")
; ; ;  (norm- "lv")
; ; ;  (find ")" "W")
; ; ;  (norm- "h")))

; ; ;(vim.api.nvim_set_keymap "n" "f" ":call v:lua.find(nr2char(getchar()))<cr>" {:noremap true})


























; - quotes are a pain, as we have to continue search after finding one to see if there's more
; - if there is an even number of quotes until next )]}>, that we're not in quotes

; you know what, fuck strings
; sad about universal ds though

; actually if we count how many strings we encountered while searching for pair
; and when the search ends check if its odd or even hmmm

; while it's possbile to include quotes, i think it bars on doing too much
; also, ds would work on 

; dsib -> delete surroundings of an inner block
; dsiu? universal-block? meh
; dsif form!

; ds should just get a text object and remove 1 char on each side (hell no i'm not supporting tags)
; but what about spaced surrounds? we could check if the two chars are spaces, and if they are, delete them and 2 more chars

; i would rather put the load on text objects than the surround logic, like
; have a "q"oute text object that matches ' or " and maybe that cyrillic thing:
; dsiq -> remove quotes around a quotes block
; siq( -> surround quotes with ('s
; sib" -> surround block with "

; s
