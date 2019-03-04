#
# ~/.bashrc
#

[[ $- != *i* ]] && return

# sources
[[ -f ~/.aliases ]] && . ~/.aliases

# shopt
shopt -s cdspell # autocorrects cd typos
shopt -s dotglob # include .files in the expansion
shopt -s expand_aliases # expand aliases
shopt -s nocaseglob # case-insensitive expansion

shopt -s histappend # do not overwrite history
shopt -s cmdhist # save multi-line commands in history as single line

shopt -s autocd # change to named directory

export HISTCONTROL=ignoreboth:erasedups
export EDITOR=vim

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
#PS1='\e[90m┌─[\e[39m\w\e[90m]\n\e[90m└$ \e[39m'

if [ -d "$HOME/.bin" ] ;
	then PATH="$HOME/.bin:$PATH"
fi

# .Xresources to tty
get_color(){
    color=$(awk '/\*'$1':(.*)/ { print substr($2,2) }' < ~/.Xresources)
    echo $color
}

if [ "$TERM" = "linux" ] && [ shopt -q login_shell ]; then
    echo -en "\e]P0"$(get_color background)  #black
    echo -en "\e]P8"$(get_color foreground)  #darkgrey
    echo -en "\e]P1"$(get_color color1)      #darkred
    echo -en "\e]P9"$(get_color color9)      #red
    echo -en "\e]P2"$(get_color color2)      #darkgreen
    echo -en "\e]PA"$(get_color color10)     #green
    echo -en "\e]P3"$(get_color color3)      #brown
    echo -en "\e]PB"$(get_color color11)     #yellow
    echo -en "\e]P4"$(get_color color4)      #darkblue
    echo -en "\e]PC"$(get_color color12)     #blue
    echo -en "\e]P5"$(get_color color5)      #darkmagenta
    echo -en "\e]PD"$(get_color color13)     #magenta
    echo -en "\e]P6"$(get_color color6)      #darkcyan
    echo -en "\e]PE"$(get_color color14)     #cyan
    echo -en "\e]P7"$(get_color color7)      #lightgrey
    echo -en "\e]PF"$(get_color color15)     #white
    clear 
    u=$(whoami)
    echo "welcome back, ${u}"
    now=$(date +"%A %B %d, %H:%M")
    echo "it is ${now}"
fi

