(require-macros :zest.macros)

(local M {})

(fn M.char [d]
  "get character under cursor"
  (let [d (or d 0)
        l (vim.fn.getline ".")
        n (+ d (vim.fn.col "."))]
    (vim.fn.strcharpart (l:sub n n) 0 1)))

(fn M.search [re ...]
  "search for 're' and return character under cursor and position"
  (let [p (vim.fn.searchpos re ...)]
    (match p [0 0] nil _ {:c (M.char) :p [0 (. p 1) (. p 2) 0]})))

(fn M.get-cu []
  "get cursor position"
  (vim.fn.getpos "."))

(fn M.set-cu [p]
  "set cursor position"
  (vim.fn.setpos "." p)
  nil)

(fn M.textobject [d modifier]
  (let [x (?. d :x)
        y (?. d :y)]
    (when (and x y)
      (match modifier
        :inner
        (do
          (M.set-cu y)
          (norm- "hv")
          (M.set-cu x)
          (norm- "l"))
        :outer
        ; on the same line, select until the next non-whitespace character
        ; or previous, if we're at the end of a line or there's no whitespace to the right
        (do
          (M.set-cu y)
          (let [line-len (vim.fn.strwidth (vim.fn.getline "."))
                at-end? (or (= (. y 3) line-len) (not= (M.char 1) " "))]
            (when (and (not at-end?)
                       (not= 0 (vim.fn.search "\\S" "zW" (vim.fn.line "."))))
              (norm- "h"))
            (norm- "v")
            (M.set-cu x)
            (when (and at-end?
                       (not= 0 (vim.fn.search "\\S" "bW" (vim.fn.line "."))))
              (norm- "l"))))
        _
        (do
          (M.set-cu y)
          (norm- "v")
          (M.set-cu x))))))

M
