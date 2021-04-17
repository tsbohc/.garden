import curses

def main(stdscr):
    prompt_input = ""

    # do not wait for input when calling getch
    stdscr.nodelay(1)
    while True:
        c = stdscr.getch()

        if c == 263:
            prompt_input = prompt_input[:-1]
            stdscr.move(0, 0)
            stdscr.clrtoeol()
            stdscr.addstr(prompt_input)

            #stdscr.refresh()

        elif c != -1:
            # print numeric value
            stdscr.addstr(chr(c))
            #stdscr.refresh()

            prompt_input += chr(c)
            #stdscr.move(0, 0)

if __name__ == '__main__':
    curses.wrapper(main)
