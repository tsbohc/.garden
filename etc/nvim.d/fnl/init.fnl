;        .
;  __   __)
; (. | /o ______  __  _.
;    |/<_/ / / <_/ (_(__
;    |
;

(import-macros {:zest-config zest.config} :zest.macros)

(zest.config
  {:target (.. vim.env.HOME "/.garden/etc/nvim.d/lua")
   :source (.. vim.env.HOME "/.garden/etc/nvim.d/fnl")})

(local modules
  [:options
   :keymaps
   :autocmds
   :statusline
   :textobjects
   :operators
   :plugins])

(each [_ m (ipairs modules)]
  (let [(ok? out) (pcall require m)]
    (when (not ok?)
      (print (.. "error while loading '" m "' module:\n" out)))))

(fn my-fn []
  (print "dinosaurs"))

(require-macros :zest.macros)


;(require :misc.love-compe)

; zesty hl?
;(fn hl-link [ls rs]
;  (vim.api.nvim_command (.. "hi! link " ls " " rs)))






;(fn compiled-fennel [path]
;  (when path
;    (with-open
;      [handle (assert (io.popen (.. "fennel --compile " path)))]
;      (handle:read "*a"))))
;
;(fn put [s]
;  (vim.fn.setreg "a" s "l")
;  (vim.cmd "norm! \"ap"))
;
;(vim.cmd
;  (vlua-format
;    ":command FennelToLua :call %s()"
;    (fn []
;      (let [code (compiled-fennel (vim.fn.expand "%:p"))]
;        (if (= (vim.fn.bufnr "compiled") -1)
;          (do
;            (vim.cmd ":vs compiled")
;            (vim.cmd "setlocal buftype=nofile")
;            (vim.cmd "setlocal noswapfile")
;            (vim.cmd "setlocal ft=lua")
;            (put code)
;            (vim.cmd "noautocmd wincmd p"))
;          (do
;            (vim.cmd "noautocmd wincmd p")
;            (vim.cmd "norm! ggVGd")
;            (put code)
;            (vim.cmd "noautocmd wincmd p")))))))





;(import-macros {:let-g g-} :zest.macros)
;
;(g- python_host_prog  :/usr/bin/python2)
;(g- python3_host_prog :/usr/bin/python3)
;
