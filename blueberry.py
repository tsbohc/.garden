#!/usr/bin/env python3
from __future__ import print_function

import json
import os
import shutil
import subprocess
import datetime
import sys

# =======================================
# definitions 
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

# =======================================
# print functions
# =======================================

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

def run_command(command):
    if not dry:
        echo_log('>', 'green', command)
        subprocess.run(command, shell=True)
    else:
        echo_log('>', 'yellow', command)

def create_directory(path):
    dst = os.path.expanduser(path)
    if not os.path.isdir(dst):
        if not dry:
            echo_log('+', 'green', path)
            os.makedirs(dst)
        else:
            echo_log('+', 'yellow', path)
    else:
        if not dry:
            echo_log('#', 'red', path)

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
    #backup_dir = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'backup')

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
            else:
                echo_log('?', 'yellow', 'ask what to do with the file')
        
        # actually symlink
        if not dry:
            echo_log('"', 'blue', os.path.relpath(src) + colon + '~/' + os.path.relpath(dst, os.path.expanduser('~')))
            if os.path.islink(os.path.expanduser(dst)):
                os.remove(os.path.expanduser(dst))
            os.symlink(src, dst)
        else:
            echo_log('"', 'yellow', os.path.relpath(src) + colon + '~/' + os.path.relpath(dst, os.path.expanduser('~')))
    else:
        echo_log('!', 'red', os.path.relpath(src) + colon + 'does not exist, skipping' + dots)



# =======================================
# main menu
# =======================================

dry = False

def install():
    global dry

    tasks = {
            'install packages?': True,
            'run commands?': True,
            'set up nvim?': True,
            'install pips?': True
    }
    
    if not dry:
        for key, value in tasks.items():
            if echo_question(key):
                tasks[key] = True
            else:
                tasks[key] = False

    if 'mkdir' in js:
        echo_title('making directories')
        [create_directory(path) for path in js['mkdir']]

    if 'install' in js:
        # install yay if needed
        if not os.path.exists('/usr/bin/yay'):
            echo_title('installing yay')
            if not dry:
                run_command('git clone https://aur.archlinux.org/yay.git')
                os.chdir('yay')
                run_command('makepkg -si --noconfirm')
                os.chdir('..')
                echo_log('>', 'green', 'cleaning up' + dots)
                shutil.rmtree('yay')
                run_command('yay -Syu')
            else:
                echo_log('>', 'yellow', 'git clone https://aur.archlinux.org/yay.git')
                echo_log('>', 'yellow', 'cd yay')
                echo_log('>', 'yellow', 'makepkg -si --noconfirm')
                echo_log('>', 'yellow', 'cd ..')
                echo_log('>', 'yellow', 'rm -r yay')
                echo_log('>', 'yellow', 'yay -Syu')
        
        if tasks['install packages?']:
            echo_title('installing packages')
            for pkg in js['install']:
                if not dry:
                    echo_log('+', 'green', pkg)
                    subprocess.run('yay -S --needed --noconfirm ' + pkg + ' --color=always | grep --color=never "error\|warning"', shell=True)
                else:
                    echo_log('+', 'yellow', pkg)

    if 'run' in js and tasks['run commands?']:
        echo_title('running commands')
        [run_command(command) for command in js['run']]
    
    if tasks['install pips?']:
        if 'pip' or 'pip2' in js:
            echo_title('installing pips')
            if 'pip2' in js:
                for pkg in js['pip2']:
                    if not dry:
                        echo_log('+', 'green', pkg + ' pip2')
                        subprocess.run('sudo pip2 install ' + pkg + ' -q', shell=True)
                    else:
                        echo_log('+', 'yellow', pkg + ' pip2')
            if 'pip' in js:
                for pkg in js['pip']:
                    if not dry:
                        echo_log('+', 'green', pkg + ' pip')
                        subprocess.run('sudo pip install ' + pkg + ' -q', shell=True)
                    else:
                        echo_log('+', 'yellow', pkg + ' pip')
    
    if tasks['set up nvim?']:
        # install plug if needed
        if not os.path.exists(os.path.expanduser('~/.config/nvim/autoload/plug.vim')):
            echo_title('installing plug')
            if not dry:
                echo_log('>', 'green', 'curling .vim')
                os.system('curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
            else:
                echo_log('>', 'yellow', 'installing plug.vim')

        # setup/update nvim plugs
        echo_title('updating nvim plugins')
        if not dry:
            echo_log('>', 'green', 'nvim "+:PlugInstall" "+:q" "+:q"')
            os.system('nvim "+:PlugInstall" "+:q" "+:q"')
        else:
            echo_log('>', 'yellow', 'nvim "+:PlugInstall" "+:q" "+:q"')

    # symlink
    if 'link' in js:
        echo_title('linking dots')
        [create_symlink(src, dst) for src, dst in js['link'].items()]

    if not dry:
        echo_title('finishing up') 
    else:
        echo_title('completing dry run')

def dry_run():
    global dry
    dry = True
    install()

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
    echo_log('>', 'green', 'git status')
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
                run_command('git push --quiet')
        else:
            echo_log('i', 'yellow', 'there is nothing to do') 
    
    echo_title('finishing up') 

# =======================================
# initialization
# =======================================

try:
    js = json.load(open(os.path.join(os.path.dirname(os.path.realpath(__file__)), 'config.json')))
except FileNotFoundError:
    echo_log('!', 'red', 'blueberry could not find config.json, exiting' + dots)
    sys.exit(1)

# =======================================
# main function
# =======================================

def main():
    subprocess.run('clear')
    print(colors['blue'] + """
       _                                
  /   //         /                      
 /__ //  . . _  /__ _  __  __  __  ,    
/_) </_ (_/_</_/_) </_/ (_/ (_/ (_/_ ❤  
                                 /      
""" + colors['escape'] + "what would you like to do?      " + colors['blue'] + "'" + colors['escape'])

    print(
    colors['blue'] + 'i' + colors['escape'] + 'nstall, ' +
    colors['blue'] + 'r' + colors['escape'] + 'eap, ' +
    colors['blue'] + 'd' + colors['escape'] + 'ry, ' +
    colors['blue'] + 'u' + colors['escape'] + 'pdate' + 
    dots + ' ', end='')

    menu = {
        'i': install,
        'r': reap,
        'd': dry_run,
        'u': update
    }

    while True:
        choice = input().lower()
        if choice in menu:
            result = menu.get(choice)
            result()
            break
        else:
            echo_log('i', 'yellow', "please enter a valid choice | ", False)

# =======================================
# non-modular run only 
# =======================================

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print('')
        sys.exit(1)
