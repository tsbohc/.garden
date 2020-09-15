terminals=",st,xterm,"

classes="$(xprop WM_CLASS | awk -F"=" '{ print $2 }' | tr -d '"')"

echo "$classes"

IFS=', ' read -r -a classes_array <<< "$classes"
for class in "${classes_array[@]}"; do
  if grep -q ",$class," <<< "$terminals"; then
  fi
done
