# [Hypothetical] What's the most damage you could do with a 1-character typo?

6 | 1603529577.0

A little background. I've been reading through [guide.bash.academy](https://guide.bash.academy) and got to the section on [quoting literals](https://guide.bash.academy/commands/?=Command_arguments_and_quoting_literals#a3.3.0_4). It illustrates a scenario where an unintended space causes the deletion of the entirety of `/home` instead of just `/home/$username`

&amp;#x200B;

This got me thinking, what's the worst possible 1-character typo you could make in the command line?  We all know the `sudo rm -rf /` meme but what about a **single** mistaken keystroke that turns an otherwise harmless command into a truly horrible one? For added punch let's assume the user is using root privileges or some equivalent. I'm using bash on Linux but other shells and OSes are welcome.

&amp;#x200B;

^(I'm a fan of using silly hypothetical questions like this to learn. Hope this is allowed.)