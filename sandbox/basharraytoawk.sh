array=( foo )

input="foo
baz
bar
qux"

echo "$input" | awk -v array="${array[*]}" '
  BEGIN {
    split(array, values);
    for ( i in values ) keys[values[i]] = ""
  }
  !($1 in keys)
'
