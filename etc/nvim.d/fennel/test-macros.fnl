;(var M {})
;
;(fn m-fn [name ...]
;  `(local ,name ,...))
;  ;`(do
;  ;   (local ,name (fn ,name ,...))
;  ;   (tset M ,(tostring name) ,name)))
;
;(fn d- [name value]
;  `(local ,name
;     (let [v# ,value
;           t# ,M]
;       (tset t# ,(tostring name) v#)
;       v#)))
;
;(d- a 1)
;
;
;;(m-fn foo []
;;  `"foo from a macro")
;
;
;
;M
