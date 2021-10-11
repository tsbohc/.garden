(import-macros
  {:def-keymap ki-} :zest.pure.macros)

(fn []
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

  (ki- [is :expr] :<tab>
    [(if (= 1 (vim.fn.pumvisible))
       (rtc "<c-n>")
       (rtc "<tab>"))])

  (ki- [is :expr] :<s-tab>
    [(if (= 1 (vim.fn.pumvisible))
       (rtc "<c-p>")
       (rtc "<s-tab>"))])

  (ki- [i :expr] :<cr>
    [((. vim.fn :compe#confirm) "\n")]))
