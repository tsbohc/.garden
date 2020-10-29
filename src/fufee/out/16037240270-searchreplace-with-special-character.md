# Search/replace with special character

5 | 1603724027.0

I can get rid of ASCII NUL/char(0) like this:

    :%s/[\x0]/\r/g

But reversing the intent does not put things back as they were:

    :%s/\n/[\x0]/g

I wind up with [0] in my file where I'd wanted NUL. I've also tried `\%x00` as the replacement.

What should I read to clear up why `[\x0]` works as a search term, but not for replacement?