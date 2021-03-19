(module v-map
  {require {a aniseed.core
            gcit lib.get-callable-index-table}})

;(defn- pop [t index]
;  "pop element on index from the table and return it"
;  (when t
;    (tset t index nil)))
;
;(defn- poplast [t]
;  "pop last element from the table and return it"
;  (when t
;    (tset t (a.count t) nil)))

(defn- callback [modes ...]
  "define mappings"
  (var options { :noremap true })
  (var params [...])

  (var rs (table.remove params))
  (var ls (table.remove params))

  (if (not (a.empty? params))
    (each [_ o (ipairs params)]
      (if (= o :remap)
        (tset options :noremap false)
        (tset options o true))))

  (each [mode (modes:gmatch ".")]
    (vim.api.nvim_set_keymap mode ls rs options)))


(gcit callback)
