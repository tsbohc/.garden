(require-macros :zest.macros)

(fn def-test [name x y]
  (if (= x y)
    (print (.. name ": passed"))
    (print (.. name ": failed"))))

(def-test "just a string"
  (___concat :foobar)
  "foobar")

(def-test "table with strings"
  (___concat [:foo :bar])
  "foobar")

(local table-with-strings "bar")
(def-test "table with strings"
  (___concat [:foo table-with-strings :baz] " ")
  "foo bar baz")
