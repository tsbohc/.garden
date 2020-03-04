# TODO: it'd be super cool if we were contextually aware, and showed entries that are in the pwd at the top

# disable unicode to speed things up
export LC_ALL=C

# since our delimiter is ascii
d=""

# load config
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/config.sh"

# load data and create it if it doesn't exist
[ -f "$LANTERN_DATA" ] && data=$(<"$LANTERN_DATA") || touch "$LANTERN_DATA"

init() {
  [[ $# == 0 ]] && opt=c || opt=$1

  case $opt in
    c)
      fzf_margin="--margin=1,2"
      fzf_height="--height=10"
      main
      ;;
    w)
      xdotool search --onlyvisible --classname "lantern" windowunmap \
        || xdotool search --classname "lantern" windowmap \
        || st -n "lantern" -a -g "35x7+0+0" -e "$0" i
      ;;
    i)
      fzf_height="--height=100"
      fzf_margin="--margin=2"
      main
      ;;
    # guess action got chopped
    #a)
    #  local e="$(history 2 | head -n 1 | awk '{ print $2 }')"
    #  local a=$(guess_action "$e")
    #  data+=$(new_entry "$e" "$a")
    #  ;;
    h|help)
      echo "usage"
      ;;
    *)
      return
      ;;
  esac

  # write to file
  echo "$data" > "$LANTERN_DATA"

  #pkill fzf
}
