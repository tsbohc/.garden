; {{{
; why?
; i like writing opinionated code for my own uses. i like code that i perfectly undertand. i like code that feels mine
; i don't like markap configs yaml/toml, i like scriptable configs

; ideas
; has to feel lispy
; config has to allow scripting, yaml/toml is boring and i'm not a fan
; fennel is good for this because with macros i can abstract and customise syntax
; [ ] have a shell install script that pulls fennel

; features
; [ ] bash bindings would be nice (installing packages, nvim plugs, etc)
; [ ] toml-bombadil style of variable insertion (theme generation!)
; [ ] profile (theme) management with reload hooks
; [ ] fzf selector for modules?
; }}}

; {{{
; meh?
;(module bspwm
;  {yay [bspwm sxhkd]
;   ln  [:etc/bspwm.d/bspwmrc :$/.config/bspwm/bspwmrc
;        :etc/bspwm.d/sxhkdrc :$/.config/bspwm/sxhkdrc]})
;
;(theme everforest
;  {black :#01010a
;   red   :#EE0000
;   var1  10})
;
;(profile default
;  {modules [bspwm]
;   theme   everforest})
; }}}

; name.. cardamon?

; lispy!

; maybe i don't need full paths and can just glob filenames and match that?
; all of my configs are in etc, and there are no duplicate names?
; well, maybe for folders, like bspwm/modules and polybar/modules
; could skip .d in the dirnames
; the first is prolly better, because most entries have 1 file to symlink

(fn set-env [path]
  (global cardamon-env path))

(fn split-path [p]
  "split path into a table"
  (let [t []]
    (each [word (string.gmatch p "([^/]+)")]
      (table.insert t word))
    t))

(fn find [path]
  (let [p (io.popen (.. "find \"" path "\" -type f -printf '%P\n'"))]
    (each [f (: p :lines)]
      (print f))
    (: p :close)))

(set-env "~/blueberry/etc/") ; globbing start
;(print cardamon-env)

;(find cardamon-env)
(each [k v (ipairs (split-path cardamon-env))]
  (print v))

;(drawer
;  [bspwm/bspwmrc "~/.config/bspwm/bspwmrc"
;   bspwm/sxhkdrc "~/.config/bspwm/sxhkdrc"
;   bspwm/modules ; will only match "etc/bspwm(.d)/modules"
;   modules       ; will matchs any "etc/*modules"
;                 ; maybe i could warn about dupes somehow by preparing the tree?
;                 ; should be easy
;   dunstrc "~/.config/dunst/dunstrc"])


;; variable sets for injection
;(spice everforest
;  background "#292c3e"
;  foreground "#ebebeb")
;
;(spice bspwm
;  border-width 10)
;
;(recipe bspwm
;  (yay bspwm sxhkd)
;  (lns bspwmrc sxhkdrc)
;  (reload-bspwm-hook))
;
;; ! for sudo?
;(recipe hosts
;  (curl! "https://raw.githubusercontent.com/stevenblack/hosts/master/hosts -o /etc/hosts"))
;
;(cardamon
;  (bspwm everforest bspwm) ; specify spices to inject
;  (hosts))
;
;
;; rejected in favor of 1d array
;;(drawer
;;  [bspwm {bspwmrc "~/.config/bspwm/bspwmrc"
;;          sxhkdrc "~/.config/bspwm/sxhkdrc"}]
;;  [dunst {dunstrc "~/.config/dunst/dunstrc"}])
