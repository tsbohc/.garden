# Not Consecutively scrolling down when pressing j malfunctioning

3 | 1603748023.0

Hi,

I've came across this strange malfunctioning in my vim, and is only when I use a second monitor connected by `x11vnc` seems that vim is only inputting the first keystroke of j when scrolling down, when I want it to behave like continuing scrolling down without having to press again the button by just holding it down (it happens also for the rest of this kind of navigation)

Weird bug, if you ask me. Have someone came acrross the same?

Thanks

Solved. `x11vnc` takes over the host server keyboard and shares it with the other host (client), it does it in a way that by default keyrepetition is not enabled when you hold pressed a key.
Doing it with the following arguments will make it behave as "normal" `x11vnc -repeat &lt;more arguments&gt;`

Thanks everyone for your help