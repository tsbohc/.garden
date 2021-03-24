; zest macros as a single module because it's convenient and i did't want to
; track everything and pollute config dirs
; woo
; note to self: don't try to create a macro that creates macros: your brain will hurt and then you'll realise you can't require-macros in this file

; prep

(fn sym-tostring [x]
  "convert variable's name to string"
  `,(tostring x))

; TODO: rewrite with let
(fn tab-tostring [xs]
  "convert table with var-names to table with strings"
  (var z (require :aniseed.core))
  (var size (z.count xs))
  (var a [])
  (for [i 1 size]
    (table.insert a `,(tostring (. xs i))))
  a)

; au -- should stay a wrapper?
(fn au- [events filetypes action]
  "autocmd input parser"
  (let [t [(if (= (type events) :table)
             (tab-tostring events)
             [(sym-tostring events)])
           (if (= (type filetypes) :table)
             (tab-tostring filetypes)
             [(sym-tostring filetypes)])
           action]]
    `(au.set-au ,(unpack t))))

; sl -- statusline
(fn sl- [a b c]
  "events options action"
  (match (table.maxn [a b c])
    1 (let [t [false false a]]
        `(sl.add ,(unpack t)))
    2 (if (= (type b) :string)
        (let [t [false a b]]
          `(sl.add ,(unpack t)))
        (let [t [(if (= (type a) :table)
                   (tab-tostring a)
                   [(sym-tostring a)])
                 false b]]
          `(sl.add ,(unpack t))))
    3 (let [t [(if (= (type a) :table)
                 (tab-tostring a)
                 [(sym-tostring a)])
               b c]]
        `(sl.add ,(unpack t)))))

; se -- compiles down to nvim_set_option!
(fn get-scope [option]
  (if (pcall vim.api.nvim_get_option_info option)
    (. (vim.api.nvim_get_option_info option) :scope)
    false))

(fn set-option [scope option value]
  (match scope
    :global `(vim.api.nvim_set_option       ,option ,value)
    :win    `(vim.api.nvim_win_set_option 0 ,option ,value)
    :buf    `(vim.api.nvim_buf_set_option 0 ,option ,value)
    _       `(print (.. "zest.se- invalid scope '" ,scope "' for option '" ,option "'"))))

(fn se- [option value]
  (let [option (sym-tostring option)
        value (if (= value nil)
                true
                value)
        scope (get-scope option)]
    (if scope
      `,(set-option scope option value)
      (if (= (: option :sub 1 2) :no)
        (let [option (: option :sub 3)
              scope (get-scope option)
              value false]
          (if scope
            `,(set-option scope option value)
            `(print (.. "zest.se- option '" ,option "' not found"))))
        `(print (.. "zest.se- option '" ,option "' not found"))))))

; keys TODO: redo with a parser like autocmds
; or even compile down to nvim builtins like set
(fn keys-begin []
  `(local (,(sym :expr) ,(sym :silent) ,(sym :remap)) (values :expr :silent :remap)))

(fn reg-fn [...]
  "register a lua function in a global table _Z.maps under id
  return the corresponding vim :command"
  `(let [z# (require :zest.lib)
         id# (.. "__" (z#.count _Z.fn))]
     (tset _G :_Z :fn id# ,...)
     (.. "v:lua._Z.fn." id# "()")))

(fn def-cmd [name ...]
  "declare a lua function, register it, and bind it to a corresponding vim :command"
  `(local ,name
     (let [f# (fn ,...)
           cmd# (.. "com! " ,(tostring name) " :call " (reg-fn f#))]
       (vim.api.nvim_command cmd#)
       f#)))

{
 : se-
 : au-
 : sl-
 : keys-begin
 : reg-fn
 : def-cmd
 }
