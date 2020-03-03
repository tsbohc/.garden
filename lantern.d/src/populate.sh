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
  [ -s "$LANTERN_DATA" ] && data+="
"

  # add entries to data
  data+=$(while IFS= read -r l; do
    if [ -d "$l" ]; then
      a="d"
    elif [ -x "$l" ]; then
      a="x"
    else
      a="f"
    fi
    echo "1${d}${a}${d}0${d}${l/#$HOME/'~'}"
  done <<< "$home")

  # remove duplicates based on $col in file
  data=$(awk -F"$d" '!x[$4]++' <<< "$data")

  # maybe pipe the output of below into fzf without overwriting a file?
  # but this seems easier though, but stuff can go wrong

  # calculate score and sort, prepare for fzf
  # note the delimiters!
  echo "$data" | awk -v d="$d" -v now="$(date +%s)" -F"$d" '
    function frecency(time) {
      if ( time > 0 ) {
        dt = now-time
        if( dt < 86400 ) return 4
        if( dt < 43200 ) return 8
        if( dt < 3600 ) return 16
      }
      return 1
    }
    {
      score[$4] = $1 / ( length / 2 ) * frecency($3)
      uses[$4] = $1
      action[$4] = $2
      time[$4] = $3
    }
    END {
      for ( x in score ) print score[x] d uses[x] d action[x] d time[x] d x
    }
    ' | sort -k1,1nr | cut -d"" -f2-5

    #if ( $3 in score == 0 ) {
    #  score[$3] = $1 / length
    #  action[$3] = $2
    #}

}
