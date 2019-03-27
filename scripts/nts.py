#!/usr/bin/env python3
import os
import sys
import argparse
import subprocess
import datetime
import time

def new():
    echo_log('?', 'yellow', 'title: ', False)
    title = input()
    if os.path.isfile(title):
        echo_log('!', 'red', 'file already exists')
        new()
    echo_log('#', 'yellow', 'tag: ', False)
    tag = input()
    if tag == '':
        tag = 'notag'
    print
    if not os.path.isfile(title):
        creation_date = datetime.datetime.now().strftime("%B'%y")
        with open('._notes', 'a') as db:
            db.write(title+'|'+tag+'|'+creation_date+'\n')
        open(title, 'a').close()
        subprocess.run('$EDITOR "'+title+'"', shell=True)

def metadata():
    with open('._notes', 'r') as db:
        db.seek(0)
        selection = fzf()
        i = 0
        for line in db:
            i = i + 1
            if selection in line and selection != '':
                subprocess.run('nvim +'+str(i)+' ._notes', shell=True)
                break
    with open('._notes', 'r') as db:
        db.seek(0)
        y = 0
        for line in db:
            y = y + 1
            if y  == i:
                break
        line = line.split('|')
        print(selection)
        print(line)
        if selection != line[0]:
            os.rename(os.path.abspath(selection), os.path.abspath(line[0]))

def fzf():
    term_cols = int(subprocess.check_output(['tput', 'cols']))
    with open('._notes', 'r') as db:
        db.seek(0)
        notes = ''
        for line in db:
            line = line.split('|')
            notes += line[0]+((term_cols-10-len(line[0])-len(line[1])-len(line[2]))*' ')+'   #'+line[1]+' - '+line[2]
        notes = notes.rstrip()
    selection = subprocess.check_output('echo "'+notes+'" | fzf --no-bold --reverse | sed "s/   .*$//g"', shell=True)
    selection = selection.rstrip()
    selection = selection.decode(sys.stdout.encoding)
    return selection

def edit():
    with open('._notes', 'r+') as db:
        filenames = os.listdir(os.path.expanduser('~/Dropbox/notes'))
        #filenames.remove('._notes')
        sorted(filenames)
        subprocess.run(['sort', '._notes', '-o', '._notes'])

        if len(filenames) != len(db.readlines()):
            echo_log('i', 'yellow', 'changes found, indexing...')
            for filename in filenames:
                print('- '+filename+':')
                found = False
                db.seek(0)
                for line in db:
                    line = line.rstrip()
                    print(line)
                    if filename in line:
                        found = True
                        break
                if found == False:
                    m_time = str(datetime.datetime.fromtimestamp(os.path.getmtime(filename)).strftime("%B'%y"))
                    db.write(filename+'|'+'notag'+'|'+m_time+'\n')
    selection = fzf()
    if selection != '':
        subprocess.run('echo "'+selection+'" | xargs -r -d"\n" $EDITOR', shell=True)
        

def main():
    subprocess.run('clear')

    # check if dropbox is available
    if not os.path.isdir(os.path.expanduser('~/Dropbox')):
        echo_log('!', 'red', '~/Dropbox not found')
        sys.exit(1)
    if not os.path.isdir(os.path.expanduser('~/Dropbox/notes')):
        os.makedirs(os.path.expanduser('~/Dropbox/notes'))
    if not os.path.isfile(os.path.expanduser('~/Dropbox/notes/._notes')):
        open(os.path.expanduser('~/Dropbox/notes/._notes'), 'a').close()
    
    # cd into the notes dir
    os.chdir(os.path.expanduser('~/Dropbox/notes/'))

    # parse args
    if args.action in { 'new', 'n' }:
        new()
    elif args.action in { 'meta', 'm' }:
        metadata()
    elif (args.action in { 'edit', 'e' } or args.action == None) and len(sys.argv) == 1:
        if os.path.exists('/usr/bin/fzf'):
            edit()
        else:
            echo_log('!', 'red', 'fzf is not installed')
        sys.exit(1)
    else:
        parser.print_help(sys.stderr)
        sys.exit(1)

# print
colors = {
    'red': '\x1b[31m',
    'green': '\x1b[32m',
    'yellow': '\x1b[33m',
    'blue': '\x1b[34m',
    'gray': '\x1b[90m',
    'escape': '\x1b[0m'
}

def echo_log(icon, color, string, end=True):
    if end == True:
        print('[' + colors[color] + icon + colors['escape'] + '] ' + string) 
    else:
        print('[' + colors[color] + icon + colors['escape'] + '] ' + string, end='') 
parser = argparse.ArgumentParser(
        formatter_class=argparse.RawTextHelpFormatter,
        description='''

perform:
   n, new         create new note
   m, meta        change metadata in the database
   e, edit        index the folder if needed and pip into fzf
                  default

install:
  -f, --force     force re-index of the database
''')

parser.add_argument('action', nargs='?', help=argparse.SUPPRESS)

args = parser.parse_args()
if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print('')
        sys.exit(1)
