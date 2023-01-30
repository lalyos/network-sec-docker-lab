#!/usr/bin/env bash

setup() {
  local prj=arp
  tmux kill-session -t demo 2>/dev/null || true
  tmux new-session -ds demo "docker attach ${prj}-alice-1"
  tmux split-window -dt 0 "docker attach ${prj}-bob-1"
  tmux split-window -dht 0 "docker attach ${prj}-mitm-1"
  tmux split-window -dht 2 "docker attach ${prj}-mitm-1"
  tmux send-keys -t 0 "# you can exit tmux by: CTR-b d" ENTER
  tmux send-keys -t 0 "# switch pane: CTR-b <arrow>" ENTER
}

setup
tmux attach

