#!/usr/bin/env bash

setup() {
  local prj=arp
  tmux new-session -ds demo "docker attach ${prj}-alice-1"
  tmux split-window -dt 0 "docker attach ${prj}-bob-1"
  tmux split-window -dht 0 "docker attach ${prj}-mitm-1"
  tmux split-window -dht 2 "docker attach ${prj}-mitm-1"
}

setup
tmux attach

