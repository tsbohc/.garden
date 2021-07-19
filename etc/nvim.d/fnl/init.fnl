;        .
;  __   __)
; (. | /o ______  __  _.
;    |/<_/ / / <_/ (_(__
;    |
;

(require-macros :zest.macros)

(g- python_host_prog :/usr/bin/python2)
(g- python3_host_prog :/usr/bin/python3)

(require :rc.love-compe)

(require :rc.plugins)
(require :rc.options)
(require :rc.keymaps)
(require :rc.aucmds)
(require :rc.excmds)
(require :rc.textobjects)




1

;(op- "s" (fn [s]
;  (let [c (vim.fn.nr2char (vim.fn.getchar))]
;    (match c
;      "\"" (.. "\"" s "\"")
;      "'" (.. "'"  s  "'")
;      "(" (.. "( " s " )")
;      ")" (.. "("  s  ")")
;      "[" (.. "[ " s " ]")
;      "]" (.. "["  s  "]")
;      "{" (.. "{ " s " }")
;      "}" (.. "{"  s  "}")
;      "<" (.. "< " s " >")
;      ">" (.. "<"  s  ">")))))




















;(se- set-value)
;(se? get-value)
;(se! toggle)
;(se< append)
;(se> prepend)

;(se- number)   ; set
;(se- number!)  ; toggle
;(se- number?)  ; get
;(se- number+)  ; add
;(se- number-)  ; remove
;(se- number^)  ; prepend


;(fn surround-op [s]
;  (let [c (vim.fn.nr2char (vim.fn.getchar))]
;    (match c
;      "\"" (.. "\"" s "\"")
;      "'" (.. "'"  s  "'")
;      "(" (.. "( " s " )")
;      ")" (.. "("  s  ")")
;      "[" (.. "[ " s " ]")
;      "]" (.. "["  s  "]")
;      "{" (.. "{ " s " }")
;      "}" (.. "{"  s  "}")
;      "<" (.. "< " s " >")
;      ">" (.. "<"  s  ">"))))

; (fn make-me-suffer [s]
;   (var i 0)
;   (s:gsub "." (fn [c] (when (not= c " ") (set i (+ 1 i)) (if (= 0 (% i 2)) (c:upper) (c:lower))))))

; ; operator

; ; TODO restore cursor position
; (fn comment-op [do? s t]
;   (let [(x y) (vim.bo.commentstring:match "(.-)%s+(.-)")
;         do-comment (fn [l] (if (and (not= "\n" l)) (.. x " " l)))
;         un-comment (fn [l] (l:gsub (.. "^(%" x "%s?)") ""))]
;     (s:gsub "(.-\n)" (if do? do-comment un-comment))))

; (op- "<leader>u" (partial comment-op false))
; (op- "<leader>c" (partial comment-op true))

; ;

; ;(fn get-cursor-pos []
; ;  (vim.fn.getpos "."))
; ;
; ;(fn set-cursor-pos [p]
; ;  (vim.fn.setpos "." p))
; ;
; ;(fn char [d]
; ;  "get character under cursor"
; ;  (let [d (or d 0)
; ;        l (vim.fn.getline ".")
; ;        n (+ d (vim.fn.col "."))]
; ;    (vim.fn.strcharpart (l:sub n n) 0 1)))
; ;
; ;(fn search [re flags]
; ;  "search for very non-magic 're' and return character under cursor"
; ;  (let [flags (or flags "")
; ;        r (vim.fn.search (.. "\\V" re) flags)]
; ;    (if (not= r 0)
; ;      (char))))
; ;
; ;; for quote to work, we need to count all quotes in file before cursor and check if they're even or odd
; ;; <even> | -> we're outside a quote " " | " ", so we look for the next " and start there
; ;; <odd>  | -> we're inside  a quote " " " | ", so we look back for a   " and start there
; ;
; ;; precise stuff like i' i" + for backtick
; ;; general "q"uote
; ;
; ;; find prev ( -- (find ["(" "[" "[" "<"] :b)
; ;; find next ( -- (find ["(" "[" "{" "<"])
; ;; find prev ) -- (find [")" "]" "}" ">"] :b)
; ;; find next ) -- (find [")" "]" "}" ">"])
; ;
; ;; get-type: ")" -> "p", "(" -> "p"
; ;; get-pair: ")" -> "(", "(" -> ")"
; ;; get-valu: ")" -> -1, "(" -> 1
; ;
; ;(local ps
; ;  {"(" {:t "p" :v -1 :p ")"}
; ;   ")" {:t "p" :v  1 :p "("}
; ;   "[" {:t "b" :v -1 :p "]"}
; ;   "]" {:t "b" :v  1 :p "["}
; ;   "{" {:t "c" :v -1 :p "}"}
; ;   "}" {:t "c" :v  1 :p "{"}
; ;   "<" {:t "a" :v -1 :p ">"}
; ;   ">" {:t "a" :v  1 :p "<"}})
; ;
; ;(fn surround-op [s t]
; ;  (let [l (s:sub 1 1)
; ;        r (s:sub -1)]
; ;    (when (and (core.has? ps l) (core.has? ps r))
; ;      (s:sub 2 -2))))
; ;
; ;(op- "sd" surround-op)
; ;(op- "sc" surround-op) how much do we need change though

; ;(fn get [w x] (?. ps x w))
; ;
; ;(fn find-next [re flags counts]
; ;  (let [x (search re flags)
; ;        t (get :t x)]
; ;    (when x
; ;      (tset counts t (+ (. counts t) (get :v x)))
; ;      (if (not= 0 (. counts t))
; ;        (find-next re flags counts)
; ;        x))))
; ;
; ;(fn find-paren [xs b? cur?]
; ;  (let [c (char)]
; ;    (if (and cur? (core.has? xs c))
; ;      c
; ;      (let [counts {}
; ;            items []
; ;            flags (.. "W" (if b? "b" ""))]
; ;        (each [_ x (ipairs xs)]
; ;          (tset counts (get :t x) (* -1 (get :v x)))
; ;          (table.insert items x)
; ;          (table.insert items (get :p x)))
; ;        (let [re (table.concat items "\\|")]
; ;          (find-next re flags counts))))))
; ;
; ; look forward first because most of the time you're probably writing closer to the end of a file

; ;(fn f [xs seek?]
; ;  (if (not seek?)
; ;    (let [pos (get-cursor-pos)
; ;         c (find-paren xs nil :cursor)]
; ;     (if c
; ;       (let [l (get :p c)]
; ;         (norm- "v")
; ;         (find-paren [l] :back))
; ;       (do
; ;         (set-cursor-pos pos)
; ;         false)))
; ;    (let [pos (get-cursor-pos)
; ;          c (find-paren xs nil :cursor)]
; ;      (if c
; ;        (let [r (get :p c)]
; ;          (norm- "v")
; ;          (when (find-paren [r])
; ;            (norm- "o")
; ;            true))
; ;        (do
; ;          (set-cursor-pos)
; ;          false)))))

; ;(te- "af" (fn [] (f [")" "}" "]" ">"])))
; ;(te- "if" (fn [] (f [")" "}" "]" ">"]) (norm- "loho")))
; ;
; ;(te- "a)" (fn [] (f [")"])))
; ;(te- "a(" (fn [] (f ["("] :seek)))
; ;(te- "i)" (fn [] (if (f [")"]) (norm- "loho"))))
; ;(te- "i(" (fn [] (if (f ["("] :seek) (norm- "loho"))))
; ;
; ;(te- "a}" (fn [] (f ["}"])))
; ;(te- "a{" (fn [] (f ["{"] :seek)))
; ;(te- "i}" (fn [] (if (f ["}"]) (norm- "loho"))))
; ;(te- "i{" (fn [] (if (f ["{"] :seek) (norm- "loho"))))
; ;
; ;(te- "a]" (fn [] (f ["]"])))
; ;(te- "a[" (fn [] (f ["["] :seek)))
; ;(te- "i]" (fn [] (if (f ["]"]) (norm- "loho"))))
; ;(te- "i[" (fn [] (if (f ["["] :seek) (norm- "loho"))))
; ;
; ;(te- "a>" (fn [] (f [">"])))
; ;(te- "a<" (fn [] (f ["<"] :seek)))
; ;(te- "i>" (fn [] (if (f [">"]) (norm- "loho"))))
; ;(te- "i<" (fn [] (if (f ["<"] :seek) (norm- "loho"))))

























; ; - quotes are a pain, as we have to continue search after finding one to see if there's more
; ; - if there is an even number of quotes until next )]}>, that we're not in quotes

