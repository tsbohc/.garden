(module init
  {require {z zest.lib}})

(global _Z {})
(tset _Z :fn {})

; load everything
(->> (z.glob (.. z.config-path "/lua/rc/*.lua"))
     (z.run!
       #(require (string.gsub $1 ".*/(.-)/(.-)%.lua" "%1.%2"))))
