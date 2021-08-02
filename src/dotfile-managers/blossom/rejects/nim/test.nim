#!/usr/bin/env -S nim --hints:off

# look into raise for config errors

import tables

type
  Varset = Table[string, string]

  Node = object
    name: string
    source: string
    target: string
    varset: Varset


var nodes = newTable[string, Node]()
var last_name = ""

template petal(modName, body: untyped) =
  nodes[astToStr(modName)] = Node(name: astToStr(modName))
  last_name = astToStr(modName)
  body


proc create_link(node: var Node, source, target: string) =
  node.source = source
  node.target = target

template `>>`(source, target: untyped) =
  create_link nodes[last_name], astToStr(source), astToStr(target)


proc myinject(node: var Node, varset: string) =
  echo varset

template inject(varset: typed) =
  myinject nodes[last_name], varset

var colo: string = "kohi"

template shell(body: untyped) =
  myinject nodes[last_name], varset

petal alacritty:
  alacritty.yml >> ~/.config/alacritty/alacritty.yml
  inject: 
    colo "some-ref"
  shell: 
    yay -S "alacritty"

petal test:
  rc >> ~/.config/rc

echo nodes["alacritty"]
echo nodes["test"]










# why though?
#iterator varsets(node: var Node) =
  # for v in node.varsets:














#[[
https://matthiashager.com/nim-object-oriented-programming

i can use this to make lyn(module) or module.lyn() work
---

type
  Node = object
    value: string
    active: bool

# This can then be instantiated.
var knot = Node(value: "slip")

# You can print the attributes of an object.
echo knot

proc activate(node: var Node) =
    node.active = true

activate(knot)

#knot.activate:
#  some_val = 10

echo knot
# > (value: "slip", active: true)
]]#


#import tables
#
#type
#  Varset = Table[string, string]
#  Varsets = Table[string, Varset]
#
#var
#  varsets = Varsets()
#
#varsets["one"] = Varset()
#varsets["one"]["price"] = "150"
#
#echo varsets["one"]["price"]

#proc lyn(module: string) =
#  echo module
#
#lyn "alacritty"


#const colo = "test_module"
#
#template withModule(module: string, body: untyped) =
#  echo module
#  body
#
#withModule(colo):
#  echo "some stuff"
#  echo "some more stuff"

#proc `@`(x, y: int): int =
#  result = x + y
#
#echo 12 @ 4



