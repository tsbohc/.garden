#!/bin/bash

# data management for lantern

source "$_LANTERN_PROJECT_ROOT/defaults.sh"

::lantern::data::new_entry() {
  # $1 - score, $2 - action, $3 - path
  local path="${3/#$HOME/~}"

  local length="${path//[!\/]}"
  length="${#length}"

  if (( $length > 1 )); then
    local left="${path%/*}"
    local right="/${left##*/}/${path##*/}"
    left="${left%/*}"
  else
    local left="${path%/*}"
    local right="/${path##*/}"
  fi

  echo "${1}${_LANTERN_DELIMITER}${2}${_LANTERN_DELIMITER}${left}${_LANTERN_DELIMITER:1}${right}"
}

::lantern::data::update_entry(){
  # $1 - entry, $2 - score delta, $3 - action, $4 - shortcut
  [[ "$1" == "" ]] && return
  awk -i inplace -v entry="$1" -v dscore="$2" -v action="$3" -v shortcut="$4" -v d="$_LANTERN_DELIMITER" -F"$_LANTERN_DELIMITER" '
  $3 == entry {
      if ( length(dscore) != 0 ) $1 = $1 + dscore
      if ( length(action) == 1 ) $2 = action
  } { print $1 d $2 d $3 }
  ' "$_LANTERN_DATA"
  # NOTE: $4 was remove to prevent trailing delimiter when splitting a path
}

      #if ( length(shortcut) > length($4) ) $4 = shortcut

::lantern::data::refresh() {
  [[ ! -e "$_LANTERN_DATA" ]] && touch "$_LANTERN_DATA"
  data="$(<"$_LANTERN_DATA")"

  # cleanup time
  local redundancy
  while IFS="" read -r s a l r; do
    local e="$l$r"
    if [[ "${e:0:1}" == "~" ]] && [[ ! -e "${e//\~/$HOME}" ]]; then
      redundancy+="$l$r|"
    fi
  done <<< "$data"

  data="$(awk -v a="$redundancy" -F"$_LANTERN_DELIMITER" '
  BEGIN {
    split(a, A, "|")
    for (i in A) B[A[i]] = ""
  }
  !($3 in B) { print } ' <<< "$data")"

  # append new data
  # find all non-hidden folders in home
  local home_dirs="$(find "$HOME" -mindepth 1 -maxdepth 1 -not -path '*/\.*' -type d)"

  # find everything in them and append non-hidden files from home
  local home="$(while IFS=$"\n" read -r l; do
    echo "$(find "$l" \( -name .git \) -prune -o -print)"
  done <<< "$home_dirs")"

  # newline is really important
  home+="
$(find "$HOME" -maxdepth 1 -not -path '*/\.*' -type f)"

  # newline is also really important
  data+="
$(while IFS= read -r e; do
  if [ -d "$e" ]; then
    a="d"
  else
    a="f"
  fi
  ::lantern::data::new_entry "0" "$a" "$e"
done <<< "$home")"

  # remove empty lines and dupes
  awk -F"$_LANTERN_DELIMITER" 'NF && !x[$3]++' <<< "$data" | sort -k1,1nr | awk '{ print length" "$0 }' | sort -n -s | cut -d" " -f2- | sort -k1,1nr -s > "$_LANTERN_DATA"
}
