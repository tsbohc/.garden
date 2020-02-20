data=$(cat "$DATA_PATH")

[[ $# == 0 ]] && opt=c || opt=$1
case $opt in
  c)
    fzf_margin="--margin=1,2"
    fzf_height="--height=10"
    main
    ;;
  w)
    xdotool search --onlyvisible --classname $WINDOW_NAME windowunmap \
      || xdotool search --classname $WINDOW_NAME windowmap \
      || st -n $WINDOW_NAME -a -g "35x7+0+0" -e "$0" i
    ;;
  i)
    fzf_height="--height=100"
    fzf_margin="--margin=2"
    main
    ;;
  g)
    clean
    ;;
  *)
    echo "usage"
    sleep 1s
    return
    ;;
esac

echo "$data" > "$DATA_PATH"

