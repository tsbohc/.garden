# Vimscript variables in bash command

16 | 1603540896.0

I'm trying to create a function which lets me run the currently open python file. I want the option to pass in arguments. When I run the following function


    function! RunPython(args)

      :terminal bash -c "cd %:h &amp;&amp; python %:t a:args"

    endfunction  



The arguments that my python program receives (via sys.argv) are \['test.py', 'a:args'\] .

Similarly, something like


    :terminal bash -c "cd %:h &amp;&amp; python %:t $0" a:args


Yields the same result. Does anyone know how I can have the value of a:args be part of the comand rather than the literal string "a:args"? (%:h and %:t values work perfectly)

Edit:

Found a solution by doing the following

    :execute ':terminal ++rows=10 ++shell cd %:h &amp;&amp; python %:t ' a:args