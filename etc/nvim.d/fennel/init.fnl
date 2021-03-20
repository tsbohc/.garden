(module init
  {require {settings config.settings}})


; TODO: V.keys (instead of V.norm)
; or maybe, maybe... I should do a macro library with suff like set-, keys- and other?
; (set- :number)

; build up V
;; {{{
;(global V {})
;;(set V.se (require :V.se)) ; ha, who need manual assembly
;
;(fn glob [path]
;  (nvim.fn.glob path true true true))
;
;(var fennel-path
;  (.. (nvim.fn.stdpath "config") "/fnl/"))
;
;(var v-modules
;  (glob (.. fennel-path "V/*.fnl")))
;
;(each [_ v (ipairs v-modules)]
;  (var m (v:gsub fennel-path ""))
;  (set m (m:gsub ".fnl" ""))
;  (set m (m:gsub "/" "."))
;  (var name (m:gsub "V." ""))
;  (tset V name (require m)))
;; }}}

; run the config
;(require :config.settings)
;(require :config.mappings)

; insert function into a table
;(fn t.foo []
;  (print "bar"))
