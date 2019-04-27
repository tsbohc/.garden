#!/bin/bash

tput civis

arr=('el1' 'el2' 'el3' 'el4' 'el5' 'el6')

get_cursor_pos() {
  exec < /dev/tty
  oldstty=$(stty -g)
  stty raw -echo min 0
  echo -en "\033[6n" > /dev/tty
  IFS=';' read -r -d R -a pos
  stty $oldstty
  row=$((${pos[0]:2}-1))
  col=$((${pos[1]}-1))
  echo $row
}

move_cursor() {
  read -n 1 -s -r
  if [[ $REPLY =~ ^[JjKkLl]$ ]]; then
    prev_pos=$curr_pos
    tput cup $prev_pos $hori_pos
    echo -e "  \033[2m${arr[$curr_pos-$min]}"
    if [[ $REPLY =~ ^[Jj]$ ]]; then
      if [ "$curr_pos" -lt "$max" ]; then
        ((curr_pos++))
      fi
    elif [[ $REPLY =~ ^[Kk]$ ]]; then
      if [ "$curr_pos" -gt "$min" ]; then
        ((curr_pos--))
      fi
    elif [[ $REPLY =~ ^[Ll]$ ]]; then
      tput cup $(($min+${#arr[@]})) $hori_pos
      tput cnorm
      result=${arr[$curr_pos-$min]}
      echo -e "\033[0m\c"
      return
    fi
    tput cup $curr_pos $hori_pos
    echo -e "\033[0m> ${arr[$curr_pos-$min]}\033[0m"
  fi
  move_cursor
}

min=$(get_cursor_pos)

# add whitespace and shift if at the bottom of term window
if [ $(($(get_cursor_pos)+${#arr[@]})) -gt $(tput lines) ]; then
  for ((i=0; i<${#arr[@]}; i++)); do
    echo
  done
  min=$(($min-${#arr[@]}))
  tput cup $min $hori_pos
fi

max=$(($min+${#arr[@]}-1))
hori_pos=1
curr_pos=$min

count=0
for i in "${arr[@]}"; do
  if [[ $count == 0 ]]; then
    echo -e "\033[0m\c"
  else
    echo -e "\033[2m\c"
  fi
  echo -e "   $i\033[0m"
  ((count++))
done

tput cup $min $hori_pos
echo ">"
move_cursor
echo "$result"
