#!/bin/bash

# action keys
declare -A _lantern_actions=(
  [x]=::lantern::actions::"$1"_execute
  [f]=::lantern::actions::"$1"_file
  [d]=::lantern::actions::"$1"_directory
)

::lantern::actions::detach() {
  #nohup "$@" &>/dev/null &
  exec setsid -f "$@"
}

# action definitions
::lantern::actions::w_execute() {
  ::lantern::actions::detach st -e bash -c "$@ ; $SHELL"
}
::lantern::actions::c_execute() {
  $@ ; # no quotes here
}

::lantern::actions::w_directory() {
  ::lantern::actions::detach st -e bash -c "cd $1 ; $SHELL"
}
::lantern::actions::c_directory() {
  cd "$1"
}

::lantern::actions::w_file() {
  if [[ "$(file "$1")" == *"PDF"* ]]; then
    ::lantern::actions::detach zathura "$1"
  else
    ::lantern::actions::w_execute "$EDITOR $1"
  fi
}
::lantern::actions::c_file() {
  if [[ "$(file "$1")" == *"PDF"* ]]; then
    ::lantern::actions::detach zathura "$1"
  else
    ::lantern::actions::c_execute "$EDITOR" "$1"
  fi
}


::lantern::actions::select() {
  # $1 - entry
  # cut off the _m_ part off of the function names
  # return only the first letter, the action key
  [[ "$1" == "" ]] && return
  local a="$(for key in "${!_lantern_actions[@]}"; do echo $key ${_lantern_actions[$key]:22}; done | \
    tui::fzf --sort --bind "esc:abort" --header="  $1" --nth=.. --with-nth=..)"
  [[ "$a" != "" ]] && echo "${a:0:1}"
}

