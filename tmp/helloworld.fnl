; getting my feet wet
;(let [ max 100
;      step 5]
;  (var sum 0)
;  (for [i 0 max step]
;    (set sum (+ sum i))
;    (print i))
;  (print (.. "sum: " sum)))

; looks okay-ish
(fn count-sum [max step]
  (var sum 0)
  (for [i 0 max step]
    (set sum (+ sum i)))
  sum)

(print (count-sum 10 1))














;"exec" (fn [a] (+ a 1))
;
;"norm" (fn [cmd] (vim.api.nvim_command (.. "norm! " cmd)))
;
;(let [V {}]
;  (V.exec (fn [a] (+ a 1)))
;)
;
;(fn get_type [index] 
;  (if (pcall (vim.api.nvim_get_option index))
;    "o"
;    (pcall (vim.api.nvim_win_get_option 0 index))
;    "wo"
;    (pcall (vim.api.nvim_buf_get_option 0 index))
;    "bo"
;    "none")
;)

