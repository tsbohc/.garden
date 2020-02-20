search() {
  # find all non-hidden folders in home, remove ~ itself
  home_dirs="$(find ~ -maxdepth 1 -not -path '*/\.*' -type d | sed '1d')"
  # separate into lines
  home_dirs="${home_dirs//$'\n'/ }"
  # find all files in those folders
  home="$(find $home_dirs \( -name .git \) -prune -o -print)"
  # add files from ~
  home+="$(find ~ -maxdepth 1 -type f)"

  # decide on default action for each file
  while IFS= read -r l; do
    if [[ -d "$l" ]]; then
      m="d"
    elif [[ -x "$l" ]]; then
      m="x"
    else
      m="f"
    fi
    l=${l/#$HOME/'~'}
    add_entry "$m" "$l"
  done <<< "$home"

  # sort and ignore duplicates based on $col
  data=$(echo "$data" | sort -k1,1nr | awk -F"$d" '!x[$3]++')
}
