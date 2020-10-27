# Newb with Byobu can't get out of the help screen.

2 | 1603634865.0

Firstly, let me say up front that I'm running Ubuntu WSL in Windows 10. I'm setting it up to run a few command line tools. I wanted to experiment with tmux/byobu as I never got familiar with them before. Byobu seems nice, but I'm having a silly problem that probably has a simple solutiopn. Shift-F1 displays a long help file with all the commands. I can create a new session or split or window afterwards to get back to a terminal, but I can't 'close' the help file. Shift-F1 again doesn't work, ESC doesn't work. F12 doesn't work etc. What am I missing?


::edit::

**OH WAIT. It's vi. jeeez :q**

::edit again::

Is there a way to change which editor it uses? it doesn't seem to obey export EDITOR. Is there a set command I should use in .tmux.conf if I want to use nano, or something else (Ideally I'd like to try [suplemon](https://github.com/richrd/suplemon) as my default editor.