import platform
import os
import distro
import subprocess

#def read_xresources(prefix):
#    props = {}
#    x = subprocess.check_output(['xrdb', '-query'])
#    lines = x.decode().split('\n')
#    for line in filter(lambda l : l.startswith(prefix), lines):
#        prop, _, value = line.partition(':\t')
#        prop = prop[1:]
#        props[prop] = value
#    return props
#
#xresources = read_xresources('*')

colors = {
        "red": "31",
        "yellow": "33",
        "green": "32",
        "cyan": "36",
        "blue": "34",
        "magenta": "35"
}

colors2 = {
        "red": "91",
        "yellow": "93",
        "green": "92",
        "cyan": "96",
        "blue": "94",
        "magenta": "95"
}

escape = "\x1b[0m"

def get_color(colordict, color):
    return "\x1b[" + colordict[color] + "m"

def color_test(colordict, should_key = False):
    for key, value in colordict.items():
        if should_key:
            print(get_color(colordict, key) + value + escape + " ", end='')
        else:
            print(get_color(colordict, key) + "██ " + escape, end='')

def stand_by():
    print('\x1b[97m' + '██' + get_color(colors2, 'yellow') + '██' + get_color(colors2, 'cyan') + '██' + get_color(colors2, 'green') + '██' + get_color(colors2, 'magenta') + '██' + get_color(colors, 'red') + '██' + get_color(colors2, 'blue') + '██' + escape)
    print('\x1b[97m' + '██' + get_color(colors2, 'yellow') + '██' + get_color(colors2, 'cyan') + '██' + get_color(colors2, 'green') + '██' + get_color(colors2, 'magenta') + '██' + get_color(colors, 'red') + '██' + get_color(colors2, 'blue') + '██' + escape)
    print('\x1b[97m' + '██' + get_color(colors2, 'yellow') + '██' + get_color(colors2, 'cyan') + '██' + get_color(colors2, 'green') + '██' + get_color(colors2, 'magenta') + '██' + get_color(colors, 'red') + '██' + get_color(colors2, 'blue') + '██' + escape)

    print(get_color(colors2, 'blue') + '██' + '\x1b[30m' + '██' + get_color(colors2, 'magenta') + '██' + '\x1b[30m' + '██' + get_color(colors2, 'cyan') + '██' + '\x1b[30m' + '██' + '\x1b[97m' + '██' + escape) 
    print('\x1b[30m' + '██████████████' + escape)

def main():
    #subprocess.run('clear')

    operatingsystem = platform.system()
    desktopenvironment = os.getenv("DESKTOP_SESSON")
    hostname = platform.node()
    term = os.getenv("TERM")
    user = os.getenv("USER")
    shell = os.getenv("SHELL")[5:]
    distribution, version, named_version = distro.linux_distribution()
    packages = subprocess.run("yay -Q | wc -l", stdout=subprocess.PIPE, shell=True).stdout.decode('utf-7')[:-1] + " packages"

    print()
    color_test(colors, False)
    print(distribution)
    color_test(colors, True)
    #print(version)
    print(packages)
    color_test(colors2, False)
    print(shell)
    color_test(colors2, True)
    print(term)
    print()

if __name__ == "__main__":
    main()
