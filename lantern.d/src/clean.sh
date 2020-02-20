clean() {
  echo "cleaning"
  while IFS= read -r l; do
    index=$(awk -F"$d" '{print $1}' <<< "$l")
    action=$(awk -F"$d" '{print $2}' <<< "$l")
    entry=$(awk -F"$d" '{print $3}' <<< "$l")

    if [[ ${entry:0:1} == "~" ]]; then
      # get abs path?
      entry="${entry//\~/$HOME}"
      if [[ ! -e "$entry" ]]; then
        entry=${entry/#$HOME/'~'}
        echo "$entry"
        entry=$(sed 's/[]\/$*.^[]/\\&/g' <<< "$entry")
        data=$(sed "/${index}.*${entry}$/d" <<< "$data")
      fi
    fi
  done <<< "$data"
  echo "$data" > "$DATA_PATH"

  echo "scanning"
  _scan_for_entries
}
