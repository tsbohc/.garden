(module zest.keys
  {require {z zest.lib}
   require-macros [zest.macros]})

(var _id 0)

(defn- set-keymaps [modes options lhs rhs]
  (each [mode (modes:gmatch ".")]
    (vim.api.nvim_set_keymap mode lhs rhs options)))

(defn- map-keys [modes ...]
  (let [params [...]
        rhs (table.remove params)
        lhs (table.remove params)
        params (unpack params)]

    (var opts {:noremap true})
    (if (z.full? params)
      (each [_ o (ipairs params)]
        (if (= o :remap)
          (tset opts :noremap false)
          (tset opts o true))))

    ; it's very important to have :call v:lua.functions() for non-expressions
    (if (z.string? rhs)
      (set-keymaps modes opts lhs rhs)
      (let [cm (if opts.expr
                 (reg-fn rhs)
                 (.. ":call " (reg-fn rhs) "<cr>"))]

        (set-keymaps modes opts lhs cm)))))

(let [k (z.index-as-method map-keys)]
  (fn k.leader [key]
    (set vim.g.mapleader key))
  k)
