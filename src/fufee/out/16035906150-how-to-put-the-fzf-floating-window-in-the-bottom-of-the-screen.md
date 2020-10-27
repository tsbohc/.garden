# How to put the FZF floating window in the bottom of the screen?

1 | 1603590615.0

I am using fzf.vim to go to various files. I was pressing `Ctrl+P` to open a floating window in the bottom of the screen. For some time now the window has moved to the center of the screen. How do I fix that? 

https://imgur.com/xgqtvIR.png

I am using this to activate FZF

    nnoremap &lt;C-p&gt; :&lt;C-u&gt;FZF&lt;CR&gt;
    command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --glob "!tags" --glob "!_build/" --color "always" '.shellescape(&lt;q-args&gt;).'| tr -d "\017"', 1, &lt;bang&gt;0)