(module zest.sl
  {require {z zest.lib
            au zest.au}
   require-macros [zest.macros]})

(var draw-events [:BufEnter])
(var hl-reset :LineNr)
(var order-id 0)

(defn- draw []
  (let [bufnr (vim.fn.bufnr)]
    (set vim.wo.statusline (.. "%#" hl-reset "#" (z.flatten (. _Z.sl bufnr))))))

(defn- cache [id value]
  (let [bufnr (vim.fn.bufnr)]
    (when (not (. _Z.sl bufnr))
      ; idk, easier to do this than handle nils
      (tset _Z.sl bufnr ["" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" ]))
    (if value
      (tset _Z.sl bufnr id value)
      (tset _Z.sl bufnr id ""))))

(defn- format [input options]
  (var output (or input ""))
  (when (and options (not= output ""))
    (set output (.. (: " " :rep (. options 3)) output))
    (set output (.. output (: " " :rep (. options 4))))
    (when (. options 5)
      (set output (.. "%#" (. options 5) "#" output "%#" hl-reset "#")))
    (set output (.. (: " " :rep (. options 1)) output))
    (set output (.. output (: " " :rep (. options 2)))))
  output)

(defn add [events options action]
  (when events
    (set draw-events (z.concat draw-events events)))

  ; we need ids as add is called, not when autocmds fire
  (set order-id (+ order-id 1))
  (var id order-id)

  (if (z.string? action)
    (au.set-au [:BufEnter] "*" #(let [output (format action options)] (cache id output)))
    (au.set-au events "*" #(let [output (format (action) options)] (cache id output)))))

(defn init []
  (set draw-events (z.uniq draw-events))
  (au.set-au draw-events "*" #(draw)))

; NOTES:
; we're settings vim.wo.statusline to a processed string, not a function, on
; certain events

; why?

; if we did something like this, test woulb be run constantly! which we don't need,
; as internals like p% are updated anyway
;(fn test []
;  (print "updated"))
;
;(var sl-cmd (.. "%!" (reg-fn test)))
;
;(au- [BufEnter] *
;     #(se- statusline sl-cmd))
