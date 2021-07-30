(local M
  {:data (require :config)})

(fn escape [s]
  "escape string for regular expressions"
  (s:gsub "[%(%)%.%%%+%-%*%?%[%]%^%$]"
          (fn [c] (.. "%" c))))

(local lexis
  {:e-l "{"   :e-r   "}"
   :s-l "{% " :s-r " %}"})

(set lexis.statement-re (.. "(" (escape lexis.s-l) ".-" (escape lexis.s-r) ")"))
(set lexis.expression-re (.. (escape lexis.e-l) "([%w._%-]+)" (escape lexis.e-r)))

; fetch

(fn dp-xs [dp]
  (let [ks []]
    (each [w (dp:gmatch "[%w_]+")]
      (table.insert ks w))
    ks))

(fn get-in [xt ks]
  (var x xt)
  (while (and (> (length ks) 0) (not= x nil))
    (set x (?. x (. ks 1)))
    (table.remove ks 1))
  x)

(fn get-dp [xt dp]
  (let [ks (dp-xs dp)]
    (get-in xt ks)))

; parse

(fn parse [s]
  "split string into a table of strings and statements"
  (var s s)
  (var done? false)
  (let [xs []]
    (while (not done?)
      (let [(x y) (s:find lexis.statement-re)]
        (when (not= nil x)
          (table.insert xs (s:sub 1 (- x 1)))
          (table.insert xs (s:sub x y))
          (set s (s:sub (+ y 1))))
        (when (= nil x)
          (set done? true))))
    (when (> (length s) 0)
      (table.insert xs s))
    xs))

; render

(fn inject [s]
  "recursively render fragments starting from the leafmost one"
  (if (s:find lexis.expression-re)
    (inject
      (let [key (s:match lexis.expression-re)
            val (get-dp M.data key)
            l (escape lexis.e-l)
            r (escape lexis.e-r)]
        (s:gsub (.. l key r) val)))
    s))

(fn render [xs]
  "render a table of statements and concat it"
  (let [rendered []]
    (each [_ s (ipairs xs)]
      (if (s:find lexis.statement-re)
        (let [s (s:sub (+ (lexis.s-l:len) 1) (* -1 (+ (lexis.s-r:len) 1)))
              r (inject s)]
          (table.insert rendered r))
        (table.insert rendered s)))
    (table.concat rendered)))

(->> (. arg 1)
     (parse)
     (render)
     (print))

M
