(require-macros :zest.macros)

(lead- " ")

; TODO
; ds] should select "a]", strip [] and replace selection
; :h text-objects, just shove them into the config dict

; TODO
; (un)comment plugin
; i'm mostly commenting out paragraphs so, <leader>cp

; wrap all lines vs wrap each line?
; limestone italic selected in completion menu?

(fn pseudo_operator [f t motion]
  (let [r (eval- "@@")]
    (match t
      :char (norm- (.. "v" motion "y"))
      _ (norm- (.. "`<" t "`>y")))
    (let [context (eval- "@@")
          output (f context)]
      (when output
        (vim.fn.setreg "@" output (vim.fn.getregtype "@"))
        (norm- "gv\"0p"))
      (vim.fn.setreg "@@" r (vim.fn.getregtype "@@")))))

(fn def-pseudo-operator [key f motions]
  (local id (.. key "_operator"))
  (tset _G id
        (fn [t motion]
          (pseudo_operator f t motion)))
  (each [k v (pairs motions)]
    (ki- [n :silent] (.. key k) (.. ":call v:lua." id "('char', '" v "')<cr>")))
  (ki- [v :silent] key (.. ":<c-u>call v:lua." id "(visualmode())<cr>")))

(fn surround [s]
  (let [c (vim.fn.nr2char (vim.fn.getchar))]
    (match c
      "(" (.. "("  s  ")")
      ")" (.. "( " s " )")
      "[" (.. "["  s  "]")
      "]" (.. "[ " s " ]")
      "{" (.. "{"  s  "}")
      "}" (.. "{ " s " }")
      "<" (.. "<"  s  ">")
      ">" (.. "< " s " >")
      _ (.. c s c))))

(def-pseudo-operator "s" surround
  {"w" "iw"
   "W" "iW"
   "(" "i)"
   ")" "a)"})


; don't like to lose control over what keybinding means, like 'sw' should be same as 'siw', sexp-style
;(ki- [n :silent] :s ":set operatorfunc=v:lua.surround<cr>g@")

;(fn surround [motion]
;  (let [c (vim.fn.nr2char (vim.fn.getchar))
;        (l r) (get-surround-chars c)]
;    (norm- (.. "v" motion "y"))
;    (let [r (.. l (eval- "@@") r)]
;      (vim.fn.setreg "@" r (vim.fn.getregtype "@"))
;      (norm- "gv\"0p"))))

;(fn context [motion]
;  (let [count (if (> vim.v.count 0) vim.v.count nil)
;        visual? (not motion)]
;    (if
;      count
;      (norm- (.. "V" count "$y"))
;      visual?
;      (norm- "gvy")
;      motion
;      (norm- (.. "v" motion "y")))
;    (eval- "@@")))
;
;(fn context-fn [f motion]
;  (let [c (context motion)
;        o (f c)]
;    (vim.fn.setreg "\"0" o (vim.fn.getregtype "\"0"))
;    (norm- "gv\"0p")))
;
;
;(each [k v (pairs surround-motions)]
;  (ki- [n :oneshot] (.. "s" k) (fn [] (context-fn surround v)))
;  (ki- [v :oneshot] (.. "s" k) (fn [] (context-fn surround))))

;(fn get-context [motion]
;  (let [visual (vim.fn.visualmode)
;        visual (if (= "" visual) nil visual)
;        count (if (> vim.v.count 0) vim.v.count nil)]
;    (if
;      visual (norm- "y")
;      count  (norm- (.. "V" count "$y"))
;      motion (norm- (.. "v" motion "y"))
;      )
;    (eval- "@@")))
;
;(fn my-context-based-fn [motion]
;  (let [reg (eval- "@@")
;        con (get-context motion)
;        out (.. "( " con " )")]
;    (vim.fn.setreg "\"0" out (vim.fn.getregtype "\"0"))
;    (norm- "gv\"0p")))
;
;(ki- [nvx :silent :oneshot] "<leader>m" (fn [] (my-context-based-fn "iw")))

; ------------------------------------
; -- land of opinionated navigation --
; ------------  --/-<@  --------------

; smart v-line movement
(fn smart-line-move [d]
  (if (> vim.v.count 0) d (.. "g" d)))

(ki- [nv :expr] :e (partial smart-line-move :k))
(ki- [nv :expr] :n (partial smart-line-move :j))

(li- [o] e k)
(li- [o] n j)

; vertical
(li- [n] N <c-d>)
(li- [n] E <c-u>)

; horizontal
(li- [nv] H 0)
(li- [nv] I $)
(li- [nv] <ScrollWheelUp> <c-y>)
(li- [nv] <ScrollWheelDown> <c-e>)

; split-wise
(li- [n] <c-h> <c-w>h)
(li- [n] <c-n> <c-w>j)
(li- [n] <c-e> <c-w>k)
(li- [n] <c-i> <c-w>l)

; consistency
(li- [n] Y y$)
(li- [n] U <c-r>)
(li- [n] <c-j> J)

; ------------------------------------
; --      search and replace        --
; ------------  --/-<@  --------------

; general
(li- [nv :silent] // ":noh<cr>")
(li- [n :silent] * *N) ; check if there's an entry above?

(li- [n] <leader>r ":%s///g<left><left>")  ; replace searched text
(li- [x] <leader>r ":s///g<left><left>")   ; same but in current v-selection

; search for selected text
(ki- [x] "*"
  (fn []
    (norm- "gvy")
    (exec- (.. "/" (eval- "@\"")))
    (norm- "N")))

; stay in visual mode when indenting
(li- [x] < <gv)
(li- [x] > >gv)

; colemak
(li- [nv] i l)
(li- [nv] l i)
(li- [nvo] L I)
(li- [nvo] k n)
(li- [nvo] K N)
(li- [nvo] j f)
(li- [nvo] J F)
(li- [nvo] f e)
(li- [nvo] F E)
