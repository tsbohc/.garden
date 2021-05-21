;(module zest.set)
;
;(defn- nil? [value]
;  (= value nil))
;
;(defn- get-scope [option]
;  (when (pcall vim.api.nvim_get_option_info option)
;    (. (vim.api.nvim_get_option_info option) :scope)))
;
;(defn- set-option-in-scope [scope option value]
;  (let [option (or option :_)]
;    (match scope
;      :global (vim.api.nvim_set_option       option value)
;      :win    (vim.api.nvim_win_set_option 0 option value)
;      :buf    (vim.api.nvim_buf_set_option 0 option value)
;      _      (print (.. "zest.s- invalid scope '" scope "' for option '" option "'")))))
;
;(defn set-option [option value]
;  (let [scope (get-scope option)
;        value (if (nil? value) true value)]
;    (if scope
;      (set-option-in-scope scope option value)
;      (= (: option :sub 1 2) :no)
;      (do
;        (let [option (: option :sub 3)
;              scope (get-scope option)
;              value false]
;          (if scope
;            (set-option-in-scope scope option value)
;            (print (.. "zest.s- couldn't determine scope for option '(no)" option "'")))))
;      (print (.. "zest.s- option '" option "' not found")))))
