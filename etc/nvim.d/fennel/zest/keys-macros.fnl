{
 :keys.tidy-up
 (fn []
   `(do
      (tset _G :expr nil)
      (tset _G :silent nil)
      (tset _G :remap nil)))

 :get-cmd
 (fn [id]
   `(.. "v:lua._Z.maps." ,id "()"))

 :reg-fn
 (fn [id ...]
   "register a lua function in a global table _Z.maps under id
   return the corresponding vim :command"
   `(do
      (tset _G :_Z :maps ,id ,...)
      (get-cmd ,id)))

 :def-cmd
 (fn [name ...]
   "declare a lua function, register it, and bind it to a corresponding vim :command"
   `(local ,name
      (let [f# (fn ,...)]
        (reg-fn ,(tostring name) f#)
        (vim.api.nvim_command (.. "com! " ,(tostring name) " :lua _Z.maps." ,(tostring name) "()"))
        f#)))
}
