# i think it doesn't blink if it's global
actions="x execute
d cd directory
e edit
f file
b background
u graphical ui
w browse web
r reddit"

select_action() {
  local a=$(echo "$actions" | fzf $fzf_base --header="  $1")
  if [[ "$a" != "" ]]; then
    a="${a:0:1}"
    action=$a
  # bail if in window mode
  elif [[ "$opt" = "i" ]]; then
    exit 0
  fi
}

select_entry() {
  out=$(echo -e "$data" | fzf $fzf_base -d $d --bind=change:top --with-nth=2,1,3 --nth=3 --print-query --expect=tab,ctrl-a,ctrl-d,esc)

  mapfile -t out <<< "$out"
  query="${out[0]}"
  key="${out[1]}"
  selection="${out[2]}"

  index=$(awk -F"$d" '{print $1}' <<< "$selection")
  action=$(awk -F"$d" '{print $2}' <<< "$selection")
  entry=$(awk -F"$d" '{print $3}' <<< "$selection")
}

guess_action() {
  if [[ -d "$1" ]]; then
    action="d"
  elif [[ -x "$1" ]]; then
    action="x"
  elif \
    [[ "$1" == *".com" ]] || [[ "$1" == *".com/"* ]] || \
    [[ "$1" == *".net" ]] || [[ "$1" == *".net/"* ]] || \
    [[ "$1" == *".ru" ]] || [[ "$1" == *".ru/"* ]] || \
    [[ "$1" == *".su" ]] || [[ "$1" == *".su/"* ]] || \
    [[ "$1" == *".cc" ]] || [[ "$1" == *".cc/"* ]]; then
    action="w"
  elif [[ "$1" == "r/"* ]]; then
    action="r"
  else
    action="f"
  fi
}

decide_and_add_entry() {
  guess_action "$1"
  echo "    $action $1"
  ! ask && select_action "$1"
  add_entry "$action" "$1"
  entry="$1"
}

main() {
  fzf_base="--ansi --reverse --prompt=  \$  --cycle $fzf_height $fzf_margin --info=hidden --no-multi --color=bg:-1,bg+:-1,gutter:-1,hl:15,hl+:15,fg:7,fg+:7,info:7,prompt:7,pointer:4,header:15,preview-fg:8"

  populate
  clean

  #return

  select_entry

  case "$key" in
    "tab")
      select_action "$entry"
      # replace action with the new one
      data=$(sed "s+\(^[0-9]*${d}\).\(${d}${entry}$\)+\1${action}\2+g" <<< "$data")
      ;;
    "ctrl-a")
      decide_and_add_entry "$query"
      ;;
    "esc")
      return
      ;;
  esac

  if [[ "$entry" == "" ]] && [[ "$query" != "" ]]; then
    decide_and_add_entry "$query"
  fi

  reduce_scores

  # increment index
  data=$(sed "s+^[0-9]*\(${d}${action}${d}${entry}$\)+$((index+1))\1+g" <<< "$data")

  if [[ "$entry" != "" ]] && [[ "$action" != "" ]]; then
    launch "$entry" "$action"
  fi
}
