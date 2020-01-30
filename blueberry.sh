#!/bin/bash

# TODO: create a new file if argless bb doesn't find anything

# =======================================
# config
# =======================================

# i3:            i3-gaps xorg-util-macros python-i3-py
# neovim:        xsel
# zathura:       zathura zathura-pdf-mupdf zathura-djvu
# ux:            compton xflux rofi feh
read -d '' bundles << EOF
xorg:          xorg-server xorg-xinit xterm
pulseaudio:    pulseaudio pulseaudio-alsa alsa-utils
dev:           cmake lua
bspwm:         bspwm sxhkd xtitle xdo
neovim:        neovim python2-pip python-pip
pip:           pynvim
pip2:          pynvim
media:         mpv
cli:           fzf cat
fonts:         tamzen-font-git
EOF

# compton                       ~/.config/compton.conf
# i3                            ~/.config/i3/config
# vim/colors/jellybeans.vim     ~/.vim/colors/jellybeans.vim
read -d '' links << EOF
bashrc                        ~/.bashrc
aliases                       ~/.aliases
bash_profile                  ~/.bash_profile
xinitrc                       ~/.xinitrc
Xresources                    ~/.Xresources
polybar                       ~/.config/polybar/config
bspwmrc                       ~/.config/bspwm/bspwmrc
sxhkdrc                       ~/.config/sxhkd/sxhkdrc
vimrc                         ~/.vimrc
vim/nvim_init.vim             ~/.config/nvim/init.vim
picom                         ~/.config/picom.conf
EOF

# ~/Downloads
# ~/Pictures
read -d '' directories << EOF
~/blueberry
EOF

# =======================================
# the meat
# =======================================

expand_home() { echo "${1/#\~/$HOME}"; } # unused

get_abspath() {
  if [[ $1 == "~"* ]]; then #passing path w/ ~ as a string does not expand the ~
    relpath=${1/"~"/$HOME}
  else
    relpath=$1
  fi
  if [[ -d "$relpath" ]]; then
      (cd "$relpath"; pwd)
  elif [[ -f "$relpath" ]]; then
      # file
      if [[ $relpath = /* ]]; then
          echo "$relpath"
      elif [[ $relpath == */* ]]; then
          echo "$(cd "${relpath%/*}"; pwd)/${relpath##*/}"
      else
          echo "$(pwd)/$relpath"
      fi
  else
    echo "$(realpath -m $relpath)"
  fi
}

run_command() {
  if [[ $dry == no ]]; then
    if [[ ! $2 ]]; then
      log ">" $green "$1\c"
    else
      log ">" $green "$2\c"
    fi
    out=$($1 2>&1)
    if [[ $? -eq 0 ]]; then
      echo -e "\r"[$blue+$escape]
    else
      echo -e "\r"[$red!$escape]
      echo "$out"
    fi
  else
    if [[ ! $2 ]]; then
      log ">" $yellow "$1"
    else
      log ">" $yellow "$2"
    fi
  fi
}

install_packages() {
  title "installing package bundles"
  while read -r bundle; do
    bundle=($bundle)
    name=${bundle[0]%?} # remove colon
    if [[ $name == pip ]]; then # determine appropriate install command
      title "installing pip3 bundle"
      cmd="sudo pip install -q"
    elif [[ $name == pip2 ]]; then
      title "installing pip2 bundle"
      cmd="sudo pip2 install -q"
    else
      cmd="yay -S --needed --noconfirm"
    fi
    for package in "${bundle[@]:1}"; do # the :1 skips the first element
      if ! yay -Qs $package > /dev/null ; then
        run_command "$cmd $package" "$package"
      fi
    done
  done <<< "$bundles"
}

create_directories() {
  should_make_dirs=no
  while read -r path; do
    dst=$(get_abspath $path)
    if [[ ! -d "$dst" ]]; then
      should_make_dirs=yes
      break
    fi
  done <<< "$directories"
  if [[ $should_make_dirs == yes ]]; then
    title "creating directories"
    while read -r path; do
      sleep 0.05 # makes it look cooler
      dst=$(get_abspath $path)
      if [[ ! -d "$dst" ]]; then
        if [[ $dry == no ]]; then
          log "+" $blue "$path\c"
          echo "/"
          mkdir -p $dst
        else
          log "+" $yellow "$path\c"
          echo "/"
        fi
      fi
    done <<< "$directories"
  fi
}

