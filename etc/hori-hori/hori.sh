grow() {
  link rake "~/.garden/bin/rake"
}

weed() {
  unlink "~/.garden/bin/rake"
}
