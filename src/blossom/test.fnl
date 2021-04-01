;(var varset {:foreground "ebdbb2" :background "32302f"})
;
;(var settings 
;  {:env "~/.garden/etc"
;   :compile "~/.config/blossom"})
;
;(shell
;  [touch foo]
;  [mv foo bar]
;  [rm bar])
;
;(mod alacritty
;  (shell [yay -Syu --needed alacritty])
;  (link alacritty [colorscheme]))
;
;(var out (shell [echo woo]))

(require-macros :macros)


;(she
;  [yay -S arstarst]
;  [yay -S dhstrd])

; i think i need a simple wrapper for shell so that
; (sh "yay -S --needed alacritty")
; works, and then i can script it so that (yay [alacritty bspwm]) works
; do i even need macros for this?

; we have to know what modules are currently installed and now a 
; + module
; - other module
; before confirming
; installing should be simple, like fzf multi-select

;(mod
;  (shell [yay -S --needed alacritty])
;  (link alacritty [colorscheme]))

;(fn shell [command]
;  (with-open 
;    [handle (io.popen command)]
;    (let [result (handle:read "*a")]
;      result)))
;
;
;(yay ["rstar" "arst"])

;(var insert "woo")
;(var a (shell (.. "echo -e a" insert "b c d | fzf")))
;(print (.. "received " a))

