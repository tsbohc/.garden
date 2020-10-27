# Script transclusion in Windows cmd/Batch .bat files

1 | 1603346180.0

I want something like C's `#include &lt;fileName&gt;` for Windows cmd Batch `.bat` files. Please consider that the `call &lt;fileName&gt;.bat` is not suitable as it executes the other script instead of running it line by line like it is embedded in the original script. The main difference is for example when you pipe something to the script or command-line arguments/parameters are passed to the `.bat` file.

This feature is particularly useful when you want to define a callable unit similar to Pascal procedures. [Here](https://www.dostips.com/forum/viewtopic.php?t=1626) a user called **jeb** has created a "Batch include library" that seems to the job. But for the love of FSM, I can't understand what it does. So if anyone could explain it in layman terms I would appreciate it.