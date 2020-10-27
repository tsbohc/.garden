# How to test whether a variable is *declared*?

1 | 1603606101.0

&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;I have a (convoluted) reason[1] to be able to test whether a particular variable has been declared (declared via `declare someVariableNameOrOther`). I really do mean *declared*. That is: I am uninterested in whether the variable has been set to any value (any particular value or any value at all); nor do I care whether or not the variable is empty. Also (and again for a convoluted reason) the script in which I run the check must have `set -o nounset` at its top.

&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;Searching the web and searching this forum did not yield an answer.

Bash 5.0.17. GNU-Linux.

EDIT: **SOLVED**, in a fashion - as follows. In the script that declares that variable, I should not only declare but assign it some value. Then, in the other script, I can throw an error if that variable has any other value (or, indeed, just in case the variable is not empty). That way, I can determine, in the other script, whether I'm dealing with the right variable.

[1] Here is that reason. I have a Bash script that runs a further Bash script. Call the former *Original Script* and call the latter *Further Script*. (Actually, Original Script is taken as a `source` by multiple scripts, and it is one of those latter that runs Further Script.) Now, Further Script assigns a variable that Original Script declared. Recently I changed many of the variable names within Original Script. That caused Further Script to set the wrong variable - and there was no easy way to detect this. I want such an easy way. Hence my request. (There may be an easy way to do all this; the project at issue is convoluted. Indeed it was in the service of making the project's operations clearer that I changed the aforementioned variable names in the first place!)