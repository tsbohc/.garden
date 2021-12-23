(local M {})

(fn M.get []
  "get cursor position"
  (vim.fn.getpos "."))

(fn M.set [p]
  "set cursor position"
  (vim.fn.setpos "." p)
  nil)

(fn M.char [d]
  "get character under cursor"
  (let [d (or d 0)
        l (vim.fn.getline ".")
        n (+ d (vim.fn.col "."))]
    (vim.fn.strcharpart (l:sub n n) 0 1)))

(fn M.search [re ...]
  "search for 're' and return character under cursor and position"
  (let [p (vim.fn.searchpos re ...)]
    (match p
      [0 0] nil
      _ {:c (M.char) :p [0 (. p 1) (. p 2) 0]})))

M
