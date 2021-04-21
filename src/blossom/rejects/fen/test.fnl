; variables are not meant to be modified
; do not define vars inside functions
; -- not using local, var, or set in functions

; pure functions mutate nothing outside their scope & they're deterministic
; fns that return value should be called that (message) returns a message, not (new-message)
; functional programming encourages composing complex functions out of smaller ones
; fns up to around 10 lines long

; top level -- functions with side-effects that use
; bottom level -- pure functions

; -- naming conventions --
; (varset)  - returns a varset
; (my-fun!) - impure function (those with side-effects)
; (bool?)   - functions that return a boolean

; xs        - [v1 v2 v3 ...]
; xt        - {:k1 v1 :k2 v2 ...}
; s         - string
; x y       - numbers
; i index   - indexes
; n         - size
; f g h     - functions
; re        - regular expression

; override (. xt :key)
; to support (. xt :a.b.c) ? seems dumb now that i think about it

(global inspect (require :inspect))

; {{{ lib
(macro when-not [cond ...]
  `(when (not ,cond)
     ,...))

(macro if-not [cond ...]
  `(if (not ,cond)
     ,...))

(macro tset- [xs key val]
  `(when (= nil (. ,xs ,key))
     (tset ,xs ,key ,val)
     true))

; closure-like definitions, i'm not using var or global
(macro def [name value]
  `(local ,name ,value))

(macro defn [name ...]
  `(fn ,name ,...))

; because idk
(macro != [...]
  `(not= ,...))

; we're never using modulo in this
(macro % [tab key val]
  (if (not= nil val)
    `(tset ,tab ,key ,val)
    `(table.insert ,tab ,key)))

;(macro if-let)
;(macro when-let)

(defn lit [s]
  "literalize string for regular expressions"
  (s:gsub
    "[%(%)%.%%%+%-%*%?%[%]%^%$]"
    (fn [c] (.. "%" c))))

(defn nil? [v]
  (= v nil))
; }}}

(defn pretty-print [...]
  (print (inspect ...)))

(global grammar
  {:p {:l "{@:-" :r "-:@}"}
   :e {:l "{@!-" :r "-!@}"}
   :v {:l "{"    :r    "}"}})

; --- varset ---

(defn varset [name]
  "return a varset table by [name]"
  (with-open
    [file (io.open (.. "varsets/" name) "r")]
    (let [comment-re "%s*!"
          keyval-re  "(%w+):%s*(%w+)"
          xt {}]
      (each [line (file:lines)]
        (when-not (or (line:match comment-re) (= line ""))
          (let [(key val) (line:match keyval-re)]
            (% xt key val))))
      xt)))

; --- template ---

(defn template [path]
  "return file contents of template at [path] as a string"
  (with-open
    [file (io.open path "r")]
    (let [s (file:read "*a")]
      s)))

(defn compile-pattern [pattern]
  pattern)

(defn patterns [template]
  "return a table of patterns from [template] string"
  (let [l (lit (. grammar :p :l))
        r (lit (. grammar :p :r))
        pattern-re (.. l "(.-)" r)
        xs {}]
    (each [pattern (template:gmatch pattern-re)]
      ; TODO: process patterns here
      ; or not?
      (% xs (compile-pattern pattern)))
    xs))


(-> :testrc
    (template)
    (patterns)
    (pretty-print)
    )


;(-> :kohi
;    (varset)
;    (pretty-print)
