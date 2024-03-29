(local def-to (require :misc.textobject))
(local cursor (require :misc.cursor))

; quote

; multiline quotes are rare, better to drop support for that

; diq - inside, daq - around, dq - inner

; ignore escaped \"

; always match the closest pair of quotes, editing stuff between two string is useful too
;       |
;   "some" dinosaurs are "cool"
;   ^^^^^^

;          |
;   "some" dinosaurs are "cool"
;        ^^^^^^^^^^^^^^^^^

; seek forward if there's no quote on the same line to the left
; |
;   "some" dinosaurs are "cool"
;   ^^^^^^

; seek forward if curson is on a quote and there is one to the right, else seek backwards
;        |
;   "some" dinosaurs are "cool"
;        ^^^^^^^^^^^^^^^^^

(fn _quote []
  (let [cpos (cursor.get)
        re (.. "\\V" (table.concat ["\""] "\\|"))
        d1 (cursor.search re "cbW") ; separate out
        d2 (when d1 (cursor.search (.. "\\V" d1.c) "zW"))]
    (when (and d1 d2)
      (let [x d1.p
            y d2.p]
        (cursor.set cpos)
        (values x y)))))

(def-to.inner  "a\"" _quote)
(def-to.around "A\"" _quote)
(def-to.inside "m\"" _quote)


(local p
  {"(" {:k "r" :d {"(" ")"} :v -1}
   ")" {:k "r" :d {"(" ")"} :v  1}
   "[" {:k "s" :d {"[" "]"} :v -1}
   "]" {:k "s" :d {"[" "]"} :v  1}
   "{" {:k "c" :d {"{" "}"} :v -1}
   "}" {:k "c" :d {"{" "}"} :v  1}})

(fn re [xt only-open?]
  "convert 'xt' of parens to a very non-magic re"
  (let [acc []]
    (each [k v (pairs xt)]
      (table.insert acc k)
      (when (not only-open?)
        (table.insert acc v)))
    (.. "\\V" (table.concat acc "\\|"))))

(fn parsearch-counts [xt v]
  "initialise counts for 'xt' of parens"
  (let [counts {}]
    (each [q _ (pairs xt)]
      (tset counts (. p q :k) (* -1 v)))
    counts))

; todo change to search with 'c' flag
(fn par-oncu [xt]
  "check if a paren from 'xt' is under the cursor and return data like search"
  (let [c (cursor.char)]
    (each [k v (pairs xt)]
      (when (or (= c k) (= c v))
        (let [d {:c c
                 :p (cursor.get)}]
          (lua "return d"))))))

(fn parsearch [xt v ...]
  "look for first matching paren from 'xt' of type 'v' (-1 for open, +1 for closed)"
  (let [cpos (cursor.get)
        counts (parsearch-counts xt v)]
    (var r "")
    (while (= r "")
      (print r)
      (let [d (cursor.search (re xt) ...)]
        (if d
          (let [k (. p d.c :k)
                count (. counts k)
                delta (. p d.c :v)
                sum (+ count delta)]
            (if (= sum 0)
              (set r d)
              (tset counts k sum)))
          (set r false))))
    (if (not r)
      (cursor.set cpos)
      r)))

(fn form [xt]
  "find appropriate form of parens 'xt' and return its x and y coords"
  (let [xt (or xt {"(" ")" "[" "]" "{" "}"})
        cpos (cursor.get)
        d1 (or (par-oncu xt)
               (parsearch xt -1 "bW")
               (cursor.search (re xt :only-open) "zW" (vim.fn.line ".")))]
    (if d1
      (let [xt2 (. p d1.c :d)
            v2 (* -1 (. p d1.c :v))
            f2 (if (= -1 v2) "bw" "zw")
            d2 (parsearch xt2 v2 f2)]
        (if d2
          (let [(x y) (if (= -1 v2) (values d2.p d1.p) (values d1.p d2.p))]
            (cursor.set cpos)
            (values x y))
          (cursor.set cpos)))
      (cursor.set cpos))))

