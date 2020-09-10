<h1 align="center">.files</h1>

<table align="right">
  <tr>
    <td><code><b>bin/</b></code></td>
    <td>path entries</td>
  </tr>
  <tr>
    <td><code><b>etc/</b></code></td>
    <td>config files</td>
  </tr>
  <tr>
    <td><code><b>src/</b></code></td>
    <td>code sandbox</td>
  </tr>
  <tr>
    <td><code><b>tmp/</b></code></td>
    <td>to be removed</td>
  </tr>
  <tr>
    <td><code><b>usr/</b></code></td>
    <td>extras</td>
  </tr>
</table>

Dotfiles can be a collection of raw, functional forks. They can be finely tuned and very personal. Or something in between. 

Here, I like to learn by doing. Although it may be crude, awfully written pieces of code, each one of them is a lesson learned.

Enjoy your stay.

<br>

# soap

Soap is the third rewrite of my personal config bootstrap script. It was designed to be a learning project and a way to reality check my current level of bash. It's been with me since day one of using linux

Soap reads simple instructions from the top of the file and takes care of the rest. currently it has no extra dependencies and is able to

- symlink and be kinda smart about it
- set up nvim and plug
- install arch and pip packages
- sync itself to and from the repo
- log pretty things w/ exit statuses and partial live command output

# lantern
An app launcher/file browser that attempts to provide relevant suggestions by tracking frequency of use. When adding new entries, lantern assigns tags by guessing the best way to act on a file. Any entry can be tabbed to show a list of actions. Lantern can be launched in an existing terminal or spawn itself in a new window.

powered by fzf, inspired by quicksilver
