(module zest.set)

(fn nil? [value]
  (= value nil))

(fn get-scope [option]
  (when (pcall vim.api.nvim_get_option_info option)
    (. (vim.api.nvim_get_option_info option) :scope)))

(fn auto-set-option [scope option value]
  (let [option (or option :_)]
    (match scope
      :global (vim.api.nvim_set_option       option value)
      :win    (vim.api.nvim_win_set_option 0 option value)
      :buf    (vim.api.nvim_buf_set_option 0 option value)
      _      (print (.. "zest.s- invalid scope '" scope "' for option '" option "'")))))

(fn set-option [option value]
  (let [scope (get-scope option)
        value (if (nil? value) true value)]
    (if scope
      (auto-set-option scope option value)
      (= (string.sub option 1 2) :no)
      (do
        (let [option (string.sub option 3)
              scope (get-scope option)
              value false]
          (if scope
            (auto-set-option scope option value)
            (print (.. "zest.s- couldn't determine scope for option '(no)" option "'")))))
      (print (.. "zest.s- option '" option "' not found")))))

{:nil? nil?
 :get-scope get-scope
 :auto-set-option auto-set-option
 :set-option set-option}
