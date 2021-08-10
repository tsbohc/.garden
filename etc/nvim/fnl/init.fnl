;        .
;  __   __)
; (. | /o ______  __  _.
;    |/<_/ / / <_/ (_(__
;    |
;

;(require :test)
;(require :sandbox)

(let [zest (require :zest)
      h vim.env.HOME]
  (zest.setup
    {:target (.. h "/.garden/etc/nvim/lua")
     :source (.. h "/.garden/etc/nvim/fnl")}))

(import-macros
  {:vlua-format   vlua.format
   :def-keymap-fn ki.fn-
   :def-keymap    ki.no-} :zest.macros)

(local modules
  [:core.options
   :core.keymaps
   :core.autocmds
   :statusline
   :textobjects
   :operators
   :plugins
   :sandbox
   ])

; ░▒▓█

;(local autoload (require :autoload))

(each [_ m (ipairs modules)]
  (let [(ok? out) (pcall require m)]
    (when (not ok?)
      (print (.. "error while loading '" m "':\n" out)))))

(require-macros :zest.macros)

;(def-keymap-fn "<c-f>" [n]
;  (vim.cmd ":e scratch.fnl")
;  (vim.cmd ":w")
;  (vim.cmd ":split")
;  (vim.cmd ":term ls scratch.fnl | entr -sc 'fennel --compile scratch.fnl'"))



;(def-keymap :<c-m> [v]
;  (vfn ":call %s(visualmode())<cr>" [x]
;    (print x)))


;; functions
;(test ,(fn []))
;(test ,my_function)
;
;; strings
;(test my_string)
;(test (.. "_" my_string))

; FIXME cannot be aliased
;(import-macros {:zest-fn zfn} :zest.macros)

;(def-keymap :<c-m> [nvo]
;  [(fn []
;     (print "fn"))])

;(test (fn [] print ya))

;(def-keymap :<c-m [nvo]
;  [(print 1)
;   (print 2)])

; (test [[(print "woo")]]) ; TODO bind this as an fn?

;(def-autocmd [InsertLeave BufEnter FocusGained] *
;  [(fn [] (if (not= (vim.fn.mode) :i)
;            (se= cursorline)))])
;
;(def-keymap e [nv :expr]
;  [#(if (> vim.v.count 0) "k" "gk")])

;(def-keymap :<c-m> [nvo]
;  [(fn [] (print "fn"))])
;
;(def-keymap :<c-m> [nvo]
;  [my_function])
;
;(def-keymap <c-m> [nvo]
;  my_string)



;(def-keymap :<c-m> [nvo]
;  ,(fn []
;     (print)))
;
;(def-keymap :<c-m> [nvo] "echo")
;
;(def-keymap :<c-m> [nvo] =>
;  (local x 1)
;  (print x))
;
;(def-keymap :<c-m> [nvo] -> [x]
;  (print x))


;(test ,my_fn)
;(test (fn []))

; just a :lua only :fnl without completion
;(def-command-fn :Fnl [s]
;  (let [f (require :zest.fennel)]
;    (f.eval s)))
;(vim.cmd "cnoreabbrev fnl Fnl")

;(def-command-fn :None []
;  (print "no args"))
;
;(def-command-fn :Single [x]
;  (print (.. "'" x "'")))
;
;(def-command-fn :MyCmd [...]
;  (print (+ a 1)))

;(def-keymap-fn :<c-m> [n]
;  (print (+ a 1)))
;(local f (require :zest.fennel))



; zesty hl?
;(fn hl-link [ls rs]
;  (vim.api.nvim_command (.. "hi! link " ls " " rs)))






;(fn compiled-fennel [path]
;  (when path
;    (let [handle (assert (io.popen (.. "fennel --add-fennel-path '/home/sean/code/zest/fnl/?.fnl' --compile " path)))
;          output (handle:read "*a")]
;      (values output (. [(handle:close)] 1)))))
;
;(fn put [s]
;  (if  (vim.fn.setreg "a" s "l")
;  (vim.cmd "norm! \"ap")))
;
;(def-keymap-fn :<c-f> [n]
;  (let [(code status) (compiled-fennel (vim.fn.expand "%:p"))]
;    (print status)
;    (if (= (vim.fn.bufnr "compiled") -1)
;      (do
;        (vim.cmd ":vs compiled")
;        (vim.cmd "setlocal buftype=nofile")
;        (vim.cmd "setlocal noswapfile")
;        (vim.cmd "setlocal ft=lua")
;        (put code)
;        (vim.cmd "noautocmd wincmd p"))
;      (do
;        (vim.cmd "noautocmd wincmd p")
;        (vim.cmd "norm! ggVGd")
;        (put code)
;        (vim.cmd "noautocmd wincmd p")))))

(vim.api.nvim_exec
  "
  fun! Runcmd(cmd)
  silent! exe 'topleft vertical pedit previewwindow '.a:cmd
  noautocmd wincmd P
  set buftype=nofile
  set ft=lua
  exe 'noautocmd r! '.a:cmd
  noautocmd wincmd p
  endfun
  com! -nargs=1 Runcmd :call Runcmd('<args>')

  fun! MyRun()
  exe 'w'
  :silent call Runcmd(\"fennel --correlate --add-package-path '/home/sean/code/zest/lua/?.lua' --add-fennel-path '/home/sean/code/zest/fnl/?.fnl' --metadata \" . expand('%:p'))
  endfun

  fun! Zct()
  exe 'w'
  :silent call Runcmd(\"fennel --compile --add-package-path '/home/sean/code/zest/lua/?.lua' --add-fennel-path '/home/sean/code/zest/fnl/?.fnl' --metadata \" . expand('%:p'))
  endfun

  nnoremap <c-c> :call MyRun()<cr>
  nnoremap <c-t> :call Zct()<cr>" false)




;(import-macros {:let-g g-} :zest.macros)
;
;(g- python_host_prog  :/usr/bin/python2)
;(g- python3_host_prog :/usr/bin/python3)
;


42
