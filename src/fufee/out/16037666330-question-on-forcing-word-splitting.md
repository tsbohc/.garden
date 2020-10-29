# Question on "forcing" word splitting

1 | 1603766633.0

Dear all:

Does it possible to still allow word splitting while IFS is null? That is to say, 

```sh
str='EDRJLKwoeiurqoiweurasdf'
IFS=
set -- $str
echo $1

## expect to get E
```

Thanks!