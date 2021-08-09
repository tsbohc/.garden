(require-macros :zest.lime.macros)

(def-keymap [nvo] :<c-m> (fn [] (print "m")))
;(def-keymap [nvo] :<c-k> ":echo 'k'")

;(set _G._zest {:user {:# 1}})

;(local v1 (vlua (fn [])))
;(local v2 (vlua ":call %s()<cr>" (fn [])))

;(print v1)
;(print v2)

42
