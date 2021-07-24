(import-macros {:def-operator op-} :zest.macros)

; commentary

(fn commentary [do? s t]
  (let [(x y) (vim.bo.commentstring:match "(.-)%s+(.-)")
        do-comment (fn [l] (if (and (not= "\n" l)) (.. x " " l)))
        un-comment (fn [l] (l:gsub (.. "^(%" x "%s?)") ""))]
    (s:gsub "(.-\n)" (if do? do-comment un-comment))))

(op- "<leader>cc" (partial commentary true))
(op- "<leader>cu" (partial commentary false))

; surround

(fn surround [s]
  (let [c (vim.fn.nr2char (vim.fn.getchar))]
    (match c
      "\"" (.. "\"" s "\"")
      "'"  (.. "'"  s  "'")
      "("  (.. "( " s " )")
      ")"  (.. "("  s  ")")
      "["  (.. "[ " s " ]")
      "]"  (.. "["  s  "]")
      "{"  (.. "{ " s " }")
      "}"  (.. "{"  s  "}")
      "<"  (.. "< " s " >")
      ">"  (.. "<"  s  ">"))))

(op- :s surround)
