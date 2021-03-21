;(fn map [modes ...]
;  (let [params {:modes modes
;                :rs (table.remove [...])
;                :ls (table.remove [...])}]
;    `(each [k# v# (pairs ,params)]
;       (print ,(tostring )))))

;  (let [params [...]
;        rs (table.remove params)
;        ls (table.remove params)]
;    `(let [params# ,params
;           rs# ,(tostring rs)
;           ls# ,(tostring ls)
;           modes# ,(tostring modes)]
;       (print (.. modes# ls# rs#)))))

(fn n- [b c]
  `(map- :n ,(tostring b) ,(tostring c)))


{
 :n- n-}

;(fn map [modes ...]
;  "define mappings"
;  (var options { :noremap true })
;  (var params [...])
;
;  (var rs (table.remove params))
;  (var ls (table.remove params))
;
;  (if (not (a.empty? params))
;    (each [_ o (ipairs params)]
;      (if (= o :remap)
;        (tset options :noremap false)
;        (tset options o true))))
;
;  (each [mode (modes:gmatch ".")]
;    (vim.api.nvim_set_keymap mode ls rs options)))

