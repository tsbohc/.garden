#!/bin/bash

#    ______
#   (. /   )          /
#     /---\ __.  _   /_  __  _.
#    / ___/(_/|_/_)_/ /_/ (_(__
# (_/ (

[[ $- != *i* ]] && return

# sources
[[ -f ~/.aliases ]] && . ~/.aliases

# z.lua
eval "$(lua ~/blueberry/sc/z.lua --init bash)"

# shopt
shopt -s cdspell # autocorrects cd typos
shopt -s dotglob # include .files in the expansion
shopt -s expand_aliases # expand aliases
shopt -s nocaseglob # case-insensitive expansion
bind 'set completion-ignore-case on' # case-insensitive tab completion

shopt -s histappend # do not overwrite history
shopt -s cmdhist # save multi-line commands in history as single line

shopt -s autocd # change to named directory

# history
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=5000
export HISTFILESIZE=5000
PROMPT_COMMAND="history -a; history -n"

# exports
export EDITOR=nvim

# prompt
CGREEN='\[\e[32m\]'
CRED='\[\e[31m\]'
CESCAPE='\[\e[0;39m\]'

git_branch() {
  local status=$(git status --porcelain 2>/dev/null)
  if [[ "$status" != "" ]]; then
    git symbolic-ref HEAD --short 2>/dev/null | sed -e 's/^/ {/' -e 's/$/}/'
  else
    git symbolic-ref HEAD --short 2>/dev/null | sed -e 's/^/ [/' -e 's/$/]/'
  fi
}

PS1="\w${CGREEN}\$(git_branch)${CESCAPE}${CGREEN} > ${CESCAPE}"

#if [ -d "$HOME/.bin" ] ;
if [ -d "$HOME/blueberry/sc" ] ;
  then PATH="$HOME/blueberry/sc:$PATH"
fi

# colored man pages
export LESS_TERMCAP_md=$'\e[1;33m'  #titles
export LESS_TERMCAP_us=$'\e[1;32m'  #options
export LESS_TERMCAP_so=$'\e[0m'     #bottom text
export LESS_TERMCAP_mb=$'\e[0m'     #nothing
export LESS_TERMCAP_me=$'\e[0m'     #half the text, marks, buggy
export LESS_TERMCAP_se=$'\e[0m'     #weird, scroll dependent
export LESS_TERMCAP_ue=$'\e[0m'     #nothing

# .Xresources to tty

if [ "$TERM" = "linux" ]; then
#  echo -en "\e]P0"$(get_color background)  #black
#  echo -en "\e]P8"$(get_color foreground)  #darkgrey
#  echo -en "\e]P1"$(get_color color1)      #darkred
#  echo -en "\e]P9"$(get_color color9)      #red
#  echo -en "\e]P2"$(get_color color2)      #darkgreen
#  echo -en "\e]PA"$(get_color color10)     #green
#  echo -en "\e]P3"$(get_color color3)      #brown
#  echo -en "\e]PB"$(get_color color11)     #yellow
#  echo -en "\e]P4"$(get_color color4)      #darkblue
#  echo -en "\e]PC"$(get_color color12)     #blue
#  echo -en "\e]P5"$(get_color color5)      #darkmagenta
#  echo -en "\e]PD"$(get_color color13)     #magenta
#  echo -en "\e]P6"$(get_color color6)      #darkcyan
#  echo -en "\e]PE"$(get_color color14)     #cyan
#  echo -en "\e]P7"$(get_color color7)      #lightgrey
#  echo -en "\e]PF"$(get_color color15)     #white
#  clear

  [[ -f ~/blueberry/fonts/TamzenForPowerline8x16.psf ]] && setfont ~/blueberry/fonts/TamzenForPowerline8x16.psf
  [[ -f ~/blueberry/sc/catlogin.sh ]] && . ~/blueberry/sc/catlogin.sh
fi
