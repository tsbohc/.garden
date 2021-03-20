{:get-scope
 (fn [option]
   `(if (pcall vim.api.nvim_get_option_info ,option)
      (. (vim.api.nvim_get_option_info ,option) :scope)))

 :set-option
 (fn [scope option value]
   `(let [option# (or ,option :_)]
      (match ,scope
        :global (vim.api.nvim_set_option option# ,value)
        :win    (vim.api.nvim_win_set_option 0 option# ,value)
        :buf    (vim.api.nvim_buf_set_option 0 option# ,value)
        _#      (print (.. "V.se: option " option# " not found")))))
 :s-
 (fn [option value]
   `(let [o# ,(tostring option)
          s# (get-scope o#)
          v# (or ,value true)]
      (if s#
        (set-option s# o# v#))))}


;#(if (> vim.v.count 0) :k :gk)

; macro to translate core.function to .function ?

; reference
;
; conditionals
;(when cond1
;  (block1)
;  (block1)
;  (block1))
;
;(if
;  cond1
;  (block1)
;  cond2
;  (block2)
;  (block3))
;
;(match value
;  case1 (block1)
;  case2 (block2)
;  _     (block3))
;
; variables
;(if cond1
;  (let [var1 1]
;    (print var1)))

