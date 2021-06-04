(local b (require :rc.textobjects.base))
(require-macros :zest.macros)

(local M {})

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

(fn par-oncu [xt]
  "check if a paren from 'xt' is under the cursor and return data like search"
  (let [c (b.char)]
    (each [k v (pairs xt)]
      (when (or (= c k) (= c v))
        (let [d {:c c
                 :p (b.get-cu)}]
          (lua "return d"))))))

(fn parsearch [xt v ...]
  "look for first matching paren from 'xt' of type 'v' (-1 for open, +1 for closed)"
  (let [cpos (b.get-cu)
        counts (parsearch-counts xt v)]
    (var r "")
    (while (= r "")
      (print r)
      (let [d (b.search (re xt) ...)]
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
      (b.set-cu cpos)
      r)))

(fn M.form [xt]
  "find appropriate form of parens 'xt' and return its x and y coords"
  (let [xt (or xt {"(" ")" "[" "]" "{" "}"})
        cpos (b.get-cu)
        d1 (or (par-oncu xt)
               (parsearch xt -1 "bW")
               (b.search (re xt :only-open) "zW" (vim.fn.line ".")))]
    (if d1
      (let [xt2 (. p d1.c :d)
            v2 (* -1 (. p d1.c :v))
            f2 (if (= -1 v2) "bW" "zW")
            d2 (parsearch xt2 v2 f2)]
        (if d2
          (let [(x y) (if (= -1 v2) (values d2.p d1.p) (values d1.p d2.p))]
            (b.set-cu cpos)
            {:x x :y y})
          (b.set-cu cpos)))
      (b.set-cu cpos))))

(setmetatable
  M {:__call (fn [_ ...] (M.form ...))})

M
