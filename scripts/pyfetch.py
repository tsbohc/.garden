"""
Fetch
Minimal and customizable information tool
By Kat Hamer
"""

import platform  # Get platform information
import os        # Get environment variables
import distro    # Get Linux distribution

"""Color escape codes"""
colors = {"red":"\033[1;31m",  
          "green":"\033[0;32m",
          "yellow":"\033[0;33m",
          "blue":"\033[1;34m",
          "magenta":"\033[1;35m",
          "cyan":"\033[1;36m",
          "reset":"\033[0;0m",
          "bold":"\033[;1m"}

def color_entry(title, value, accent):
    default_escape = colors.get("reset")
    accent_escape = colors.get(accent, default_escape)

    return f"{accent_escape}{title} {default_escape}{value}"

def color_test(block_char="██"):
    color_line = " ".join([f"{color}{block_char}"+colors['reset'] for name, color in colors.items()])
    return color_line

def main():
    operatingsystem = f"{platform.system()} {platform.release()}"
    hostname = platform.node()
    user = os.getenv("USER")
    term = os.getenv("TERM")
    shell = os.getenv("SHELL")
    color = "blue"
    distribution, version, named_version = distro.linux_distribution()

    entries = [color_entry("", hostname, color),
               color_entry("", operatingsystem, color),
               color_entry("", distribution, color),
               color_entry("", term, color),
               color_entry("", shell, color),
               color_test()]

    for entry in entries:
        print(entry)
               
if __name__ == "__main__":
    main()

