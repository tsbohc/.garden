clean() {
  # now 10 times quicker!
  while IFS="" read -r i a e; do
    if [[ ${e:0:1} == "~" ]]; then
      if [[ ! -e "${e//\~/$HOME}" ]]; then
        e=$(sed 's/[]\/$*.^[]/\\&/g' <<< "$e")
        data=$(sed "/.*${e}$/d" <<< "$data")
      fi
    fi
  done <<< "$data"
}
