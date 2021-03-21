(fn da [name value]
  `(local ,name
     (let [v# ,value
           t# (. *module* :aniseed/locals)]
       (tset t# ,(tostring name) v#)
       v#)))

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
