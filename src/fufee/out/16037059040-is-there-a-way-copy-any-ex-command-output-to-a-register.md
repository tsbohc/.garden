# Is there a way copy any ex command output to a register?

10 | 1603705904.0

Is there a way copy any ex command output to a register?

I would like it can auto capture, don't want to use a specical command every time

always need the output but have to mouse copy

I have this line manual excute a command and copy to register, but don't know how to auto copy

like `autocmd` or a set like `set exoutput register and normal output `

```
nnoremap yc :let @+=substitute(execute(''), '', '', 'g')&lt;Left&gt;&lt;Left&gt;&lt;Left&gt;&lt;Left&gt;&lt;Left&gt;&lt;Left&gt;&lt;Left&gt;&lt;Left&gt;&lt;Left&gt;&lt;Left&gt;&lt;Left&gt;&lt;Left&gt;&lt;Left&gt;&lt;Left&gt;&lt;Left&gt;&lt;Left&gt;
```

the left used to move cursor to there `execute('there')`