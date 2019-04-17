#!/bin/bash

# =======================================
# config
# =======================================

# xorg-drivers contains xf86-synaptics that's unneeded
read -d '' bundles << EOF
xorg:          xorg xorg-xinit xorg-drivers xterm
pulseaudio:    pulseaudio pulseaudio-alsa pacmixer
neovim:        neovim python2-pip python-pip xsel
i3:            i3-gaps xorg-util-macros python-i3-py
dev:           cmake lua
ui:            compton xflux rofi polybar feh
media:         mpv
zathura:       zathura zathura-pdf-mupdf zathura-djvu
cli:           fzf
fonts:         tamzen-font-git
pip:           pynvim
pip2:          pynvim
EOF

read -d '' links << EOF
bashrc                        ~/.bashrc
aliases                       ~/.aliases
bash_profile                  ~/.bash_profile
xinitrc                       ~/.xinitrc
Xresources                    ~/.Xresources
vimrc                         ~/.vimrc
vim/colors/jellybeans.vim     ~/.vim/colors/jellybeans.vim
vim/nvim_init.vim             ~/.config/nvim/init.vim
i3                            ~/.config/i3/config
compton                       ~/.config/compton.conf
polybar                       ~/.config/polybar/config
EOF
# lightline theme install moved to plug.vim 'do' statement

read -d '' directories << EOF
~/Downloads
~/Pictures
~/Projects
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
  while read -r bundle; do
    bundle=($bundle)
    name=${bundle[0]%?} # remove colon
    title "setting up $name"
    if [[ $name == pip ]]; then # determine appropriate install command
      cmd="sudo pip install -q"
    elif [[ $name == pip2 ]]; then
      cmd="sudo pip2 install -q"
    else
      cmd="yay -S --needed --noconfirm"
    fi
    for package in "${bundle[@]:1}"; do # the :1 skips the first element
      run_command "$cmd $package" "$package"
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
  title "checking for updates"
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
}

create_symlinks() {
  title "linking dots"
  while read -r line; do
    sleep 0.05 # because it looks cooler
    line=($line)
    src=${line[0]}
    dst=${line[1]}
    abs_src=$(get_abspath "$src")
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
      fi
      # if dst is already a symlink
      if [[ -L "$abs_dst" ]]; then
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
            log ">" $yellow "$src$arrow$dst"
          fi
        # if dst is a symlink and points to the same file
        else
          if [[ $dry == no ]]; then
            log ">" $blue "$src$equals$dst"
          else
            log ">" $yellow "$src$equals$dst"
          fi
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
title() { echo -e "--- "$1$dots; }

ask_user() {
  log "?" $yellow "$1 [y/n] | \c"
  read -n 1 -r # what does -r do?
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
   d, dry         just print without running, includes all options
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
  selected_file=$(find . -type f ! -path "*/.git*/*" ! -path "*/sl/*" ! -path "*/fonts/*" | cut -c 3- | fzf --no-bold --reverse)
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
      fuzzy_edit
    fi
  fi
  exit 1
else
    case $1 in # the first agrument has to be an action
    i|install)
      dry=no;;
    d|dry)
      dry=yes
      should_install_packages=yes
      should_setup_vim=yes;;
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
  run_command "sudo sed -i 's/#Color/Color/' /etc/pacman.conf"
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
  run_command "cp /etc/hosts /etc/hosts_bk"
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
  # install plug if needed
  if [[ ! -f $(get_abspath "~/.config/nvim/autoload/plug.vim") ]]; then
    title "intalling plug"
    run_command "curl -sS --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -o $(get_abspath ~/.config/nvim/autoload/plug.vim)" "curl junegunn/vim-plug > ~/.config/nvim/autoload/plug.vim"
  fi
  # update neovim plugs
  title "updating neovim plugins"
  run_command "nvim +:PlugInstall +:qa"
fi

# symlink everything
create_symlinks

# print closing message
if [[ $dry == no ]]; then
  title "finishing up"
else
  title "completing dry run"
fi
