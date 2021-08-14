;; bootstrap

(let [packer-path (.. (vim.fn.stdpath "data")
                      "/site/pack/packer/opt/packer.nvim")]
  (when (> (vim.fn.empty (vim.fn.glob packer-path)) 0)
    (vim.fn.system [:git :clone
                    "https://github.com/wbthomason/packer.nvim"
                    packer-path])
    ))

;; require

(vim.cmd "packadd packer.nvim") ; packer is opt
(local (ok? packer) (pcall require :packer))

(when ok?
  (let [plugins (require :plugins)]
    (packer.startup (fn []
                      (lua "use { 'wbthomason/packer.nvim', opt = true }")
                      (each [_ p (ipairs plugins)]
                        (use p))))))
