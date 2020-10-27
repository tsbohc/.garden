# Signature help via ALE

6 | 1603648930.0

I'm currently using ALE as my autocompletion &amp; linting tool via language servers (mainly for c, python and bash). I am very happy with the features it provides except for one thing: signature help. Everytime after I select an autocomplete candidate, I have to find other ways to know the exact order and type of the arguments. From my knowledge there is no :ALEShowSignature command to help me while I fill out function arguments in a C function, for example. Is there any other way I can achieve this without abandoning ALE? Worst of all is that the popup while autocompleting does not even show arguments for C programs (is does only for python). Using libraries like BLAS quickly becomes a pain in the ass. Moreover, the :ALEHover feature seem helpful only when the linter is not complaining about missing arguments (btw, how do I show a pop-up instead of a preview window with the hover feature in vim8?)

&amp;#x200B;

I know vim-lsc has this feature and displays the signature on command in a preview window, but im a little reluctant to just install it on top of ALE just for that one feature because ALE can do every other thing I need that vim-lsc has to offer.

&amp;#x200B;

Any kind of help would be appreciated.