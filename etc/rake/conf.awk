#!/bin/awk -f

# so if I have prefix, could't i nest these?
#
# root: "something"
#   branch: "a branch"
#     leaf: "$(conf.awk some_file "root_branch_leaf")"
# or  leaf: conf.awk some_file "root_branch_leaf"
#
# annoying to specify, but could be useful
# i mean i could detect "$(conf.awk " in a key and insert prefix manually...
# because it would end up running the command and prefix all variables with the appropriate path
#
# like root_branch_leaf_key1
#      root_branch_leaf_key2
#      ...

{
  pp("conf.yaml")
}

function pp(c){
  print $0
  if ($0 == "subconf.yaml") {
    pp("subconf.yaml")
  }
}

#BEGIN {
#  FS=": "
#} {
#  # get indent in twos
#  match($0, /^ */)
#  indent = RLENGTH / 2
#
#  # strip indent from the key
#  key=substr($1, RLENGTH+1)
#  com=substr(key, 1, 1)
#
#  # skip comments
#  if (com != "#" && length(key) > 0) {
#    val = ""
#    # get everything after the first delimiter match
#    for (i = 2; i <= NF; i++) {
#      val = (val)($i)": "
#    }
#    # remove trailing delimiter
#    val = substr( val, 1, length(val)-2 )
#
#    # https://stackoverflow.com/a/21189044
#    vname[indent] = key
#    for (i in vname) {
#      if (i > indent) { delete vname[i] }
#    }
#    if (length(val) > 0) {
#      path = ""
#      for (i = 0; i < indent; i++) {
#        path = (path)(vname[i])"_"
#      }
#      printf("__%s%s=%s\n", path, key, val);
#    }
#  }
#}
