(import-macros {:def-keymap ki-} :zest.pure.macros)
(local cursor (require :misc.cursor))

(local M {})

(fn normal! [s]
  (vim.api.nvim_command (.. "normal! " s)))

(fn M.inner [key f]
  (ki- [xo :silent] key
    [(let [(x y) (f)]
       (when (and x y)
         (cursor.set y)
         (normal! "v")
         (cursor.set x)))]))

(fn M.around [key f]
  (ki- [xo :silent] key
    [(let [(x y) (f)]
       (when (and x y)
         (cursor.set y)
         (let [line-len (vim.fn.strwidth (vim.fn.getline "."))
               at-end? (or (= (. y 3) line-len) (not= (cursor.char 1) " "))]
           (when (and (not at-end?)
                      (not= 0 (vim.fn.search "\\S" "zW" (vim.fn.line "."))))
             (normal! "h"))
           (normal! "v")
           (cursor.set x)
           (when (and at-end?
                      (not= 0 (vim.fn.search "\\S" "bW" (vim.fn.line "."))))
             (normal! "l")))))]))

(fn M.inside [key f]
  (ki- [xo :silent] key
    [(let [(x y) (f)]
       (when (and x y)
         (cursor.set y)
         (normal! "hv")
         (cursor.set x)
         (normal! "l")))]))

M