update() {
  clear
  welcome
  cd ~/blueberry
  title "checking for updates"
  if ping -q -c 1 -w 1 google.com >/dev/null 2>&1; then
    run_command "git fetch"
    log "+" $blue "git status"
    git_status=$(git status 2>&1)
    if [[ $git_status == *"behind"* ]]; then
      if ask_user "the local branch is behind, pull?"; then
        run_command "git pull"
      fi
    elif [[ $git_status == *"ahead"* || $git_status == *"hanges not staged for commit:"* ]]; then
      if ask_user "the local branch is ahead, push?"; then
        run_command "git add ."
        log "?" $yellow "enter a commit message | \c"
        read commit_message
        log ">" $green "git commit -m ""$commit_message"
        git commit -m "$commit_message"
        run_command "git push" "git push \n"
      fi
    else
      log "i" $yellow "there is nothing to do"
    fi
  else
    log "!" $red "no internet connection"
  fi
}

create_symlinks() {
  title "linking dots"
  while read -r line; do
    sleep 0.05 # because it looks cooler
    line=($line)
    src=${line[0]} #add script path
    dst=${line[1]}
    abs_src="${0%/*}/"$src
    abs_dst=$(get_abspath "$dst")
    # check if source file exists
    if [[ -f "$abs_src" ]]; then
      # stop if target exists and is not a symlink
      if [[ -f "$abs_dst" && ! -L "$abs_dst" ]]; then
        log "#" $red $dst
        if [[ $dry == no ]]; then
          # conflict handling
          if [[ $care == unset ]]; then
            if ask_user "do you care about backing up non-symlinks?"; then
              care=yes
            else
              care=no
            fi
          fi
          # backups
          if [[ $care == yes ]]; then
            if ask_user "non-symlink found, back it up?"; then
              # create backup dir if it doesn't exist
              if [[ -d "backup" ]]; then
                log "+" $green "backup/"
                mkdir backup
              fi
              log "+" $green "backup/$dst"
              cp "$abs_dst" "backup/${abs_dst##*/}$(date + '-%Y-%m-%d_%H-%M-%S')"
            else
              rm "$abs_dst"
            fi
          else
            rm "$asb_dst"
          fi
        fi
      # if dst is already a symlink
      elif [[ -L "$abs_dst" ]]; then
        # and doesn't point to the same file
        if [[ ! $(readlink -f "$asb_dst") == "$abs_src" ]]; then
          #create necessary directories
          if [[ ! -d "${abs_dst%/*}" ]]; then
            if [[ $dry == no ]]; then
              log "+" $green "$dst"
              mkdir -p "${abs_dst%/*}"
            else
              log "+" $yellow "$dst"
            fi
          fi
          # actual symlinking
          if [[ $dry == no ]]; then
            log "+" $blue "$src$arrow$dst"
            ln -sfn $abs_src $abs_dst
          else
            log ">" $yellow "$abs_src$arrow$abs_dst"
          fi
        # if dst is a symlink and points to the same file
        else
          if [[ $dry == no ]]; then
            log ">" $blue "$src$equals$dst"
          else
            log ">" $yellow "$src$equals$dst"
          fi
        fi
      elif [[ ! -f "$abs_dst" ]]; then
        #create necessary directories
        if [[ ! -d "${abs_dst%/*}" ]]; then
          if [[ $dry == no ]]; then
            log "+" $green "${abs_dst%/*}"
            mkdir -p "${abs_dst%/*}"
          else
            log "+" $yellow "${abs_dst%/*}"
          fi
        fi
        # actual symlinking
        if [[ $dry == no ]]; then
          log "+" $blue "$src$arrow$dst"
          ln -sfn $abs_src $abs_dst
        else
          log ">" $yellow "$abs_src$arrow$abs_dst"
        fi
      fi
    else
      log "#" $red "$src$colon missing source file, skipping"
    fi
  done <<< "$links"
}

# =======================================
# print functions
# =======================================

red="\x1b[31m"
green="\x1b[32m"
yellow="\x1b[33m"
blue="\x1b[34m"
gray="\x1b[90m"
escape="\x1b[0m"

dots=$blue"..."$escape
arrow=$blue" > "$escape
colon=$blue": "$escape
equals=$blue" = "$escape

log() { echo -e "["$2$1$escape"] "$3; }
title() { echo -e "─── "$1$dots; }

