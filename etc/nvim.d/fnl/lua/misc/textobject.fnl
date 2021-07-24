(local cursor (require :misc.cursor))

(local M {})

(fn normal! [s]
  (vim.api.nvim_command (.. "norm! " s)))

(fn M.textobject [kind x y]
  ;(print (vim.inspect x))
  ;(print (vim.inspect y))
  (when (and x y)
    (match kind
      :inner
      (do
        (cursor.set y)
        (normal! "v")
        (cursor.set x))
      :inside
      (do
        (cursor.set y)
        (normal! "hv")
        (cursor.set x)
        (normal! "l"))
      :around
      ; on the same line, select until the next non-whitespace character
      ; or previous, if we're at the end of a line or there's no whitespace to the right
      (do
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
            (normal! "l")))))))

(setmetatable
  M {:__call
      (fn [_ ...]
        (M.textobject ...))})

M
