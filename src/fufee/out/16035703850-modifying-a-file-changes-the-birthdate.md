# Modifying a file changes the birthdate

1 | 1603570385.0

Hi,

When I modify a file with vim and write quit it, it changes all three dates to the modifying date, seen with `stat`.  I'd like to keep the birth date, however, to when the file was created, not modified. Other editors don't do this (I tried nano, it leaves the birth date how it is).

Is this something I have to configure in .vimrc?

Thanks, Jan van Rossum