ask_user() {
  log "?" $yellow "$1 [y/n] | \c"
  read -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    true
  elif [[ ! $REPLY =~ ^[Nn]$ ]]; then
    false
    log "#" $red "please enter a valid choice"
    ask_user $1
  else
    false
  fi
}

welcome() {
  echo -e $blue"       _
  /   //         /
 /__ //  . . _  /__ _  __  __  __  ,
/_) </_ (_/_</_/_) </_/ (_/ (_/ (_/_ ❤ 
                                 /
                                ' "$escape
}

usage="usage: bb {install|dry|update|edit} [-p] [-v]

perform:
   i, install     perform installation
   d, dry         just print without running
   u, update      sync to or from a git repo
   e, edit        fzf into $EDITOR in the script location
                  runs when no arguments are given
install:
  -p       install package bundles
  -v       set up nvim via plug"

# =======================================
# the ears
# =======================================

care=unset
dry=no
should_install_packages=no
should_setup_vim=no

fuzzy_edit() {
  current_dir=$(pwd 2>&1)
  cd ~/blueberry
  selected_file=$(find . -type f ! -path "*/.git*/*" ! -path "*/sl/*" ! -path "*/fonts/*" | cut -c 3- | fzf --no-bold --reverse --preview="bat --color=always --style=numbers --line-range :69 {}" --preview-window=right:70%)
  if [[ $selected_file != "" ]]; then
    $EDITOR "$selected_file"
    log ">" $blue "$selected_file"
  fi
  cd $current_dir
}

# parsing the arguments
if [[ $# -eq 0 || $1 == "e" || $1 == "edit" ]]; then
  # launch fzf if no arguments are supplied
  if [[ -f /usr/bin/fzf ]]; then
    fuzzy_edit
  else
    log "i" $yellow "could not find fzf"
    if ask_user "install it?"; then
      run_command "sudo pacman -S fzf --noconfirm"
      echo ""
      fuzzy_edit
    fi
  fi
  exit 1
else
    case $1 in # the first agrument has to be an action
    i|install)
      dry=no;;
    d|dry)
      dry=yes;;
    u|update)
      update
      exit 1;;
    h|help|*)
      echo "$usage"
      exit 1;;
  esac
  OPTIND=2 # makes getopts parse arguments starting from the second
  while getopts "pv" opt; do
    case $opt in
      p) should_install_packages=yes;;
      v) should_setup_vim=yes;;
    esac
  done
fi

# =======================================
# the bones
# =======================================

# print logo
welcome

# ask for sudo rights
if [[ $dry == no ]]; then
  sudo -v
  echo "" > .log # clear the log file
fi

# add color to pacman
if grep -Fqx "#Color" "/etc/pacman.conf"; then
  title "adding color to pacman output"
  run_command "sudo sed -i -e s/#Color/Color/g /etc/pacman.conf"
fi

# install yay if needed
if [[ ! -f /usr/bin/yay ]]; then # not sure if yay is a dir, check
  title "installing yay"
  run_command "git clone https://aur.archlinux.org/yay.git"
  run_command "cd yay"
  run_command "makepkg -si --noconfirm"
  run_command "cd .."
  run_command 'rm -rf yay' # careful
  run_command "yay -Syuu"
fi

# install/update system wide adblock
title "installing hostblock"
if [[ ! -f /etc/hosts_bk ]]; then
  run_command "sudo cp /etc/hosts /etc/hosts_bk"
fi
run_command "sudo curl -sS https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts -o /etc/hosts" "curl StevenBlack/hosts > /etc/hosts"

# install/update z.lua
title "updating z.lua"
run_command "curl -sS --create-dirs https://raw.githubusercontent.com/skywind3000/z.lua/master/z.lua -o $(get_abspath ~/blueberry/sc/z.lua)" "curl skywind3000/z.lua > sc/z.lua"

# create necessary directories
create_directories

# install needed packages
if [[ $should_install_packages == yes ]]; then
  install_packages
fi

if [[ $should_setup_vim == yes ]]; then
  title "updating neovim plugins"
  run_command "nvim +:PlugInstall +:qa"
fi

# symlink everything
#echo "${0%/*}"
create_symlinks
#cd ~

# print closing message
if [[ $dry == no ]]; then
  title "finishing up"
else
  title "completing dry run"
fi
