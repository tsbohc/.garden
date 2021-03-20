;(map.n <c-h> <c-w>h)

; smart v-line movement
;(map.n expr :n #(if (> vim.v.count 0) :j :gj))
;(map.n expr :e #(if (> vim.v.count 0) :k :gk))

(module v-map
  {require {a aniseed.core
            gcit lib.get-callable-index-table}})

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
