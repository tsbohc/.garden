(fn sym-tostring [x]
  "convert variable's name to string"
  `,(tostring x))

(fn count [xs]
  (do
    (var maxn 0)
    (each [k v (pairs xs)]
      (set maxn (+ maxn 1)))
    maxn)
  (not xs) 0
  (length xs))

(fn tab-tostring [xs]
  "convert table with var-names to table with strings"
  (var size (count xs))
  (var a [])
  (for [i 1 size]
    (table.insert a `,(tostring (. xs i))))
  a)

(fn lyn [link-id varsets]
  `(link (sym-tostring ,link-id) ,varsets))

{:sym-tostring sym-tostring
 :tab-tostring tab-tostring
 :lyn lyn
 }

;(fn string? [x]
;  (= "string" (type x)))
;
;
;(fn run! [f xs]
;  "Execute the function (for side effects) for every xs."
;  (when xs
;    (let [nxs (count xs)]
;      (when (> nxs 0)
;        (for [i 1 nxs]
;          (f (. xs i)))))))
;
;(fn reduce [f init xs]
;  "Reduce xs into a result by passing each subsequent value into the fn with
;  the previous value as the first arg. Starting with init."
;  (var result init)
;  (run!
;    (fn [x]
;      (set result (f result x)))
;    xs)
;  result)
;
;(fn flatten [t delimiter]
;  "flattens a table into a string separated by delimiter
;   if a string was passed, just return it"
;  (let [delimiter (or delimiter "")]
;    (if (string? t) t
;      (if (not= delimiter "")
;        (string.gsub (reduce #(.. $1 $2 delimiter) "" t) ".?$" "")
;        (reduce #(.. $1 $2 delimiter) "" t)))))
;
;(fn sym-tostring [x]
;  "convert variable's name to string"
;  `,(tostring x))
;
;; TODO: rewrite with let
;(fn tab-tostring [xs]
;  "convert table with var-names to table with strings"
;  (var size (count xs))
;  (var a [])
;  (for [i 1 size]
;    (table.insert a `,(tostring (. xs i))))
;  a)
;
;(fn shell [xs]
;  (let [command (flatten (tab-tostring xs) " ") ]
;    `(with-open [handle# (io.popen ,command)]
;                (let [result# (handle#:read "*a")]
;                  result#))))
;(fn prep [...]
;  (var size (count [...]))
;  (var t [])
;  (for [i 1 size]
;    (let [command (flatten (tab-tostring (. [...] i)) " ")]
;      (table.insert t command)))
;  t)
;
;;(fn shell [...]
;;  `(do
;;     (var r# 0)
;;     (each [_# command# (ipairs (prep ,...))]
;;       (with-open [handle# (io.popen command#)]
;;                  (let [result# (handle#:read "*a")]
;;                    (set r# result#))))
;;     r#))
;
;{:sym-tostring sym-tostring
; :tab-tostring tab-tostring
; :flatten flatten
; ;:shell shell
; ;:prep prep
; }
