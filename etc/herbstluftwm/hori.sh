#!/usr/bin/env bash

depend() {
  install herbstluftwm
}

setup() {
  link autostart ~/.config/herbstluftwm/autostart
  herbstclient reload
}

remove() {
  unlink ~/.config/herbstluftwm/autostart
}
