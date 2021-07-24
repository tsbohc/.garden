(import-macros
  {:def-keymap-fn ki.fn-} :zest.macros)

(local compe (require :compe))

(compe.setup
  {:enabled true
   :autocomplete true
   :debug false
   :min_lenght 1
   :preselect "enable"
   :throttle_time 80
   :source_timeout 200
   :incomplete_delay 400
   :max_abbr_width 100
   :max_kind_width 100
   :max_menu_width 100
   :documentation true

   :source {:path true
            :treesitter true
            :buffer true
            :nvim_lsp true
            :calc true
            :ultisnips true
            :omni true
            :love true}})

(fn rtc [s]
  (vim.api.nvim_replace_termcodes s true true true))

(ki.fn- :<tab> [is :expr]
  (if (= 1 (vim.fn.pumvisible))
    (rtc "<c-n>")
    ;(= 1 (vim.api.nvim_eval "UltiSnips#CanJumpForwards()"))
    ;(rtc "<cmd>call UltiSnips#JumpForwards()<CR>")
    (rtc "<tab>")))

(ki.fn- :<s-tab> [is :expr]
  (if (= 1 (vim.fn.pumvisible))
    (rtc "<c-p>")
    ;(= 1 (vim.api.nvim_eval "UltiSnips#CanJumpBackwards()"))
    ;(rtc "<cmd>call UltiSnips#JumpBackwards()<CR>")
    (rtc "<s-tab>")))

(ki.fn- :<cr> [i :expr]
  ;(if (= 1 (vim.api.nvim_eval "UltiSnips#CanExpandSnippet()"))
  ;  (do
  ;    (if (= 1 (vim.fn.pumvisible))
  ;      ((. vim.fn :compe#close) "<c-e>"))
  ;    (rtc "<cmd>call UltiSnips#ExpandSnippet()<CR>"))
    ((. vim.fn :compe#confirm) "\n"))
