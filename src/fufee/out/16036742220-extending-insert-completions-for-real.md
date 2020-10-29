# Extending insert completions for real

15 | 1603674222.0

Vim's built-in [`:h ins-completion`](https://vimhelp.org/insert.txt.html#ins-completion) is very handy. One thing I wanted to do for a long time was to complete [`:h WORD`](https://vimhelp.org/motion.txt.html#WORD)s so I could complete things like `&lt;C-` and other fancy expressions.

There is already a vim-script that does that : [vim-WORDcomplete](https://www.vim.org/scripts/script.php?script_id=5613) which maps it to `&lt;C-X&gt;&lt;C-W&gt;`. Great.

But, **remapping** `&lt;C-X&gt;{c}` **breaks the little helper message** `-- ^X mode (^]^D^E^F^I^K^L^N^O^Ps^U^V^Y)`.

I cannot accept that because I love it, reminds me all possible completions. And I don't want to remap custom insert-completions to something else than `&lt;C-X&gt;...`, I just want to *extend* it.

I finally put some effort into it and got something working to mimic the default behaviour, allowing us to customise `&lt;C-X&gt;` as we want. It's actually very simple.

    function! CtrlX()
        echohl ModeMsg
        echo "-- ^X mode (^]a^D^E^F^I^K^Ll^N^O^Ps^T^U^V^W^Y)"
        echohl None
        let l:c = nr2char(getchar())
    
        if get(g:, "loaded_AlphaComplete") &amp;&amp; l:c == "a"
            return AlphaComplete#Expr()
        elseif get(g:, "loaded_LineComplete") &amp;&amp; l:c == "l"
            return LineComplete#Expr()
        elseif get(g:, "loaded_WORDComplete") &amp;&amp; l:c == "\&lt;C-W&gt;"
            return WORDComplete#Expr()
        else
            return "\&lt;C-X&gt;" . l:c
        endif
    endfunction
    inoremap &lt;expr&gt; &lt;silent&gt; &lt;C-X&gt; CtrlX()

Here, I have extended ins-completion to `&lt;C-X&gt;&lt;C-W&gt;`, `&lt;C-X&gt;l` and `&lt;C-X&gt;a`. [Ingo Karkat](https://github.com/inkarkat) have written alot more ! See [CompleteHelper](https://www.vim.org/scripts/script.php?script_id=3914). It's just like they were built-in, and you can customize the helper message \\o/

By the way, we add `^T` that wasn't present in the default message even though it's documented under `:h i_CTRL-X_CTRL-T` (complete in `'thesaurus'`). Finally, we have to deactivate the defaults `&lt;C-X&gt;{c}` mappings from Ingo's plugins. E.g. by adding thoses lines into `after/plugin/ingo-complete.vim`.

    if exists('g:loaded_AlphaComplete')
        iunmap &lt;C-X&gt;a
    endif
    if exists('g:loaded_LineComplete')
        iunmap &lt;C-X&gt;l
    endif
    if exists('g:loaded_WORDComplete')
        iunmap &lt;C-X&gt;&lt;C-W&gt;
    endif

Any thoughts on this ?

&amp;#x200B;

^(Update : it's simpler than I thought. remove) `l:default_c` ^(search)