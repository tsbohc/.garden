(require-macros :zest.macros)

(print "v-lua -------------------------------------------------------------------")

(fn my-fn [])
(local v (v-lua my-fn))

(print "v-lua set-option -------------------------------------------------------------------")

; i need to test this
(fn my-fold-fn [])
(set-option foldtext (.. (v-lua my-fold-fn) "()"))

(print "opt-*-* -----------------------------------------------")

(opt-append listchars {:space "␣"})
(opt-local-get number)

(print "v-lua-format -----------------------------------------------")

(vim.api.nvim_command
  (v-lua-format
    ":com -nargs=* Mycmd :call %s(<f-args>)"
    (fn [...]
      (print ...))))

(print "def-keymap simple -----------------------------------------------")

(def-keymap :H [nv] "0")

(print "def-keymap lua expr -----------------------------------------------")

(each [_ k (ipairs [:h :j :k :l])]
  (def-keymap (.. "<c-" k ">") [n] (.. "<c-w>" k)))

(print "def-keymap pairs ------------------------------------------------")

(def-keymap [n]
  {:<ScrollWheelUp>   "<c-y>"
   :<ScrollWheelDown> "<c-e>"})

(print "def-keymap-fn simple ------------------------------------------------")

;(local variable-with-a-key "some-key")
;(def-keymap-fn variable-with-a-key [n]
;  (print "hello from fennel!"))

(def-keymap-fn :<c-m> [n]
  (print "hello from fennel!"))

(print "def-keymap-fn expr ------------------------------------------------")

(def-keymap-fn :k [nv :expr]
  (if (> vim.v.count 0) "k" "gk"))

(print "def-augroup ------------------------------------------------")

(def-augroup :my-augroup)

(print "def-autocmd ------------------------------------------------")

(def-autocmd "*" [VimResized] "wincmd =")

(print "def-augroup and def-autocmd-fn ------------------------------------------------")

(def-augroup :restore-position
  (def-autocmd-fn "*" [BufReadPost]
    (when (and (> (vim.fn.line "'\"") 1)
               (<= (vim.fn.line "'\"") (vim.fn.line "$")))
      (vim.cmd "normal! g'\""))))

(print "def-augroup-dirty ------------------------------------------------")

(def-augroup-dirty :my-dirty-augroup)

42
