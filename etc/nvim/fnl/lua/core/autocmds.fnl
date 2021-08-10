(import-macros {:set-option  se-
                :def-autocmd au-
                :def-augroup gr-} :zest.lime.macros)

; ------------------------------------
; --         autocommands           --
; ------------  --/-<@  --------------

(gr- :smart-cursorline
  ; show/hide cursorline based on focus and mode
  (au- [:InsertEnter :BufLeave :FocusLost] "*"
    [(se- cursorline false)])
  (au- [:InsertLeave :BufEnter :FocusGained] "*"
    [(if (not= (vim.fn.mode) :i)
       (se- cursorline))]))

(gr- :restore-position
  ; restore last position in file
  (au- :BufReadPost "*"
    [(when (and (> (vim.fn.line "'\"") 1)
                (<= (vim.fn.line "'\"") (vim.fn.line "$")))
       (vim.cmd "normal! g'\""))]))

(gr- :flash-yank
  ; flash yanked text
  (au- :TextYankPost "*"
    [(vim.highlight.on_yank
       {:higroup "Search"
        :timeout 100})]))

(gr- :split-settings
  ; resize splits automatically
  (au- :VimResized "*"
    [(when (> (length (vim.fn.tabpagebuflist)) 1)
      (vim.api.nvim_command "wincmd ="))])
  ; open help in vsplit
  (au- :FileType "help"
    "wincmd L"))

(gr- :filetype-settings
  ; enable wrap for text filetypes
  (au- :FileType [:text :latex :markdown]
    "set wrap")
  ; tweaks for fennel and vimrc
  (au- :FileType "fennel"
    [(se- [:remove] iskeyword ".")
     (se- [:append] lispwords [:string.*
                                      :table.*
                                      :au.no- :au.fn-
                                      :ki.no- :ki.fn-])]))

; ------------------------------------
; --        layout-keeper           --
; ------------  --/-<@  --------------

(var xkbmap-normal
  {:layout "us"
   :variant "colemak"})

(var xkbmap-insert {})

(fn get-xkbmap []
  (with-open
    [handle (assert (io.popen "setxkbmap -query"))]
    (let [out (handle:read "*a")
          xt {}]
      (each [k v (out:gmatch "(.-):%s*(.-)%s+")]
        (tset xt k v))
      xt)))

(fn set-xkbmap [x]
  (os.execute (.. "setxkbmap " x.layout " -variant " x.variant)))

(gr- :keyboard-switcher
  ; set setxkbmap to the previous insert mode layout
  (au- :InsertEnter "*"
    [(when (and xkbmap-insert.layout
                (not= xkbmap-insert.layout xkbmap-normal.layout))
       (set-xkbmap xkbmap-insert))])
  ; store insert mode layout
  (au- :InsertLeave "*"
    [(set xkbmap-insert (get-xkbmap))
     (tset vim.g :_layout xkbmap-insert.layout)
     (when (not= xkbmap-insert.layout xkbmap-normal.layout)
       (set-xkbmap xkbmap-normal))]))

; ------------------------------------
; --             rake               --
; ------------  --/-<@  --------------

;(gr- :rake
;  (au.no- :BufWritePost "/home/sean/.garden/etc/*"
;    "silent!rake -u %:p"))
