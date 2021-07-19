(import-macros
  {:setoption      so-
   :def-augroup    au.gr-
   :def-autocmd    au.no-
   :def-autocmd-fn au.fn-} :zest.new-macros)

(au.gr- :smart-cursorline
  ; show/hide cursorline based on window focus and mode
  (au.fn- "*" [InsertEnter BufLeave FocusLost]
    (so- cursorline false))
  (au.fn- "*" [InsertLeave BufEnter FocusGained]
    (if (not= (vim.fn.mode) :i)
      (so- cursorline))))

(au.gr- :restore-position
  ; restore last position in file
  (au.fn- "*" [BufReadPost]
    (when (and (> (vim.fn.line "'\"") 1)
               (<= (vim.fn.line "'\"") (vim.fn.line "$")))
      (vim.cmd "normal! g'\""))))

(au.gr- :flash-yank
  ; flash yanked text
  (au.fn- "*" [TextYankPost]
    (vim.highlight.on_yank {:higroup "Search" :timeout 100})))

(au.gr- :split-settings
  ; resize splits automatically
  (au.no- "*" [VimResized]
    "wincmd =")
  ; open help in vsplit
  (au.no- "help" [FileType]
    "wincmd L"))

(au.gr- :filetype-settings
  ; enable wrap for text filetypes
  (au.no- "text,latex,markdown,tex,context,plaintex" [FileType] "set wrap")
  ; tweaks for fennel and vimrc
  (au.fn- "fennel" [FileType]
    (so- iskeyword:remove ".")
    (so- lispwords:append [:au.no- :au.fn- :au.gr-
                           :ki.no- :ki.fn-
                           :so-])))

;(au- [FileType] "fennel"
;     (fn [] (se- lispwords (.. vim.o.lispwords (table.concat [:when-not :if-not] ",")))))

;(au- [FileType] "fennel"
;     (fn [] (so- iskeyword- ".")))

; dumb stuff

;(fn get-cu []
;  "get cursor position"
;  (vim.fn.getpos "."))
;
;(fn set-cu [p]
;  "set cursor position"
;  (vim.fn.setpos "." p)
;  nil)
;
;(au- [InsertCharPre] "*"
;     (fn []
;       (let [trigger-chars {" " true "," true "." true}]
;         (when (. trigger-chars vim.v.char)
;           (local cu-end (get-cu))
;           (vim.api.nvim_command "norm! B")
;           (local cu-beg (get-cu))
;           (let [cword (vim.fn.expand "<cWORD>")]
;             (print cword)
;             (set-cu cu-end))))))


; default ft to 'text'
;(au- [BufEnter] "*"
;     (fn [] (if (= vim.bo.filetype "") (set vim.bo.filetype "text"))))
