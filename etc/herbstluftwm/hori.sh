#!/usr/bin/env bash

depend() {
  install herbstluftwm
}

add() {
  link autostart ~/.config/herbstluftwm/autostart
  herbstclient reload
}

del() {
  unlink ~/.config/herbstluftwm/autostart
}
