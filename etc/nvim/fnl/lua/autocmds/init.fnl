(import-macros
  {:opt-set        se=
   :opt-remove     se-
   :opt-append     se+
   :def-augroup    au.gr-
   :def-autocmd    au.no-
   :def-autocmd-fn au.fn-} :zest.macros)

; ------------------------------------
; --         autocommands           --
; ------------  --/-<@  --------------

(au.gr- :smart-cursorline
  ; show/hide cursorline based on focus and mode
  (au.fn- [:InsertEnter :BufLeave :FocusLost] "*"
    (se= cursorline false))
  (au.fn- [:InsertLeave :BufEnter :FocusGained] "*"
    (if (not= (vim.fn.mode) :i)
      (se= cursorline))))

(au.gr- :restore-position
  ; restore last position in file
  (au.fn- :BufReadPost "*"
    (when (and (> (vim.fn.line "'\"") 1)
               (<= (vim.fn.line "'\"") (vim.fn.line "$")))
      (vim.cmd "normal! g'\""))))

(au.gr- :flash-yank
  ; flash yanked text
  (au.fn- :TextYankPost "*"
    (vim.highlight.on_yank
      {:higroup "Search"
       :timeout 100})))

(au.gr- :split-settings
  ; resize splits automatically
  (au.fn- :VimResized "*"
    (when (> (length (vim.fn.tabpagebuflist)) 1)
      (vim.api.nvim_command "wincmd =")))
  ; open help in vsplit
  (au.no- :FileType "help"
    "wincmd L"))

(au.gr- :filetype-settings
  ; enable wrap for text filetypes
  (au.no- :FileType [:text :latex :markdown]
    "set wrap")
  ; tweaks for fennel and vimrc
  (au.fn- :FileType "fennel"
    (se- iskeyword ".")
    (se+ lispwords [:string.*
                    :table.*
                    :au.no- :au.fn- :au.gr-
                    :ki.no- :ki.fn-])))

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

(au.gr- :keyboard-switcher
  ; set setxkbmap to the previous insert mode layout
  (au.fn- :InsertEnter "*"
    (when (and xkbmap-insert.layout
               (not= xkbmap-insert.layout xkbmap-normal.layout))
      (set-xkbmap xkbmap-insert)))
  ; store insert mode layout
  (au.fn- :InsertLeave "*"
    (set xkbmap-insert (get-xkbmap))
    (tset vim.g :_layout xkbmap-insert.layout)
    (when (not= xkbmap-insert.layout xkbmap-normal.layout)
      (set-xkbmap xkbmap-normal))))

; ------------------------------------
; --             rake               --
; ------------  --/-<@  --------------

(au.gr- :rake
  (au.no- :BufWritePost "/home/sean/.garden/etc/*"
    "silent!rake -u %:p"))
