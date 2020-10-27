# How to minimise YCM installation size

42 | 1603571923.0

Every now and again people (reasonably) lament the overall on-disk size of a YCM install. We know about this and are actively improving the situation while maintaining the kind of functionality and stability that we can.

Anyway, for anyone who is interested, I wrote a few notes on how to have a "minimal" install: https://github.com/ycm-core/YouCompleteMe/wiki/Minimising-Installation-Size.

TL;DR:

* Use a recursive shallow clone
* Only enable the completers you really need, or use g:ycm_*_binary_path options to point to existing installations
* Upgrade by deleting the installation and doing a new shallow clone

Leads to about 100MB install, which we expect to shrink further. Yes we know that 100MB is "too much for a Vim plugin" etc. but there's only so much we can do.

In b4:

- we have no plans to produce prebuilt binaries (because of python ABI incompatibilities)
- no, I don't know the relative sizes of other engines
- the biggest contributors to the size are the git history and the third-party completion engines
- yes, we are actively [working on removing](https://github.com/ycm-core/YouCompleteMe/pull/3792) third-party dependencies

Let the downvoting... begin!