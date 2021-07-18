(local concord (require :lib.concord))

(local modules
  [:entity :component :system :world])

(each [_ m (ipairs modules)]
  (each [k v (pairs (. concord m))]
    (when (and (= (type v) :function)
               (not= (k:sub 1 2) "__"))
      (print (.. "ecs." m "." k)))))
