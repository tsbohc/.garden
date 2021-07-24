(require-macros :zest.macros)

(vim.api.nvim_command
  (vlua-format
    ":com -nargs=* Mycmd :call %s(<f-args>)"
    (fn [...]
      (print ...))))

42
