(module zest.lib)

(def config-path (vim.fn.stdpath "config"))

(defn glob [path]
  (vim.fn.glob path true true true))

; TODO: these should prolly be macros?
(defn exec [cmd]
  (vim.api.nvim_command cmd))

(defn norm [cmd]
  (vim.api.nvim_command (.. "norm! " cmd)))

(defn eval [str]
  (vim.api.nvim_eval str))

(def fn- vim.fn)

(defn nil? [x]
  (= nil x))

(defn string? [x]
  (= "string" (type x)))

(defn table? [x]
  (= "table" (type x)))

(defn sequential? [xs]
  (var i 0)
  (each [_ (pairs xs)]
    (set i (+ i 1))
    (if (nil? (. xs i))
      (lua "return false")))
  true)

(defn function? [x]
  (= "function" (type x)))

(defn bool? [x]
  (= "boolean" (type x)))

(defn number? [x]
  (= (type x) "number"))

(defn count [xs]
  (if (table? xs)
    (do
      (var maxn 0)
      (each [k v (pairs xs)]
        (set maxn (+ maxn 1)))
      maxn)
    (not xs) 0
    (length xs)))

(defn run! [f xs]
  "Execute the function (for side effects) for every xs."
  (when xs
    (let [nxs (count xs)]
      (when (> nxs 0)
        (for [i 1 nxs]
          (f (. xs i)))))))

(defn reduce [f init xs]
  "Reduce xs into a result by passing each subsequent value into the fn with
  the previous value as the first arg. Starting with init."
  (var result init)
  (run!
    (fn [x]
      (set result (f result x)))
    xs)
  result)

(defn concat [...]
  "Concatenates the sequential table arguments together."
  (let [result []]
    (run! (fn [xs]
            (run!
              (fn [x]
                (table.insert result x))
              xs))
      [...])
    result))

(defn uniq [xs]
  "returns the passed seq table with duplicates removed"
  (let [uniq []
        hash {}]
    (each [_ v (ipairs xs)]
      (when (not (. hash v))
        (tset hash v true)
        (table.insert uniq v)))
    uniq))

(defn flatten [t delimiter]
  "flattens a table into a string separated by delimiter
   if a string was passed, just return it"
  (let [delimiter (or delimiter "")]
    (if (string? t) t
      (if (not= delimiter "")
        (string.gsub (reduce #(.. $1 $2 delimiter) "" t) ".?$" "")
        (reduce #(.. $1 $2 delimiter) "" t)))))

(defn merge! [base ...]
  "merge into the first table"
  (reduce
    (fn [acc m]
      (when m
        (each [k v (pairs m)]
          (tset acc k v)))
      acc)
    (or base {})
    [...]))

(defn merge [...]
  "merge into a fresh table"
  (merge! {} ...))

(defn map [f xs]
  "Map xs to a new sequential table by calling (f x) on each item."
  (let [result []]
    (run!
      (fn [x]
        (let [mapped (f x)]
          (table.insert
            result
            (if (= 0 (select "#" mapped))
              nil
              mapped))))
      xs)
    result))

(defn empty? [xs]
  (= 0 (count xs)))

(defn full? [xs]
  (not= 0 (count xs)))

; TODO: rename get-callable-index-table
(defn index-as-method [callback]
  "translates callback(parameter) to table.parameter()"
  (setmetatable
    {} {:__index
        (fn [self index]
          (tset self index (fn [...] (callback index ...)))
          (rawget self index))}))

; think I should go the function! route, cause it would make passed functions
; accessible through :func-name
; maybe depending on whether or not the name is passed?
; bind anon funcs with v:lua, bind funcs with name through function! win-win
; wish i could extract the name from (fn name [] (body)
; like a viml-defn? ooooh but i'd rather have that as a macro that

;(defn bridge [f name]
;  (when (nil? _G._ZEST)
;    (tset _G :_ZEST {}))
;  (when (nil? _G._ZEST.maps)
;    (tset _G :_ZEST :maps {}))
;
;  (let [name (or name "map")
;        id (.. name "-" (count _G._ZEST.maps))]
;    (tset _G :_ZEST :maps id f)
;    (.. "v:lua._ZEST.maps." id "()")))
