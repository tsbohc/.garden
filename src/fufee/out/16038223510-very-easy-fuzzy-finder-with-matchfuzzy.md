# Very easy fuzzy finder with matchfuzzy

12 | 1603822351.0

Taking advantage of `:h matchfuzzy()` and `:h command-completion-customlist`, you can create any sort of fuzzy finder in vim and use vim style tab completion.

    function! FilesPicker(A,L,P) abort
    	let l:cmd = 'fd . -t f'
    	let l:items = l:cmd-&gt;systemlist
    	if a:A-&gt;len() &gt; 0
    		return l:items-&gt;matchfuzzy(a:A)
    	else
    		return l:items
    	endif
    endfunction
    
    function! FilesRunner(args) abort
    	exe 'e ' .. a:args
    endfunction
    
    command! -nargs=1 -bar -complete=customlist,FilesPicker Files call FilesRunner(&lt;q-args&gt;)

The above snippet is an example of fuzzy finding files using `fd` but you can substitute it with any sort of list really. To use the newly created Files ex command, `:Files &lt;search-term&gt;&lt;Tab&gt;`.

Note:  
This requires `:h matchfuzzy()`, please check if you have it available in your vim.