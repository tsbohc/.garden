populate() {
  # find all non-hidden folders in home
  # can break if empty (doubt it ever will) without [ -d ${file} ] && 
  #home_dirs=$(for folder in $HOME/*/; do
  #  [ -d $folder ] && echo "$folder"
  #done)
  local home_dirs="$(find $HOME -maxdepth 1 -not -path '*/\.*' -type d | sed '1d')"

  # find everything in them
  local home="$(find $home_dirs \( -name .git \) -prune -o -print)"

  # append all files from home
  home+="
$(find $HOME -maxdepth 1 -type f)"

  # prevent them from sticking together
  data+="
"

  # add entries to data
  data+=$(while IFS= read -r l; do
    if [ -d "$l" ]; then
      m="d"
    elif [ -x "$l" ]; then
      m="x"
    else
      m="f"
    fi
    echo "1$d$m$d${l/#$HOME/'~'}"
  done <<< "$home")

  # sort and ignore duplicates based on $col in file
  data=$(echo "$data" | sort -k1,1nr | awk -F"$d" '!x[$3]++')
}
