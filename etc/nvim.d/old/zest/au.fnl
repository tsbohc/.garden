(module zest.au
  {require {z zest.lib}
   require-macros [zest.macros]})

(var id 0)

(defn set-au [events filetypes action]
  (let [events (z.flatten events ",")
        filetypes (z.flatten filetypes ",")
        body (.. "au " events " " filetypes " "
                 (if (z.function? action)
                   (.. ":call " (reg-fn action))
                   action))]

    (set id (+ id 1))
    (z.run! z.exec [(.. "augroup " id) "autocmd!" body "augroup end"])))
