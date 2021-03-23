(module init
  {require {z zest.lib}})

; prep
(global _Z {})
(tset _Z :fn {})

; TODO: put this somewhere else
(global Z
  {
   :norm
   (fn [cmd]
     (vim.api.nvim_command (.. "norm! " cmd)))

   ; i should really index as fn this so that
   ; (Z.exec.wimcmd :L) and etc worked
   :exec
   (fn [cmd]
     (vim.api.nvim_command cmd))

   :eval
   (fn [str]
     (vim.api.nvim_eval str))
   })

; load everything
(->> (z.glob (.. z.config-path "/lua/rc/*.lua"))
     (z.run! #(require (string.gsub $1 ".*/(.-)/(.-)%.lua" "%1.%2"))))
