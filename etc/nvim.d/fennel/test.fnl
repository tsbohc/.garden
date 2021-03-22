 ;:magic ; i'd rather not have this every time map-keys is called
 ;(fn [t]
 ;  (var z (require :aniseed.core))
 ;  (var size (z.count t))
 ;  (var a [])
 ;  (for [i 1 size]
 ;    (table.insert a `,(tostring (. t i))))
 ;  a)




;(def-cmd Test []
;  (print "call test from command line"))

;(var id "Aaa")
;(var f (fn [] (print "fe")))
;(var cmd (reg-fn id f))
;(print cmd)



