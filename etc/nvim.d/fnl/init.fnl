;        .
;  __   __)
; (. | /o ______  __  _.
;    |/<_/ / / <_/ (_(__
;    |
;

(require-macros :zest.macros)

(g- python_host_prog :/usr/bin/python2)
(g- python3_host_prog :/usr/bin/python3)

(require :rc.plugins)
(require :rc.options)
(require :rc.keymaps)
(require :rc.aucmds)
(require :rc.excmds)


; TODO
; zest should bind string right away with api when a literal string is passed

(fn make-me-suffer [s]
  (var i 0)
  (s:gsub "." (fn [c] (when (not= c " ") (set i (+ 1 i)) (if (= 0 (% i 2)) (c:upper) (c:lower))))))

(fn comment-op [do? s t]
  (let [(x y) (vim.bo.commentstring:match "(.-)%s+(.-)")
        do-comment (fn [l] (if (and (not= "\n" l)) (.. x " " l)))
        un-comment (fn [l] (l:gsub (.. "^(%" x "%s?)") ""))]
    (s:gsub "(.-\n)" (if do? do-comment un-comment))))

(op- "gu" (partial comment-op false))
(op- "gc" (partial comment-op true))
