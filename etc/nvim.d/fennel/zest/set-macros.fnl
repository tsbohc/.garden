{:s-
 (fn [option value]
   `(s.set-option ,(tostring option) ,value))}

;{
;:nil?
;(fn [value]
;  (= value nil))
;
;:get-scope
;(fn [option]
;  `(when (pcall vim.api.nvim_get_option_info ,option)
;     (. (vim.api.nvim_get_option_info ,option) :scope)))
;
;:set-option
;(fn [scope option value]
;  `(let [option# (or ,option :_)]
;     (match ,scope
;       :global (vim.api.nvim_set_option       option# ,value)
;       :win    (vim.api.nvim_win_set_option 0 option# ,value)
;       :buf    (vim.api.nvim_buf_set_option 0 option# ,value)
;       _#      (print (.. "zest.s- invalid scope '" scope# "' for option '" option# "'")))))
;
;:s-
;(fn [option value]
;  `(let [o# ,(tostring option)
;         s# (get-scope o#)
;         v# (if (nil? ,value) true ,value)]
;     (if s#
;       (set-option s# o# v#)
;       (= (string.sub o# 1 2) :no)
;       (do
;         (let [o# (string.sub o# 3)
;               s# (get-scope o#)
;               v# false]
;           (if s#
;             (set-option s# o# v#)
;             (print (.. "zest.s- couldn't determine scope for option '(no)" o# "'")))))
;       (print (.. "zest.s- option '" o# "' not found")))))
;}
