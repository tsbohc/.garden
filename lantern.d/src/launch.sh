launch() {

  _l() {
    exec setsid -f "$@"
  }

  _x() {
    if [[ "$opt" == "c" ]]; then
      $1
    else
      _l st -e sh -c "$1 ; exec bash" #; pkill fzf #exit 0
    fi
  }

  _d() {
    if [[ "$opt" == "c" ]]; then
      cd "$1"
    else
      _l st -e sh -c "cd $1 ; exec bash" #;  #exit 0
    fi
  }

  _e() {
    if [[ "$opt" == "c" ]]; then
      nvim "$1"
    else
      _l st -e sh -c "nvim $1 ; exec bash"# & wait ; exit 0
    fi
  }

  _f() {
    if [[ "$(file "$1")" == *"PDF"* ]]; then
      _l zathura "$1"
    else
      _e "$1"
    fi
  }

  entry="${1//\~/$HOME}"

  # black magic
  case "$2" in
    "x") _x "$entry" ;;
    "d") _d "$entry" ;;
    "e") _e "$entry" ;;
    "f") _f "$entry" ;;
    "b") _l sh -c "$entry &" ;;
    "u") _l "$entry" ;;
    "w") _l brave "$entry" ;;
    "r") _l brave "https://old.reddit.com/$entry" ;;
    *)
      echo "|$2|"
      echo "unexpected cmd"
      sleep 1s ;;
  esac
  pkill fzf # remember this
}
