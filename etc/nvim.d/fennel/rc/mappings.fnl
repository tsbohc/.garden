(module rc.mappings
  {require-macros [zest.map-macros]})

;(local n- (fn [...] (z.map n ...)))

; so, make macro wrappers to preprocess data before function calls
(fn map- [a b c]
  (print (.. a " " b " " c)))

;(n- n j)
;(map x N J)


;(nvo- n j)
;(nvo- N J)
;(nvo- e k)
;(nvo- E K)

;(da aa "fuck")
;(print aa)
;
;(dfs)
;(print a)
;(print b)

;(woo)
;
;(each [_ name (ipairs [a b c])]
;  (def name 1))
;
;(print a)

;(n-)

;(n n j)
;(m.nvo n j)
;(m- nvo <expr> :e #(if (> vim.v.count 0) :k :gk))
