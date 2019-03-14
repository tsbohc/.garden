#!/usr/bin/env python3

import json
import os
import shutil
import subprocess
import datetime
import time
import sys
import argparse

dry = True
care = 'unset'

link = {
    'bashrc': '~/.bashrc',
    'aliases': '~/.aliases',
    'bash_profile': '~/.bash_profile',
    'xinitrc': '~/.xinitrc',
    'Xresources': '~/.Xresources',
    'vimrc': '~/.vimrc',
    'vim/colors/jellybeans.vim': '~/.vim/colors/jellybeans.vim',
    'vim/nvim_init.vim': '~/.config/nvim/init.vim',
    # lightline theme install moved to plug.vim 'do' statement
    'i3': '~/.config/i3/config',
    'compton': '~/.config/compton.conf',
    'polybar': '~/.config/polybar/config'
    }

mkdir = ['~/Downloads', '~/Pictures', '~/Projects']

pip_packages = ['pynvim']
pip2_packages = ['pynvim']

base_packages = [
    'xorg', 'xorg-xinit', 'xorg-drivers', 'xterm', # xserver base 
    'cmake', 'lua', # compile reqs
    'neovim', 'python2-pip', 'python-pip', 'xsel', # nvim & deps, clipboard
    'compton', 'xflux', 'fzf',
    'tamzen-font-git'
    ]

i3wm_packages = [
    'i3-gaps', 'xorg-util-macros', 'python-i3-py', # i3wm & scripting 
    'rofi', 'polybar', 'feh'
    ]

def main():
    subprocess.run('clear')
    os.chdir(os.path.dirname(os.path.realpath(__file__)))
    print(colors['blue'] + """
         _                                
    /   //         /                      
   /__ //  . . _  /__ _  __  __  __  ,    
  /_) </_ (_/_</_/_) </_/ (_/ (_/ (_/_ ❤  
                                   /      
                                  '  """ + colors['escape'])

    global dry
    if args.install:
        dry = False

    if args.update:
        dry = False
        update()
    
    # ask for sudo & empty the log
    if not dry:
        subprocess.run('sudo -v', shell=True)
        subprocess.run('echo "" > .log', shell=True)

    #run_command('yay -Syyu')

    # add color to pacman output
    f = open('/etc/pacman.conf')
    try:
        if '#Color' in f.read():
            echo_title('adding color to pacman output')
            run_command("sudo sed -i 's/#Color/Color/' /etc/pacman.conf")
    finally:
        f.close()

    # hosts-based adblock
    echo_title('installing hostblock')
    if not dry and not os.path.exists('/etc/hosts_bk'):
        run_command('sudo cp /etc/hosts /etc/hosts_bk') 
    run_command('sudo bash -c "curl -sS https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts > /etc/hosts"', 'curl StevenBlack/hosts > /etc/hosts')
    
    # install yay if needed
    if not os.path.exists('/usr/bin/yay'):
        echo_title('installing yay')
        if not dry:
            run_command('git clone https://aur.archlinux.org/yay.git')
            os.chdir('yay')
            run_command('makepkg -si --noconfirm')
            os.chdir('..')
            echo_log('>', 'green', 'cleaning up')
            shutil.rmtree('yay')
            run_command('yay -Syu')
        else:
            echo_log('>', 'yellow', 'git clone https://aur.archlinux.org/yay.git')
            echo_log('>', 'yellow', 'cd yay')
            echo_log('>', 'yellow', 'makepkg -si --noconfirm')
            echo_log('>', 'yellow', 'cd ..')
            echo_log('>', 'yellow', 'rm -r yay')
            echo_log('>', 'yellow', 'yay -Syu')

    # update z.lua 
    echo_title('updating z.lua')
    run_command('curl -sS https://raw.githubusercontent.com/skywind3000/z.lua/master/z.lua > ~/blueberry/scripts/z.lua', 'curl skywind3000/z.lua > scripts/z.lua')
    
    # mkdirs
    create_directories(mkdir)

    if args.packages:
        # install base
        echo_title('installing base packages')
        install_packages(base_packages)

        # setup i3wm
        echo_title('setting up i3')
        install_packages(i3wm_packages)

        echo_title('installing pip2 packages')
        for count, pkg in enumerate(pip2_packages):
            run_command('sudo pip2 install ' + pkg + ' -q', str(format(count+1, '02d')) + '/' + str(format(len(pip2_packages), '02d')) + ' ' + pkg)

        echo_title('installing pip packages')
        for count, pkg in enumerate(pip_packages):
            run_command('sudo pip install ' + pkg + ' -q', str(format(count+1, '02d')) + '/' + str(format(len(pip_packages), '02d')) + ' ' + pkg)

    if args.vim:
        # install plug if needed
        if not os.path.exists(os.path.expanduser('~/.config/nvim/autoload/plug.vim')):
            echo_title('installing plug')
            run_command('curl -sS https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > ~/.config/nvim/autoload/plug.vim', 'curl junegunn/vim-plug > ~/.config/nvim/autoload/plug.vim')

        # update nvim plugs
        echo_title('updating nvim plugins')
        run_command("nvim +:PlugInstall +:qa")
    
    # symlink
    echo_title('linking dots')
    [create_symlink(src, dst) for src, dst in link.items()]

    if not dry:
        echo_title('finishing up') 
    else:
        echo_title('completing dry run')