(def-to.inner  :af  form)
(def-to.around :Af form)
(def-to.inside :mf form)

;(te- "if" (fn [] (textobject (form) :inner)))
;(te- "af" (fn [] (textobject (form) :outer)))





;
;; TODO
;; memoize stuff
;; add a string escape function to make working with "|/" and such easier or rather string literal macro
;
;(local b (require :rc.textobjects.base))
;(local textobject b.textobject)
;
;; {l} line
;;(te- :il "g_v^")
;;(te- :al "$v0")
;
;; {g} global
;(te- :ig "GVgg")
;(te- :ag "GVgg")
;
;
;;(local _quote (require :rc.textobjects.quote))
;
;;(ki- [n] "<c-m>" (fn [] (_quote ["\"" "'"])))
;
;; {f} form
;
;; 1. cursor at the edge of a form
;; |                |
;; ( ... ) or ( ... )
;; ^^^^^^^    ^^^^^^^
;; 2. cursor inside a form
;;         |
;; ( ... ( ... ( ... ) ... ))
;;       ^^^^^^^^^^^^^^^^^^^
;; 3. cursor outside a form
;;           |
;; ( ... ) ... ( ... )
;;             ^^^^^^^
;
;(local form (require :rc.textobjects.form))
;
;(te- "if" (fn [] (textobject (form) :inner)))
;(te- "af" (fn [] (textobject (form) :outer)))
;
;(each [_ f (ipairs [{"(" ")"} {"[" "]"} {"{" "}"}])]
;  (each [k v (pairs f)]
;    (te- (.. "i" k) (fn [] (textobject (form f) :inner)))
;    (te- (.. "a" k) (fn [] (textobject (form f) :outer)))
;    (te- (.. "i" v) (fn [] (textobject (form f) :inner)))
;    (te- (.. "a" v) (fn [] (textobject (form f) :outer)))))
;
;
;
;
;;(local core {})
;;
;;(fn core.table? [x]
;;  (= "table" (type x)))
;;
;;(fn core.count [xs]
;;  "count elements in seq or characters in string"
;;  (if
;;    (core.table? xs)
;;    (do
;;      (var maxn 0)
;;      (each [k v (pairs xs)]
;;        (set maxn (+ maxn 1)))
;;      maxn)
;;    (not xs) 0
;;    (length xs)))
;;
;;(fn core.empty? [xs]
;;  (= 0 (core.count xs)))
;;
;;; util
;;
;;(fn get-cursor-pos []
;;  (vim.fn.getpos "."))
;;
;;(fn set-cursor-pos [p]
;;  (vim.fn.setpos "." p))
;;
;;(fn char [d]
;;  "get character under cursor"
;;  (let [d (or d 0)
;;        l (vim.fn.getline ".")
;;        n (+ d (vim.fn.col "."))]
;;    (vim.fn.strcharpart (l:sub n n) 0 1)))
;;
;;(fn under-cursor [d]
;;  "get character under cursor"
;;  (let [d (or d 0)
;;        l (vim.fn.getline ".")
;;        n (+ d (vim.fn.col "."))]
;;    (vim.fn.strcharpart (l:sub n n) 0 1)))
;;
;;(fn search-pos [re flags]
;;  "search for very non-magic 're' and return cursor position"
;;  (let [re (if (= (type re) :table) (table.concat re "\\|") re)
;;        flags (or flags "")
;;        r (vim.fn.searchpos (.. "\\V" re) flags)]
;;    (match r [0 0] nil _ r)))
;;
;;; should be run once at startup, no every time the function is called
;;(fn pairs-re [xs]
;;  (let [bag []]
;;    (each [_ v (ipairs xs)]
;;      (table.insert bag (. v 1))
;;      (table.insert bag (. v 2)))
;;    (.. "\\V" (table.concat bag "\\|"))))
;;
;;(fn search [re flags stopline]
;;  "search for very non-magic 're' and return character under the cursor"
;;  (let [stopline (or stopline 0)
;;        flags (or flags "")
;;        r (vim.fn.search re flags stopline)]
;;    (when (not= r 0)
;;      (under-cursor))))
;;
;;; 1 2 -> 2 4 -> -1 1
;;; x * 2 - 3
;;
;;(fn parfind [xs k flags]
;;  (let [re (pairs-re xs)
;;        flags (or flags "")
;;        pval (* -1 (- (* k 2) 3))
;;        dict {}
;;        stat {}]
;;    (each [i p (ipairs xs)]
;;      (tset dict (. p 1) {:i i :v -1})
;;      (tset dict (. p 2) {:i i :v  1})
;;      (tset stat i pval))
;;    (var done? false)
;;    (while (not done?)
;;      (let [char (search re (.. flags "W"))]
;;        (if (not char)
;;          (set done? true)
;;          (let [i (. (. dict char) :i)
;;                v (. (. dict char) :v)
;;                c (. stat i)
;;                n (+ c v)]
;;            (if (= 0 n)
;;              (set done? [(. xs i)])
;;              (tset stat i n))))))
;;    (when (not= (type done?) :boolean)
;;      done?)))
;;
;;; TODO UGH
;;; i need to split those into chunks and reuse them
;;
;;(fn form-from-cursor [xs]
;;  (let [char (under-cursor)]
;;    (each [i v (ipairs xs)]
;;      (if (= char (. v 1))
;;        (let [x (get-cursor-pos)]
;;          (if (not (parfind [v] 2 :z))
;;            (set-cursor-pos x)
;;            (let [y (get-cursor-pos)]
;;              (lua "return x, y"))))
;;        (= char (. v 2))
;;        (let [y (get-cursor-pos)
;;              x (do (parfind [v] 1 :b) (get-cursor-pos))]
;;          (if (not (parfind [v] 1 :b))
;;            (set-cursor-pos y)
;;            (let [x (get-cursor-pos)]
;;              (lua "return x, y"))))))))
;;
;;(fn form-around-cursor [xs]
;;  (let [pos (get-cursor-pos)
;;        l (parfind xs 1 :b)]
;;    (if (not l)
;;      (set-cursor-pos pos)
;;      (let [l-pos (get-cursor-pos)
;;            r (parfind l 2 :z)]
;;        (if (not r)
;;          (set-cursor-pos pos)
;;          (let [r-pos (get-cursor-pos)]
;;            (values l-pos r-pos)))))))
;;
;;(fn form-seek [xs]
;;  (let [re (pairs-re xs)
;;        c (search re "zW" (vim.fn.line "."))]
;;    (when c
;;      (form-from-cursor xs))))
;;
;;; i need a macro that will stop on first non-nil value, combine x and y into a dict
;;(fn get-form-coords [xs]
;;  (let [(x y) (form-from-cursor xs)]
;;    (if (and x y)
;;      (values x y)
;;      (let [(x y) (form-around-cursor xs)]
;;        (if (and x y)
;;          (values x y)
;;          (let [(x y) (form-seek xs)]
;;            (if (and x y)
;;              (values x y))))))))
;;
;;; a better way of doing this would be to have 3 ways of getting first coord
;;; 1. check cursor
;;; 2. check backwards
;;; 3. seek forward on the line
;;; if there's a valid opening, look for pair
;;; problem is having the cursor at the closing paren
;;
;;; TODO
;;; OHHH, i should generalize this for any custom object, as it follows vim behaviour and accepts any arbitrary x and y
;;(fn form-object [xs modifier]
;;  (let [(x y) (get-form-coords xs)]
;;    (when (and x y)
;;      (match modifier
;;        :inner
;;        (do
;;          (set-cursor-pos y)
;;          (norm- "hv")
;;          (set-cursor-pos x)
;;          (norm- "l"))
;;        :around
;;        ; on the same line, select until the next non-whitespace character
;;        ; or previous, if we're at the end of a line or there's no whitespace to the right
;;        (let [line-len (vim.fn.strwidth (vim.fn.getline "."))
;;              at-end? (or (= (. y 3) line-len) (not= (under-cursor 1) " "))]
;;          (set-cursor-pos y)
;;          (when (and (not at-end?)
;;                     (not= 0 (vim.fn.search "\\S" "zW" (vim.fn.line "."))))
;;            (norm- "h"))
;;          (norm- "v")
;;          (set-cursor-pos x)
;;          (when (and at-end?
;;                     (not= 0 (vim.fn.search "\\S" "bW" (vim.fn.line "."))))
;;            (norm- "l")))))))
;;
;;; 1. begins or ends at cursor, cursor over ( or ) or " or '
;;; |                |
;;; ( ... ) or ( ... )
;;; ^^^^^^^    ^^^^^^^
;;
;;; 2. match around the cursor
;;;         |
;;; ( ... ( ... ( ... ) ... ))
;;;       ^^^^^^^^^^^^^^^^^^^
;;
;;; 3. match the closest form beginning on the same line forward
;;;           |
;;; ( ... ) ... ( ... )
;;;             ^^^^^^^
;;
;;
;;; -- a. pairs
;;; b. quotes
;;; c. separators
;;
;;;(fn quote-object []
;;;  (let [c (under-cursor)]
;;;    (when (core.has? ["\"" "'"] c)
;;;      (let [x (get-cursor-pos)
;;;            n (search c "zW")]
;;;        (when n
;;;          (let [y (get-cursor-pos)]
;;;            (values x y)))))))
;;
;;
;;
;;; a. when considering same delimiter for begin and end, match closest:
;;;        |
;;; " .... " ................ "
;;; ^^^^^^^^
;;; it's not the best for cases like:
;;;       |
;;; " ... " " ... "
;;;       ^^^
;;; but makes it very predictable
;;
;;; alternatively, i could always seek forward unless there isn't a pair, then seek backwards
;;;        |
;;; " .... " ................ "
;;;        ^^^^^^^^^^^^^^^^^^^^
;;
;;; maybe i should add explicit seeking behaviour with f and b, or p and n
;;; dfa' dba' delete-forward-around-' delete-backward-around-'
;;
;;; a, b, c, d.
;;
;;; b. generally, skip comments and escaped characters
;;
;;; " ... "
;;; ...
;;; ...
;;; ... " non-string " ...
;;; "
;;
;;; text-objects
;;
;;
;;; {q} quoted
;;
;;;(fn _G.foo []
;;;  (print (vim.fn.search "1" "pW")))
;;;
;;;(fn count-before [p]
;;;  "count number of occurences of 'p' in the document before cursor"
;;;  (let [pos (get-cursor-pos)]
;;;    (var count 0)
;;;    (while (not= 0 (vim.fn.search p "bW" (vim.fn.line ".")))
;;;      (set count (+ 1 count)))
;;;    (set-cursor-pos pos)
;;;    count))
;;;
;;;(fn even? [n]
;;;  (= (% n 2) 0))
;;;
;;;(fn odd? [n]
;;;  (not (even? n)))
;;;
;;;(fn _G.tt []
;;;  (let [dc (count-before "\"")
;;;        sc (count-before "'")]
;;;    (match [dc sc]
;;;      (where [d s] (and (odd? d) (odd? s))) (print "both"))))
;;;
;;;
;;;; how do i deal with escape quotes?
;;;
;;;; count all quotes in line before cursor and check if their number is even or odd
;;;; <even> or 0 | -> we're outside a quote " " | " ", so we look for the next " and start there
;;;; <odd>       | -> we're inside  a quote " " " | ", so we look back for a   " and start there
;;;
;;;; check if there's a quote before cursor, if there isn't, look forward for the opening
