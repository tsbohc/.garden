# Entering select mode from insert mode with the mouse

0 | 1603567243.0

I usually find visual mode more useful than select mode, but when I'm typing something in insert mode and then highlight a word with the mouse, it's almost always because I want to replace it - either by typing or pasting something. So it would make sense for me to go into "(insert) SELECT" mode when dragging the mouse in insert mode. Looking at the [vim docs](http://vimdoc.sourceforge.net/htmldoc/intro.html#vim-modes), it seems like that's exactly what should happen:

    Insert Select mode	Entered when starting Select mode from Insert mode.
        			E.g., by dragging the mouse or &lt;S-Right&gt;.

But when I'm in insert mode and drag the mouse, it takes me into "(insert) VISUAL", and Shift+Right moves the cursor to the right by a word. The only relevant line I can see in my .vimrc is `set mouse=a`. Am I missing something? How can I get the behaviour described in the docs?