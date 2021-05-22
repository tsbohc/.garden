reduce_scores() {
  # we only care about score > 1, so find the first occurrence of index 1
  local line_number=$(awk -v search="^1${d}" '$0~search{print NR-1; exit}' <<< "$data")

  # this should keep things from getting out of control
  (( $line_number < 20 )) && return
  local line=$(head -n 1 <<< "$data")
  local id=$(awk -F"$d" '{print $1}' <<< "$line")
  (( $id < 20 )) &&  return

  # find a random line w/ i > 1
  local rnd=$RANDOM
  let "rnd %= $line_number"
  ((rnd++))
  local j=0
  while read -r line; do
    ((j++))
    [ $j -eq $rnd ] && break
  done <<< "$data"

  # reduce index
  local en=$(awk -F"$d" '{print $3}' <<< "$line")
  local id=$(awk -F"$d" '{print $1}' <<< "$line")
  data=$(sed "s+^[0-9]*\(.*${en}$\)+$((id-1))\1+g" <<< "$data")
}
