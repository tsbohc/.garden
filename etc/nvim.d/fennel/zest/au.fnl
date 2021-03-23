(module zest.au
  {require {z zest.lib}
   require-macros [zest.macros]})

(var au-id 0)

(defn set-au [events filetypes action]
  (let [events (z.flatten events ",")
        filetypes (z.flatten filetypes ",")
        body (if (z.function? action)
               (.. "au " events " " filetypes " " (.. ":call " (reg-fn action)))
               (.. "au " events " " filetypes " " action))]

    (set au-id (+ au-id 1))
    (z.run! z.exec [(.. "augroup " au-id) "autocmd!" body "augroup end"])))
