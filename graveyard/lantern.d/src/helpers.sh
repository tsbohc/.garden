get_abspath() {
  echo "$(realpath -m --no-symlinks ${1/"~"/$HOME})"
}

ask() {
  tput sc
  echo -e "    y/n? > ${white}\c"
  read -n 1 -r < /dev/tty # lack of redirect breaks the function in a while loop
  echo -e "$escape"
  case "$REPLY" in
    Y|y) true ;;
    N|n) false ;;
    *)
      false
      tput rc && tput ed
      ask "$1"
      ;;
  esac
}
