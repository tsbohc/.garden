# Symbolic Link to two files?

0 | 1603834170.0

I truly doubt this is possible, but I have a use case in which it would be *very* convenient, so I will ask:  


Is it possible to have a file that is a symbolic link of \*two\* files?  (Kind of like a symbolic `cat`?)

If I have 2 files, `part_a` and `part_b`, can I create a file that contains both, with a mechanism similar to a symbolic link, so that if the contents of A or B change, it is reflected in C, without any action?  
```bash
❯ cat part_a
-----------This is part A------------
This is the content of Part A
This is the content of Part A
This is the content of Part A
This is the content of Part A
This is the content of Part A
-----------End of part A------------

❯ cat part_b
-----------This is part B------------
This is the content of Part B
This is the content of Part B
This is the content of Part B
This is the content of Part B
This is the content of Part B
-----------End of part B------------


❯ cat part_c
-----------This is part A------------
This is the content of Part A
This is the content of Part A
This is the content of Part A
This is the content of Part A
This is the content of Part A
-----------End of part A------------
-----------This is part B------------
This is the content of Part B
This is the content of Part B
This is the content of Part B
This is the content of Part B
This is the content of Part B
-----------End of part B------------
```