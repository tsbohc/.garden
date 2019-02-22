#!/usr/bin/env python3
from __future__ import print_function

import json
import os
import shutil
import datetime
import sys
import argparse

try: input = raw_input
except NameError: pass

os.system('clear')

dry = False

colors = {
    'red': '\x1b[31m',
    'green': '\x1b[32m',
    'blue': '\x1b[34m',
    'yellow': '\x1b[33m',
    'gray': '\x1b[90m',
    'escape': '\x1b[0m'
}

#rewrite echos to simply return strings and redo output into print({arg} woo) etc
#add a command that pushes an alias into bashrc
#retroarch configs
#redo folder creation to allow reap to do that
#handle keyboard interrupt
#switch dict menu
#add firefox theme

def echo_title(string):
    print('--- ' + string + '\x1b[34m...\x1b[0m')

def echo_icon(string, color=None):
    if color:
        print('[' + colors[color] + string + colors['escape'] + '] ', end='')
    else:
        print('[' + string + '] ', end='')

def echo(string, end=True, color=None):
    if color:
        print(colors[color] + string + colors['escape'], end='')
    else:
        print(string, end='')
    if end:
        print('')

def ask_user(prompt):
    valid = { "yes":True, 'y':True, "no":False, 'n':False }
    while True:
        print("{0} | ".format(prompt), end="")
        choice = input().lower()
        if choice in valid:
            return valid[choice]
        else:
            echo_icon('i', 'yellow')
            echo("please enter a valid choice | ", False)

def create_directory(path):
    exp = os.path.expanduser(path)
    if (not os.path.isdir(exp)):
        if not dry:
            echo_icon('+', 'green')
            echo(path)
            os.makedirs(exp)
        else:
            echo_icon('>', 'yellow')
            echo('os.makedirts(' + path + ')')
    else:
        echo_icon('#', 'red')
        echo(path)


def check_symlink(path):
    target_path = os.readlink(path)
    if not os.path.isabs(target_path):
        target_path = os.path.join(os.path.dirname(path), target_path)
    if not os.path.exists(target_path):
        return True

def create_symlink(src, dst):
    dst = os.path.expanduser(dst)
    src = os.path.abspath(src)
    backup_dir = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'backup')

    if os.path.isdir(os.path.dirname(dst)):
        if os.path.islink(dst) and os.readlink(dst) == src:
            if check_symlink(dst):
                echo_icon('×', 'yellow')
                echo('~/' + os.path.relpath(dst, os.path.expanduser('~')) + '\x1b[34m:\x1b[0m broken symlink, removing' + colors['blue'] + '...' + colors['escape'])
                os.remove(dst)
            else:
                if not dry:
                    os.remove(dst)
                else:
                    echo_icon('>', 'yellow')
                    echo('os.remove(~/' + os.path.relpath(dst, os.path.expanduser('~')) + ')')
        elif os.path.isfile(dst) and not os.path.islink(dst):
            echo_icon('#', 'red')
            echo('~/' + os.path.relpath(dst, os.path.expanduser('~')))

            if not dry:
                if ask_user("[" + colors['yellow'] + '?' + colors['escape'] + "] non-symlink found, back it up? [y/n]"):
                    if not os.path.isdir(backup_dir): os.mkdir(backup_dir)
                    echo_icon('+', 'green')
                    echo(os.path.relpath(os.path.join(backup_dir, datetime.datetime.now().strftime('%Y-%m-%d_%H-%M-%S') + '_' + os.path.basename(dst))))
                    os.rename(dst, os.path.join(backup_dir, datetime.datetime.now().strftime('%Y-%m-%d_%H-%M-%S') + '_' + os.path.basename(dst)))
                else:
                    os.remove(dst)
            else:
                echo_icon('>', 'yellow')
                echo('would ask what to do with the file')
    else:
        if not dry:
            echo_icon('+', 'green')
            echo(os.path.dirname(dst))
            os.makedirs(os.path.dirname(dst))
        else:
            echo_icon('>', 'yellow')
            echo('os.makedirs(' + os.path.dirname(dst) + ')')

    if os.path.exists(src):
        if not dry:
            echo_icon('↣', 'blue')
            echo(os.path.relpath(src) + '\x1b[34m:\x1b[0m ~/' + os.path.relpath(dst, os.path.expanduser('~')))
            os.symlink(src, dst)
        else:
            echo_icon('>', 'yellow')
            echo('os.symlink(' + os.path.relpath(src) + ', ~/' + os.path.relpath(dst, os.path.expanduser('~')) + ')')
    else:
        echo_icon('!', 'red')
        echo(os.path.relpath(src) + '\x1b[34m:\x1b[0m does not exist, skipping' + colors['blue'] + '...' + colors['escape'])


