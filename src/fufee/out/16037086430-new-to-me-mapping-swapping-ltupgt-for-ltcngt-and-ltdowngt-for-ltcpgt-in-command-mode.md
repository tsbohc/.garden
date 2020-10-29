# New (to me) mapping: Swapping &lt;Up&gt; for &lt;C-N&gt; and &lt;Down&gt; for &lt;C-P&gt; in command mode

20 | 1603708643.0

I'm not sure what finally made me notice it, but I realized the other day
there's still one scenario where I instinctively reach for my arrow keys in
vim: when I'm stepping through my command mode history.

`&lt;Up&gt;` and `&lt;Down&gt;` let you step between command-line history entries that
match the prefix you've typed so far. For example, suppose this is my
command-line mode history (oldest to newest):

    :e a-file
    :sav b-file
    :w
    :w
    :echo $PWD
    :s/foo/bar/
    :w

Typing `:e&lt;Up&gt;` would fill the command prompt with `:echo $PWD`. `&lt;Up&gt;` again
would change it to `:e a-file`.

&gt; The `&lt;Up&gt;` and `&lt;Down&gt;` keys take the current command-line as a search string.
&gt; The beginning of the next/previous command-lines are compared with this
&gt; string.  The first line that matches is the new command-line.  When typing
&gt; these two keys repeatedly, the same string is used again.  For example, this
&gt; can be used to find the previous substitute command: Type ":s" and then `&lt;Up&gt;`.
&gt; The same could be done by typing `&lt;S-Up&gt;` a number of times until the desired
&gt; command-line is shown.  (Note: the shifted arrow keys do not work on all
&gt; terminals)

This is something I do *all* *the* *time*.  And I've been breaking homerow to
do it, every time.

I chose to remap `&lt;C-N&gt;`/`&lt;C-P&gt;` to do what `&lt;Up&gt;`/`&lt;Down&gt;` did because it's
not functionality I've ever used.

&gt;                   *c_CTRL-N*
&gt;     CTRL-N    After using 'wildchar' which got multiple matches, go to next
&gt;               match.  Otherwise recall more recent command-line from history.
&gt;                   *c_CTRL-P*
&gt;     CTRL-P    After using 'wildchar' which got multiple matches, go to
&gt;               previous match.  Otherwise recall older command-line from
&gt;               history.

Their usual functionality is to step forward/backward in the history (without
matching the prefix) or step through available completions.  The former isn't
something I need (I can't think of a time where I've partially typed one
command line command, then decided I wanted to jump to one in the history that
*didn't* match it), and for the latter I've always just used `&lt;Tab&gt;`/`&lt;S-Tab&gt;`,
since that's what kicks off commandline mode completion anyway.

    :cnoremap &lt;C-N&gt; &lt;Up&gt;
    :cnoremap &lt;C-P&gt; &lt;Down&gt;

Long-term, I should probably remap `&lt;Up&gt;`/`&lt;Down&gt;` to `&lt;C-N&gt;`/`&lt;C-P&gt;`'s
functionality, but for right now, I'm just noop-ing them so I break the habit
of reaching for them.

    :cnoremap &lt;Up&gt; &lt;Nop&gt;
    :cnoremap &lt;Down&gt; &lt;Nop&gt;