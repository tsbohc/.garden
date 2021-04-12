(var z {})

(fn nil? [x]
  (= nil x))

(fn string? [x]
  (= "string" (type x)))

(fn table? [x]
  (= "table" (type x)))

(fn sequential? [xs]
  (var i 0)
  (each [_ (pairs xs)]
    (set i (+ i 1))
    (if (nil? (. xs i))
      (lua "return false")))
  true)

(fn function? [x]
  (= "function" (type x)))

(fn bool? [x]
  (= "boolean" (type x)))

(fn number? [x]
  (= (type x) "number"))

(fn count [xs]
  (if (table? xs)
    (do
      (var maxn 0)
      (each [k v (pairs xs)]
        (set maxn (+ maxn 1)))
      maxn)
    (not xs) 0
    (length xs)))

(fn run! [f xs]
  "Execute the function (for side effects) for every xs."
  (when xs
    (let [nxs (count xs)]
      (when (> nxs 0)
        (for [i 1 nxs]
          (f (. xs i)))))))

(fn reduce [f init xs]
  "Reduce xs into a result by passing each subsequent value into the fn with
  the previous value as the first arg. Starting with init."
  (var result init)
  (run!
    (fn [x]
      (set result (f result x)))
    xs)
  result)

(fn concat [...]
  "Concatenates the sequential table arguments together."
  (let [result []]
    (run! (fn [xs]
            (run!
              (fn [x]
                (table.insert result x))
              xs))
      [...])
    result))

(fn uniq [xs]
  "returns the passed seq table with duplicates removed"
  (let [uniq []
        hash {}]
    (each [_ v (ipairs xs)]
      (when (not (. hash v))
        (tset hash v true)
        (table.insert uniq v)))
    uniq))

(fn flatten [t delimiter]
  "flattens a table into a string separated by delimiter
   if a string was passed, just return it"
  (let [delimiter (or delimiter "")]
    (if (string? t) t
      (if (not= delimiter "")
        (string.gsub (reduce #(.. $1 $2 delimiter) "" t) ".?$" "")
        (reduce #(.. $1 $2 delimiter) "" t)))))

(fn merge! [base ...]
  "merge into the first table"
  (reduce
    (fn [acc m]
      (when m
        (each [k v (pairs m)]
          (tset acc k v)))
      acc)
    (or base {})
    [...]))

(fn merge [...]
  "merge into a fresh table"
  (merge! {} ...))

(fn map [f xs]
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

(fn empty? [xs]
  (= 0 (count xs)))

(fn full? [xs]
  (not= 0 (count xs)))

; TODO: rename get-callable-index-table
(fn index-as-method [callback]
  "translates callback(parameter) to table.parameter()"
  (setmetatable
    {} {:__index
        (fn [self index]
          (tset self index (fn [...] (callback index ...)))
          (rawget self index))}))

{: nil?
 : string?
 : table?
 : sequential?
 : function?
 : bool?
 : number?
 : count
 : run!
 : reduce
 : concat
 : uniq
 : flatten
 : merge!
 : merge
 : map
 : empty?
 : full?
 : index-as-method
 }
