;(fn da [name value]
;  `(local ,name
;     (let [v# ,value
;           t# (. *module* :aniseed/locals)]
;       (tset t# ,(tostring name) v#)
;       v#)))

;(fn dfs [t]
;  (each [_ name (ipairs ,t)]
;     (local name
;       `(let [v# 1
;              t# (. *module* :aniseed/locals)]
;          (tset t# :a v#)
;          v#))))

;(fn dfs [name value]
;  `(local ,name
;     (let [v# ,value
;           t# (. *module* :aniseed/locals)]
;       (tset t# ,name v#)
;       v#)))

;(fn dfs [t]
;  (each [_ name (ipairs t)]
;    `(local ,name
;       (let [v# 1
;             t# (. *module* :aniseed/locals)]
;         (tset t# :a v#)
;         v#))))

;(fn dfs [t]
;  `(local ,(. t 1) 42))

;(fn dfs []
;  (let [t ["a" "b"]]
;    (each [_ name (ipairs t)]
;      `(local ,name 53))))
;
;{:da da
; :dfs dfs}


;(macro s [a]
;  `(local ,(sym a) 1))

;(macrodebug (s "foo"))

;(let [str "foo"]
;  (: str :gsub "f" "w"))

;(macro lit [s]
;  `(string.gsub ,(string.gsub (string.gsub s ">" "]") "<" "[") "x" "\""))
;
;(macrodebug (lit "<<axb>>"))

;(print "<<ab>>")

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



 :m-def
 (fn [a]
   `(local ,(sym a) 1))

 :magic ; i'd rather not have this every time map-keys is called
 (fn [t]
   (var z (require :aniseed.core))
   (var size (z.count t))
   (var a [])
   (for [i 1 size]
     (tset _G `,(tostring (. t i)) 1)))

 ;:magic ; i'd rather not have this every time map-keys is called
 ;(fn [t]
 ;  (var z (require :aniseed.core))
 ;  (var size (z.count t))
 ;  (var a [])
 ;  (for [i 1 size]
 ;    (table.insert a `,(tostring (. t i))))
 ;  a)

