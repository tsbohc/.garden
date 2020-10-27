# Intermediate user sharing his text editing strategies. Share your favorites too, so we all can learn something!

0 | 1603610265.0

I've been researching the most common use cases for text editing, to map them to an extra layer of my keyboard. While this heavily depends of what you use vim for, I thought sharing would be cool:

**EASY**

Go to an specific point of the current line.

    /word

Go to this word and append.

    /word ENTER a 

Select word under cursor and change it.

    viwc

Select between word1 and word 2, and change the content. TYPICAL USE: Select what's between {}()\[\]... and change it).

    v /term1, Enter -&gt; /term2, Enter,c

Search and substitute.

    /%s/originalText/newText

Search and substitute all ocurrences in this file.

    /%s/originalText/newText/g

**MEDIUM LEVEL / CODER**

Move between functions. To quickly scout how an small piece of code works.

      - Go to next/prev class                   -&gt; ][][[[ / [][[
      - go to next/prev definition              -&gt; ]m / [m
      - Go to next/prev block of code           -&gt; ()
      - Go to next/prev parameter(shift, or ,)  -&gt; f,

Fuzzy search code definitions: Show all definitions under this path. To quickly explore entire code projects. (Requires CtrlP and GuttenTags).

    :CtrlPTag

Search in project

    :CtrlPLine

Open an interactive terminal in vim

    :term

Change variable names in the whole project

    :! cd /project/path &amp;&amp; sed -i 's/oldName/newName/g' *

Create a new buffer with the content of the current file, but include only the lines cotaining 'term'

    :%! grep term

**ADVANCED LEVEL**

Here I describe what I consider some of the most simple/practical regular expressions you can apply to search.

Select what's between parenthesis.

    /(.*)

Select what's between any kind of parenthesis. Note that I'm just adding more conditions using logical or with '/|'

    /(.*)\|&lt;.*&gt;\|\[.*\]\|{.*}

Substitute the next list of words with the clipboard's content. [Cool explanation](https://stackoverflow.com/a/2471282/2010764).

    :%s/Dinosaur\|Excrement/"_cw^R"/g

**GOD LIKE LEVEL**

The idea behind a macro is to record an operation on the fly, and repeat it, let's say, 20 times in row. Understand the most basic macro, and you can build any.

Append the clipboard's content at the beginning of the next 50 lines.

    q → the macro key
    w → key we are gonna assign the macro to
    0 → Go to the start of the line
    p → paste
    q → Stop recording
    
    Now if we want to run it 50 times we press
    50@w

If you wanna save a macro forever, just write it in your .vimrc

    let @w="0p"