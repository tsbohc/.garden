# How to toggle (Vimplug) plugins on and off?

35 | 1603501112.0

# Title Correction

How to toggle (Vimplug) plugins on and off **on the fly**?

# Query

Using COC on multiple instances can really take a toll on my intel i3+4GB machine.  
So I was wondering if I could toggle it on demand.  
I have managed to turn it off by default and toggle it on using Vimplug's built in feature like the following.
```
Plug 'neoclide/coc.nvim', {'branch': 'release', 'on': 'CocToggle' }
```
However, I'm not sure how to toggle it off.  
Any help would be highly appreciated!  

# Solution

I ended up writing the following function for my use case.
```vim
Plug 'neoclide/coc.nvim', {'branch': 'release' }
let g:coc_start_at_startup = 0

let s:coc_enabled = 0
function! ToggleCoc()
   if s:coc_enabled == 0
      let s:coc_enabled = 1
      CocStart
      echo 'COC on'
   else
      let s:coc_enabled = 0
      echo 'COC off'
      call coc#rpc#stop()
   endif
endfunction
nnoremap &lt;silent&gt; &lt;leader&gt;h :call ToggleCoc()&lt;cr&gt;

```