; ; you know what, fuck strings
; ; sad about universal ds though

; ; actually if we count how many strings we encountered while searching for pair
; ; and when the search ends check if its odd or even hmmm

; ; while it's possbile to include quotes, i think it bars on doing too much
; ; also, ds would work on 

; ; dsib -> delete surroundings of an inner block
; ; dsiu? universal-block? meh
; ; dsif form!

; ; ds should just get a text object and remove 1 char on each side (hell no i'm not supporting tags)
; ; but what about spaced surrounds? we could check if the two chars are spaces, and if they are, delete them and 2 more chars

; ; i would rather put the load on text objects than the surround logic, like
; ; have a "q"oute text object that matches ' or " and maybe that cyrillic thing:
; ; dsiq -> remove quotes around a quotes block
; ; siq( -> surround quotes with ('s
; ; sib" -> surround block with "

; ; s



;(setoption wooo:append 1)

;(local msg "1aaa that feeling when > < ! @ #%)(@#$")
;(local e "<c-m>")
;(local m "m")

;(fn es [s] (s:gsub "%W" (fn [c] (string.format "_%02X_" (string.byte c)))))
;(print (.. "'" (es msg) "'"))

;(keymap-function (.. "<c-" m ">") [n] (print "woo")) ; only takes a literal string
;(keymap-function e [n] (print "woo")) ; only takes a literal string
;(keymap-function "<c-m>" [n] (print "woo")) ; only takes a literal string
;(keymap-expression e [n] (.. ":echo '" msg "'<cr>"))
;(keymap-literal m [n] 0)


; (print (vim.inspect (vim.opt.listchars:get)))

; (se= "set" v) ; or se-
; (se? "get" v) ; or ge- or se?
; (se> "append" v)
; (se^ "prepend" v)
; (se< "remove" v)

;(require :zest) ; put init stuff here, or rather in zest.setup or better yet, in the plugin itself
;(require-macros :zest.macros)
;(print (opt- number?))
;(print (vim.inspect vim.opt.number))

;(tset _G :ZEST (or _G.ZEST {:keymap  {} :autocmd {}}))
;(require-macros :zest.new-macros)

