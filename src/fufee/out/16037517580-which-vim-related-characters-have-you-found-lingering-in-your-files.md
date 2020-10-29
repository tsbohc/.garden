# Which Vim related characters have you found lingering in your files?

1 | 1603751758.0

When scanning over 300+ blog posts I found a few cases of :w, II at the start of the line and A at the end of the line.

Are there any other common things to search for that you might accidentally add with Vim?

I ended up making a video about this at: https://www.youtube.com/watch?v=XTEJ8A4UUd4

And I searched through everything with: `grep -E "(:w|^II|A$)" -Ro .`