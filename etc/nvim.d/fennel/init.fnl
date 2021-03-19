(module init
  {require {a aniseed.core
            c aniseed.compile
            nvim aniseed.nvim}})
;           V V.init


; TODO: V.keys (instead of V.norm)
; or maybe, maybe... I should do a macro library with suff like set-, keys- and other?
; (set- :number)

; build up V
(global V {})
;(set V.se (require :V.se)) ; ha, who need manual assembly

(fn glob [path]
  (nvim.fn.glob path true true true))

(var fennel-path
  (.. (nvim.fn.stdpath "config") "/fnl/"))

(var v-modules
  (glob (.. fennel-path "V/*.fnl")))


(each [_ v (ipairs v-modules)]
  (var m (v:gsub fennel-path ""))
  (set m (m:gsub ".fnl" ""))
  (set m (m:gsub "/" "."))
  (var name (m:gsub "V." ""))
  (tset V name (require m)))




; run the config
(require :config.settings)
(require :config.mappings)




;(map.n :<c-h> :<c-w>h)

; smart v-line movement
;(map.n expr :n #(if (> vim.v.count 0) :j :gj))
;(map.n expr :e #(if (> vim.v.count 0) :k :gk))

;(fn wrapper [method]
;  (method))
;
;(global test -10)
;(print (wrapper #(if (> test 0) :j :gj)))





; set nested values 
;(tset t fruit apple true)
;(set t.vegetables true)

; insert function into a table
;(fn t.foo []
;  (print "bar"))


;(fn get-scope [index]
;  "attempt to determine the scope of the option passed"
;  (if (pcall vim.api.nvim_get_option index)
;    "o"
;    (pcall vim.api.nvim_win_get_option 0 index)
;    "wo"
;    (pcall vim.api.nvim_buf_get_option 0 index)
;    "bo"
;    "none"))
;
;(fn _set [index value]
;  "set the option to the specified value"
;  (let [scope (get-scope index)]
;    (if value
;      (tset vim scope index value)
;      (tset vim scope index true))))

