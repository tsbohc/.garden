(fn []
  (local ts (require :nvim-treesitter.configs))
  (ts.setup
    {:highlight {:enable true}}))
