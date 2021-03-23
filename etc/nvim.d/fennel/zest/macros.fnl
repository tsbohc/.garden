; zest macros as a single module because it's convenient and i did't want to
; track everything and pollute config dirs
; woo
; note to self: don't try to create a macro that creates macros: your brain will hurt and then you'll realise you can't require-macros in this file

; prep

(fn sym-tostring [x]
  "convert variable's name to string"
  `,(tostring x))

; TODO: rewrite with let
(fn tab-tostring [xs]
  "convert table with var-names to table with strings"
  (var z (require :aniseed.core))
  (var size (z.count xs))
  (var a [])
  (for [i 1 size]
    (table.insert a `,(tostring (. xs i))))
  a)

; au

(fn au- [events filetypes action]
  "autocmd input parser"
  (var t [])
  (tset t 1 (if (= (type events) :table)
             (tab-tostring events)
             [(sym-tostring events)]))
  (tset t 2 (if (= (type filetypes) :table)
             (tab-tostring filetypes)
             [(sym-tostring filetypes)]))
  (tset t 3 action)
  `(au.set-au ,(unpack t)))

; keys
; TODO: redo with a parser like autocmds

(fn keys-begin []
  `(local (,(sym :expr) ,(sym :silent) ,(sym :remap)) (values :expr :silent :remap)))

(fn reg-fn [...]
  "register a lua function in a global table _Z.maps under id
  return the corresponding vim :command"
  `(let [z# (require :zest.lib)
         id# (.. "__" (z#.count _Z.fn))]
     (tset _G :_Z :fn id# ,...)
     (.. "v:lua._Z.fn." id# "()")))

(fn def-cmd [name ...]
  "declare a lua function, register it, and bind it to a corresponding vim :command"
  `(local ,name
     (let [f# (fn ,...)
           cmd# (.. "com! " ,(tostring name) " :call " (reg-fn f#))]
       (vim.api.nvim_command cmd#)
       f#)))

; set

; TODO: could i possible preparse the input to the point where i just return
; [scope option value]? no-opts included?
(fn se- [option value]
  `(se.set-option ,(tostring option) ,value))

{
 : au-
 : keys-begin
 : reg-fn
 : def-cmd
 : se-
 }
