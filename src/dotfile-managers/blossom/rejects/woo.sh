#varset() {
#  echo "called test with $*"
#}
#
alacritty=(
  template colo test ,
    arst
)

echo "${alacritty[@]}"


template should have
1. source file
2. variables data: filenames, table literals
3. destination path

# works!
#test() {
#  echo "$@"
#}
#
#test one two test=10

#t() {
#  echo "$@"
#}
#
#t a b - a b c d


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
