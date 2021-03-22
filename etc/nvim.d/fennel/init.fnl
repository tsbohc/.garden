(module init
  {require {settings rc.settings
            mappings rc.keymaps
            test rc.test}})

;        .
;  __   __)
; (. | /. ______  __  _.
;    |/<_/ / / <_/ (_(__
;    |
;

(global Z
  {
   :norm
   (fn [cmd]
     (vim.api.nvim_command (.. "norm! " cmd)))

   :exec
   (fn [cmd]
     (vim.api.nvim_command cmd))

   :eval
   (fn [str]
     (vim.api.nvim_eval str))
   })

(fn Z.norm [c]
  (vim.api.nvim_command (.. "norm! " c)))

; {{{
;(fn get-callable-index-table [callback]
;  "translates callback(parameter) to table.parameter()"
;  (setmetatable
;    {} {:__index
;        (fn [self index]
;          (tset self index (fn [...] (callback index ...)))
;          (rawget self index))}))
; }}}
