(global inspect (require :inspect))

(var colo "kohi")
(var font "fira")
(var font-size 12)

(fn alacritty [varsets links]
  (print (inspect varsets))
  (print (inspect links)))

(fn req [a]
  a)

(alacritty
  [colo font { : font-size }]
  [:alacritty.yml "~/.config/alacritty/alacritty.yml"])

(alacritty
  (l- "alacritty.yml" (.. conf "alacritty/alacritty.yml")))
  (<= colo "literal" { : font-size })

(doto "alacritty"
  (: :link "alacritty.yml" (.. conf "alacritty/alacritty.yml")))

;(blossom #(let [font_size 12]
;  (alacritty [colo font  {: font_size }]
;             [:alacritty.yml :~/.config/alacritty/alacritty.yml])
;
;  ))

;(require-macros :macros)
;(global inspect (require :inspect))
;
;
;(var cherry (require :cherry))
;(cherry.begin
;  #(print "wooo"))
;
;; cherry
;; --------------
;
;(var cherry {})
;
;(fn link [link-id varsets]
;  (print link-id)
;  (print (inspect varsets)))
;
;(var LINKS
;  {:alacritty ["alacritty.yml" "^/alacritty.alacritty.yml"]})
;
;; blossom
;; --------------
;
;(fn cherry.blossom []
;  (global colo "kohi")
;
;  (lyn alacritty [colo]
;       (sh [yay -S alacritty]
;           [echo "installed alacritty"]))
;
;  (lyn bspwm)
;  (lyn sxhkd)
;
;
;  )
;
;;(cherry.blossom)


























;(require-macros :macros)
;(var z (require :lib))
;(global yaml (require :lyaml))
;
;(fn load-config []
;  (with-open [f (io.open "test.yml" :rb)]
;             (yaml.load (f:read "*all"))))
;
;(var config (load-config))
;
;(print (inspect config))

;(var VARSETS
;  [:fg {:v "E4D6C8" :s "kohi"}])
;
;(fn get-var [varname]
;  (. VARSETS :test))
;
;(fn def-set [name xs]
;  (each ))
;
;(def-set :kohi
;  {:fg "E4D6C8" :bg "2b2b2c"})



;(fn index-as-method [callback]
;  "translates callback(parameter) to table.parameter()"
;  (setmetatable
;    {} {:__index
;        (fn [self index]
;          (tset self index (fn [...] (callback index ...)))
;          (rawget self index))}))
;
;(fn shell [command ...]
;  (with-open [handle (io.popen (.. command " " (z.flatten [...] " ")))]
;             (let [result (handle:read "*a")]
;               result)))
;
;(var sh (index-as-method shell))
;
;; ideally, i want this:
;;(sh.yay -S wooo)
;; and piping with (->>) macro
;; but, quoting stuff will be awful due to "" being lost
;
;
