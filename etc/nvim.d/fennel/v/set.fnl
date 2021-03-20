;(fn get-scope [option]
;  `(if (pcall vim.api.nvim_get_option_info ,option)
;     (. (vim.api.nvim_get_option_info ,option) :scope)))
;
;(fn set-option [scope option value]
;  `(let [option# (or ,option :_)]
;     (match ,scope
;       :global (vim.api.nvim_set_option option# ,value)
;       :win    (vim.api.nvim_win_set_option 0 option# ,value)
;       :buf    (vim.api.nvim_buf_set_option 0 option# ,value)
;       _#      (print (.. "V.se: option " option# " not found")))))
;
;(fn s- [option value]
;  `(let [o# ,(tostring option)
;         s# (get-scope o#)
;         v# (or ,value true)]
;     (if s#
;       (set-option s# o# v#))))
;
;{:get-scope get-scope
; :set-option set-option
; :s- s-}
