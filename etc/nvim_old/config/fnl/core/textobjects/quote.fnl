(local b (require :rc.textobjects.base))

(local M {})

(fn re [xs]
  (.. "\\V" (table.concat xs "\\|")))

(fn M.quote [xs]
  (let [cpos (b.get-cu)
        re (re xs)
        d1 (b.search re "cbW") ; separate out
        d2 (b.search (.. "\\V" d1.c) "zW")]
    (if (and d1 d2)
      (let [x d1.p
            y d2.p]
        (values x y))
      (b.set-cu cpos))))

(setmetatable
  M {:__call (fn [_ ...] (M.quote ...))})

M
