(module zest.keys
  {require {z zest.lib}
   require-macros [zest.keys-macros]})

(defn- set-keymaps [modes options lhs rhs]
  ;(print (.. modes ": '" lhs "' - '" rhs "'"))
  ;(print (vim.inspect options))
  (each [mode (modes:gmatch ".")]
    (vim.api.nvim_set_keymap mode lhs rhs options)))

(defn- new-id []
  (let [id (.. "map" (z.count _G._Z.maps))]
    id))

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

    (if (z.string? rhs)
      (set-keymaps modes opts lhs rhs)
      (let [id (new-id)
            cm (reg-fn id rhs)]
        (set-keymaps modes opts lhs cm)))))

(tset _G :_Z {})
(tset _G :_Z :maps {})

(tset _G :expr :expr)
(tset _G :silent :silent)
(tset _G :remap :remap)

(let [k (z.index-as-method map-keys)]
  (fn k.leader [key]
    (set vim.g.mapleader key))
  k)
