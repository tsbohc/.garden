
home_dirs="$(find $HOME -mindepth 1 -maxdepth 1 -not -path '*/\.*' -type d)"

home="$(find $home_dirs \( -name .git \) -prune -o -print)
$(find $HOME -maxdepth 1 -type f)"

while true; do
  #touch $HOME/lastwatch
  sleep 5
  new_entries=$(find $HOME -maxdepth 1 -type f -cnewer $HOME/lastwatch)
  if [[ "$new_entries" != "" ]]; then
    while read e; do
      echo "$e"
    done <<< "$new_entries"
  fi
done
