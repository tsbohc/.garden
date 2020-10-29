# `:inoremap kj` faster timeout?

2 | 1603787321.0

For a long, long time, I've had `:inoremap kj &lt;Esc&gt;` and jk, and it's pretty hardwired for me to mash those keys to escape. Lately though I've had to type the the word "network" a lot more than in the past, and the delay after typing k but before I can escape though kj/jk is long enough that I end up with "networ" everywhere. 

I know with `:help timeout` I can adjust the timeout down, but I worry that in order to make it fast enough, it'd make it too hard to execute other mappings. 

Is there anyway to adjust the timeout for just those mappings, or just insert mode mappings? Or some other solution that will let me keep kj/jk to escape, but also be able to type the word "network" ?