(module v-set
  {require {a aniseed.core}})

;(defn- get-scope [index]
;  "attempt to determine the scope of the option passed"
;  (if (pcall vim.api.nvim_get_option index)     :o
;    (pcall vim.api.nvim_win_get_option 0 index) :wo
;    (pcall vim.api.nvim_buf_get_option 0 index) :bo))
;
;(defn callback [index value]
;  "set the option to the specified value"
;  (var scope (get-scope index))
;  (if scope
;    (if value
;      (tset vim scope index value)
;      (tset vim scope index true))
;    (if (= (string.sub index 1 2) :no)
;      (do
;        (set scope (get-scope (string.sub index 3)))
;        (if scope
;          (tset vim scope (string.sub index 3) false)
;          (print (.. "V.se: option " index " not found"))))
;      (print (.. "V.se: option " index " not found")))))
;
;
;callback

; -- new --

; need this to check for no- options later
;(defn- is-scope-valid? [scope option]
;  (match scope
;    :o (pcall vim.api.nvim_get_option option)
;    :b (pcall vim.api.nvim_buf_get_option 0 option)
;    :w (pcall vim.api.nvim_win_get_option 0 option)))

(defn- get-scope [option]
  (if (pcall vim.api.nvim_get_option_info option)
    (. (vim.api.nvim_get_option_info option) :scope)))

; errors w/o a check

(defn set-option [option _value]
  "set internal neovim options"
  (var value _value)
  (if (= value nil)
    (set value true))
  (match (get-scope option)
    :global (vim.api.nvim_set_option option value)
    :win    (vim.api.nvim_win_set_option 0 option value)
    :buf    (vim.api.nvim_buf_set_option 0 option value)
    _ (if (= (string.sub option 1 2) :no)
        (do
          (var _scope (get-scope (string.sub option 3)))
          ;(print (.. option " " _scope))
          (when _scope
            (set-option (string.sub option 3) _value))))))

set-option