# =======================================
# print functions
# =======================================

colors = {
    'red': '\x1b[31m',
    'green': '\x1b[32m',
    'yellow': '\x1b[33m',
    'blue': '\x1b[34m',
    'gray': '\x1b[90m',
    'escape': '\x1b[0m'
}

dots = colors['blue'] + '...' + colors['escape']
colon = colors['blue'] + ': ' + colors['escape']
arrow = colors['blue'] + ' > ' + colors['escape']

def echo_log(icon, color, string, end=True):
    if end == True:
        print('[' + colors[color] + icon + colors['escape'] + '] ' + string) 
    else:
        print('[' + colors[color] + icon + colors['escape'] + '] ' + string, end='') 

def echo_title(string):
    print('--- ' + string + dots)

def echo_question(prompt):
    valid = { "yes":True, 'y':True, "no":False, 'n':False }
    while True:
        echo_log('?', 'yellow', prompt + " [y/n] | ", False)
        choice = input().lower()
        if choice in valid:
            return valid[choice]
        else:
            echo_log('#', 'red', 'please enter a valid choice')

# =======================================
# code that actually does stuff
# =======================================

def install_packages(packages):
    for count, pkg in enumerate(packages):
        if not dry:
            echo_log('>', 'green', str(format(count+1, '02d')) + '/' + str(format(len(packages), '02d')) + ' ' + pkg, end=False)
            sys.stdout.flush()
            try:
                output = subprocess.check_output('yay -S --needed --noconfirm ' + pkg + ' >> .log 2>&1', stderr=subprocess.STDOUT, shell=True)
            except subprocess.CalledProcessError:
                print('\r[' + colors['red'] + '#' + colors['escape'] + ']')
                echo_log('i', 'yellow', 'see the .log file at line ' + file_len('.log'))
            else:
                print('\r[' + colors['blue'] + '+' + colors['escape'] + ']')
        else:
            echo_log('>', 'yellow', str(format(count+1, '02d')) + '/' + str(format(len(packages), '02d')) + ' ' + pkg)

def run_command(command, message=False):
    if not dry:
        if message:
            echo_log('>', 'green', message, end=False)
        else:
            echo_log('>', 'green', command, end=False)
        sys.stdout.flush()
        try:
            output = subprocess.check_output(command, shell=True)
        except subprocess.CalledProcessError:
            print('\r[' + colors['red'] + '#' + colors['escape'] + ']')
        else:
            print('\r[' + colors['blue'] + '+' + colors['escape'] + ']')
    else:
        if message:
            echo_log('>', 'yellow', message)
        else:
            echo_log('>', 'yellow', command)

def file_len(fname):
    with open(fname) as f:
        for i, l in enumerate(f):
            pass
    return str(i + 1)

def create_directories(directories):
    should_make_dirs = False
    for path in directories:
        dst = os.path.expanduser(path)
        if not os.path.isdir(dst):
            should_make_dirs = True
            
    if should_make_dirs:
        echo_title('creating directories')
        for path in directories:
            dst = os.path.expanduser(path)
            if not os.path.isdir(dst):
                if not dry:
                    echo_log('+', 'blue', path)
                    os.makedirs(dst)
                else:
                    echo_log('+', 'yellow', path)

def check_symlink(path):
    if os.path.islink(path):
        target_path = os.readlink(path)
        if not os.path.isabs(target_path):
            target_path = os.path.join(os.path.dirname(path), target_path)
        if not os.path.exists(target_path):
            return True

