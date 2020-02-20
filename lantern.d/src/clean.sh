clean() {
  echo "lantern: cleaning"
  line_count=$(echo "$data" | wc -l)
  count=0
  tput sc
  while IFS= read -r l; do
    index=$(awk -F"$d" '{print $1}' <<< "$l")
    action=$(awk -F"$d" '{print $2}' <<< "$l")
    entry=$(awk -F"$d" '{print $3}' <<< "$l")
    count=$((count+1))
    tput ed
    echo "$count / $line_count : $entry"

    if [[ ${entry:0:1} == "~" ]]; then
      # get abs path?
      entry="${entry//\~/$HOME}"
      if [[ ! -e "$entry" ]]; then
        entry=${entry/#$HOME/'~'}
        entry=$(sed 's/[]\/$*.^[]/\\&/g' <<< "$entry")
        data=$(sed "/${index}.*${entry}$/d" <<< "$data")
      fi
    fi
    tput rc
  done <<< "$data"
  echo "$data" > "$DATA_PATH"
}
