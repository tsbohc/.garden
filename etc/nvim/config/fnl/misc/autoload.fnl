; curtesy of Olical/aniseed

(local M {})

(fn M.autoload [name]
  (let [store {:content false}]
    (fn ensure []
      (if (. store :content)
        (. store :content)
        (let [m (require name)]
          (tset store :content m)
          m)))

    (setmetatable
      store

      {:__call
       (fn [t ...]
         ((ensure) ...))

       :__index
       (fn [t k]
         (. (ensure) k))

       :__newindex
       (fn [t k v]
         (tset (ensure) k v))})))

(setmetatable
  M {:__call (fn [_ ...] (M.autoload ...))})

M
