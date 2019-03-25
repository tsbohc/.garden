#!/bin/bash

IFS=$'\n'
height=$(tput lines)
width=$(tput cols)
u=$(whoami)
now=$(date +"%H:%M")

kit1=(
"                         ,              \n"
"  ,-.       _.---,_ __  / \\            \n"
" /  )    ,-\"       \`./ /   \\         \n"
"(  (   .\"            \`/    /|         \n"
" \\  \`-\'            ,  \\   / |       \n"
"  \`.              . \\  \\ /  |        \n"
"   /\`.          .\"\'-----Y   |        \n"
"  (            ;        |   \'          \n"
"  |  ,-.    .-\"         |  /           \n"
"  |  | (   |     ${now}  | /            \n"
"  )  |  \\  \`.___________|/            \n"
"  \`--\"   \`--\"                       \n"
)

kit2=(
"                         ,              \n"
" ,-.        _,---._ __  / \\            \n"
"  ) )    .-\'       \`./ /   \\         \n"
" (  (  ,\'            \`/    /|         \n"
"  )  \`-\"            \\\'\\   / |      \n"
"   \\              ,  \\ \\ /  |        \n"
"   /\`.          ,\'-\`----Y   |        \n"
"  /            ;        |   \'          \n"
"  (  .-,    ,-\'         |  /           \n"
"  |  | (   |     ${now}  | /            \n"
"  )  |  \\  \`.___________|/            \n"
"  \`--\"   \`--\"                       \n"
)

center(){
  width=$(tput cols)
  padding=''
  for ((i=0; i<(width-${#1})/2; i++))
  do
    padding+=" "
  done
  printf "${padding}${1}"
}

# prepare
catwidth="............................."
for ((i=0; i<(width-${#catwidth})/2; i++))
do
  catpadding+=" "
done

output1=''
output2=''
for i in ${kit1[@]}
do
  output1+="$catpadding$i"
done

for i in ${kit2[@]}
do
  output2+="$catpadding$i"
done

# print
clear
tput civis

for s in $(seq 0 5); do
  tput cup $(((height-14)/2)) 
  center "welcome back, ${u}"
  echo

  if [ $((s%2)) -eq 0 ];
  then
    printf "${output1}"
  else
    printf "${output2}"
  fi

  read -t 0 -r && { read -r; tput cnorm; clear; startx; }
  center "starting xserver in $((5-s)) [enter]\r"
  sleep 1
  echo
  if [ $s = 5 ]; then
    #startx
    echo woo
  fi
done

echo
clear
