# Nightly hack for vimmers

39 | 1603526011.0

Some of us use `cabbrev` to make use of levereged built-in commands seemlessly. For example I have a `:BD` command that does a little more than just `:bd`, and `cabbrev bd BD`. So typing `:bd&lt;Space&gt;` expands to `BD`.

But. And it has bothered me alot. If I type `:bd&lt;CR&gt;`, vim executes `:bd` and not my `:BD` command! Yet, if you read the following paragraph from `:h abbreviations` **until the end**. You can do something to fix that.

&gt;An abbreviation is only recognized when you type a non-keyword character. This can also be the &lt;Esc&gt; that ends insert mode or the &lt;CR&gt; that ends a command.  The non-keyword character which ends the abbreviation is inserted after the expanded abbreviation.  **An exception to this is the character &lt;C-\]&gt;, which is used to expand an abbreviation without inserting any extra characters.**

    function! CCR()
        let cmdline = getcmdline()
        if cmdline =~ '^\k\+$'
            return "\&lt;C-]&gt;\&lt;CR&gt;"
        else
            return "\&lt;CR&gt;"
        endif
    endfunction
    cnoremap &lt;expr&gt; &lt;CR&gt; CCR()

Since [romainl](https://gist.github.com/romainl) already have done a [nice `CCR()` function](https://gist.github.com/romainl/047aca21e338df7ccf771f96858edb86), we just have to add the corresponding `elseif`

Lesson learned : reading `help` really does help.