def create_symlink(src, dst):
    dst = os.path.expanduser(dst)
    src = os.path.abspath(src)
    backup_dir = os.path.abspath('backup')
    global care

    # check if source file exists
    if os.path.exists(src):

        # create necessary dirs
        if not os.path.isdir(os.path.dirname(dst)):
            if not dry:
                echo_log('+', 'green', os.path.dirname(dst))
                os.makedirs(os.path.dirname(dst))
            else:
                echo_log('+', 'yellow', os.path.dirname(dst))
        
        # check for broken symlinks
        if check_symlink(dst):
            if not dry:
                echo_log('×', 'yellow', '~/' + os.path.relpath(dst, os.path.expanduser('~')) + colon + 'broken symlink, removing' + dots)
                os.remove(dst)
            else:
                echo_log('×', 'yellow', '~/' + os.path.relpath(dst, os.path.expanduser('~')) + colon + 'broken symlink')

        # stop if a non-symlink with the same name is found
        if os.path.isfile(dst) and not os.path.islink(dst):
            echo_log('#', 'red', '~/' + os.path.relpath(dst, os.path.expanduser('~')))
            if not dry:
                if care == 'unset':
                    if echo_question("do you care about non-symlink backups?"):
                        care = True
                    else:
                        care = False
                if care:
                    if echo_question("non-symlink found, back it up?"):
                        if not os.path.isdir(backup_dir): 
                            os.mkdir(backup_dir)
                        echo_log('+', 'green', os.path.relpath(os.path.join(backup_dir, datetime.datetime.now().strftime('%Y-%m-%d_%H-%M-%S') + '_' + os.path.basename(dst))))
                        os.rename(dst, os.path.join(backup_dir, os.path.basename(dst) + '_' + datetime.datetime.now().strftime('%Y-%m-%d_%H-%M-%S')))
                    else:
                        os.remove(dst)
                else:
                    os.remove(dst)
            #else:
                #echo_log('?', 'yellow', 'ask what to do with the file')
        
        # actually symlink
        if not dry:
            echo_log('+', 'blue', os.path.relpath(src) + arrow + '~/' + os.path.relpath(dst, os.path.expanduser('~')))
            if os.path.islink(os.path.expanduser(dst)):
                os.remove(os.path.expanduser(dst))
            os.symlink(src, dst)
        else:
            echo_log('+', 'yellow', os.path.relpath(src) + arrow + '~/' + os.path.relpath(dst, os.path.expanduser('~')))
    else:
        echo_log('#', 'red', os.path.relpath(src) + colon + 'missing source file' + dots)

def reap():
    if 'link' in js:
        echo_title('reaping configs')
        for src, dst in js['link'].items():
            exp_dst = os.path.expanduser(dst)
            exp_src = os.path.abspath(src)
            if not os.path.islink(exp_dst):
                if not os.path.exists(exp_src):
                    log('+', 'green', dst + colon + src)
                    os.rename(exp_dst, exp_src)
                else:
                    log('#', 'red', dst + colon + 'file is already on the local branch')

def update():
    echo_title('checking for updates')
    run_command('git fetch')
    echo_log('+', 'blue', 'git status')
    gitstatus = str(subprocess.check_output(['git', 'status']))
    
    if "behind" in gitstatus:
        if echo_question('the local branch is behind, pull?'):
            run_command('git pull')

    elif "ahead" or "up to date" in gitstatus:
        if subprocess.run('git diff-index --quiet HEAD --', shell=True):
            if echo_question('the local branch is ahead, push?'):
                run_command('git add .')
                echo_log('?', 'yellow', 'enter a commit message | ', False)
                while True:
                    message = input().lower()
                    run_command('git commit -m "' + message + '" --quiet')
                    break
                echo_log('+', 'blue', 'git push --quiet')
                subprocess.run('git push --quiet', shell=True)
        else:
            echo_log('i', 'yellow', 'there is nothing to do') 
    
    echo_title('finishing up') 
    sys.exit(1)

# =======================================
# initialization
# =======================================

parser = argparse.ArgumentParser()
parser.add_argument('-i', '--install', action='store_true', help='perform installation')
parser.add_argument('-d', '--dry', action='store_true', help='dry run [default]')
parser.add_argument('-u', '--update', action='store_true', help='sync to configured git repo')
parser.add_argument('-p', '--packages', action='store_true', help='install packages')
parser.add_argument('-v', '--vim', action='store_true', help='set up nvim via plug')
args = parser.parse_args()

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print('')
        sys.exit(1)
