t() {
  echo "$@"
}

t a b - a b c d


#te() {
#  declare -n ref="$1"
#  declare -gA "$1"
#  shift
#  args=( "$@" )
#  for k in "${args[@]}" ; do
#    ref["$k"]="${args["$k"]}"
#  done
#}
#
#te foo 1 2 3 4
#
##foo[a]='b'
#
#echo ${foo[2]}