def copy_path(src, dst):
    dst = os.path.expanduser(dst)
    src = os.path.abspath(src)
    if os.path.exists(dst):
        if ask_user("{0} exists, delete it? [y/n]".format(dst)):
            if os.path.isfile(dst) or os.path.islink(dst):
                os.remove(dst)
            else:
                shutil.rmtree(dst)
        else:
            return
    print("Copying {0} -> {1}".format(src, dst))
    if os.path.isfile(src):
        shutil.copy(src, dst)
    else:
        shutil.copytree(src, dst)


def run_command(command):
    if not dry:
        echo_icon('>', 'green')
        echo(command)
        os.system(command)
    else:
        echo_icon('>', 'yellow')
        echo(command)

#parser = argparse.ArgumentParser()
#parser.add_argument("config", help="the JSON file you want to use")
#parser.add_argument("-r", "--replace", action="store_true",
#                    help="replace files/folders if they already exist")
#args = parser.parse_args()
#js = json.load(open(args.config))
#os.chdir(os.path.expanduser(os.path.abspath(os.path.dirname(args.config))))

try:
    js = json.load(open(os.path.join(os.path.dirname(os.path.realpath(__file__)), 'config.json')))
except FileNotFoundError:
    echo_icon('!', 'red')
    echo('blueberry could not find config.json, exiting\x1b[34m...\x1b[0m')
    sys.exit(1)

def install():
    if 'mkdir' in js:
        echo_title('making directories')
        [create_directory(path) for path in js['mkdir']]
    if 'link' in js:
        echo_title('linking dots')
        #[create_symlink(src, dst, args.replace) for src, dst in js['link'].items()]
        [create_symlink(src, dst) for src, dst in js['link'].items()]
    if 'copy' in js:
        echo_title('copying stuff')
        [copy_path(src, dst) for src in js['copy'].items()]
    if 'install' in js and 'install_cmd' in js:
        echo_title('installing packages')
        packages = ' '.join(js['install'])
        run_command("{0} {1}".format(js['install_cmd'], packages))
    if 'run' in js:
        echo_title('running commands')
        [run_command(command) for command in js['run']]

def reap():
    if 'link' in js:
        echo_title('reaping configs')
        for src, dst in js['link'].items():
            exp_dst = os.path.expanduser(dst)
            exp_src = os.path.abspath(src)
            if not os.path.islink(exp_dst):
                if not os.path.exists(exp_src):
                    echo_icon('+', 'green')
                    echo(dst, False)
                    echo(': ', False, 'blue')
                    echo(src)
                    os.rename(exp_dst, exp_src)
                else:
                    echo_icon('#', 'red')
                    echo(dst, False)
                    echo(': ', False, 'blue')
                    echo('file already exists in repo')

def git_push():
    run_command('git add .')
    run_command('git status -s')
    echo_icon('?', 'yellow')
    echo("enter a commit message | ", False)
    while True:
        message = input().lower()
        run_command('git commit -m "' + message + '" --quiet')
        break
    run_command('git push --quiet')

def main():
    echo("       _                              ", True, "blue")
    echo("  /   //         /                    ", True, "blue")
    echo(" /__ //  . . _  /__ _  __  __  __  ,  ", True, "blue")
    echo("/_) </_ (_/_</_/_) </_/ (_/ (_/ (_/_ ❤", True, "blue")
    echo("                                 /    ", True, "blue")
    echo("what would you like to do?", False)
    echo("      '   ", True, "blue")

    echo('i', False, 'blue')
    echo('nstall, ', False)
    echo('r', False, 'blue')
    echo('eap, ', False)
    echo('d', False, 'blue')
    echo('ry, ', False)
    if os.system('git diff-index --quiet HEAD --'):
        echo('!', False, 'blue')
    echo('p', False, 'blue')
    echo('ush\x1b[34m...\x1b[0m ', False)

    global dry

    while True:
        choice = input().lower()
        if choice == 'i':
            dry = False
            install()
            echo_title('finishing up')
            break
        elif choice == 'r':
            reap()
            break
        elif choice == 'd':
            dry = True
            install()
            echo_title('completing dry run')
            break
        elif choice == 'p':
            git_push()
            main()
            break
        else:
            echo_icon('i', 'yellow')
            echo("please enter a valid choice | ", False)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print('')
        sys.exit(1)
