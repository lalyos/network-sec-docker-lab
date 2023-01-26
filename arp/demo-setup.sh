#!/usr/bin/env bash

setup() {
  local prj=arp
  tmux new-session -ds demo "docker exec -it ${prj}-alice-1 bash"
  tmux split-window -dt 0 "docker exec -it ${prj}-bob-1 bash"
  tmux split-window -dht 0 "docker exec -it ${prj}-mitm-1 bash"
  tmux split-window -dht 2 "docker exec -it ${prj}-mitm-1 bash"
}

setup
tmux attach

