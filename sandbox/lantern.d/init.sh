data=$(cat "$DATA_PATH")
[[ $# == 0 ]] && opt=c || opt=$1
case $opt in
  c)
    launch
    ;;
  w)
    st -e "$0" i
    ;;
  i)
    launch
    ;;
  g)
    clean
    ;;
  *)
    echo "usage"
    sleep 1s
    exit 1 ;;
esac
