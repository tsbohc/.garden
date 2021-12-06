#!/bin/sh

echo "$(whoami) reached entrypoint in $(pwd)"
ls -l
echo

mkdir -v -p \
  /data/watch \
  /data/temp \
  /data/down

exec "$@"
