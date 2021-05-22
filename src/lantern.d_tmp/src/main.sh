# i think it doesn't blink if it's global
select_action() {
  local actions="x execute
d cd directory
e edit
f file
b background
u graphical ui
w browse web
r reddit"

  local a=$(echo "$actions" | fzf $fzf_base --header="  $1")
  if [[ "$a" != "" ]]; then
    a="${a:0:1}"
    action=$a
  else
    exit 0
  fi
}

select_entry() {
  out=$(echo -e "$data" | fzf $fzf_base -d $d --bind=change:top --with-nth=1,2,3 --nth=3 --print-query --expect=tab,ctrl-a,ctrl-d,esc)

  mapfile -t out <<< "$out"
  query="${out[0]}"
  key="${out[1]}"
  selection="${out[2]}"

  index=$(awk -F"$d" '{print $1}' <<< "$selection")
  action=$(awk -F"$d" '{print $2}' <<< "$selection")
  entry=$(awk -F"$d" '{print $3}' <<< "$selection")
}

auto_add_entry() {
  select_action "$1"
  data+=$(new_entry "$1" "$action")
  entry="$1"
}

main() {
  fzf_base="--ansi --reverse --prompt=  \$  --cycle $fzf_height $fzf_margin --info=hidden --no-multi --color=bg:-1,bg+:-1,gutter:-1,hl:15,hl+:15,fg:7,fg+:7,info:7,prompt:7,pointer:4,header:15,preview-fg:8"

  populate

  # only works on second relaunch for some reason
  clean

  return

  select_entry

  case "$key" in
    "tab")
      select_action "$entry"
      # replace action with the new one
      data=$(sed "s+\(^[0-9]*${d}\).\(${d}${entry}$\)+\1${action}\2+g" <<< "$data")
      ;;
    "ctrl-a")
      auto_add_entry "$query"
      ;;
    "esc")
      return
      ;;
  esac

  if [[ "$entry" == "" ]] && [[ "$query" != "" ]]; then
    auto_add_entry "$query"
  fi

  reduce_scores

  # FIXME $d needs to be escaped for sed
  # increment index
  data=$(sed "s+^[0-9]*\(\ ${action}${d}${entry}$\)+$((index+1))\1+g" <<< "$data")

  if [[ "$entry" != "" ]] && [[ "$action" != "" ]]; then
    launch "$entry" "$action"
  fi
}
