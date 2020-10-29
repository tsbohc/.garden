# I have python3 and already did "pip3 install pynvim", yet "echo has('python3')" returns 0. What could I be doing wrong?

3 | 1603710351.0

I wanted to install deoplete, yet python3 support in vim is a requirement for that. I already installed pynvim via pip3, but vim keeps returning 0 when using the :echo has('python3') command.

What am I missing? my python3 version is 3.7.3.

Edit: just checked and apparently the vim version compiled for debian has 
"-python" ... so I guess no python support?