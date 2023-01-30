#!/usr/bin/env bash

source common.sh

setup() {
  local prj=icmp
  tmux new-session -ds demo "docker exec -it ${prj}-alice-1 bash"
  tmux split-window -dt 0 "docker exec -it ${prj}-bob-1 bash"
  tmux split-window -dht 0 "docker exec -it ${prj}-mitm-1 bash"
  tmux split-window -dht 2 "docker exec -it ${prj}-tmux-1 bash"
}

demo-steps() {
  alice=0
  bob=2
  poison=1
  tmux=3

  pane=$bob
  run "ifconfig eth0 | head -2"
  run "# ping ALICE ..."
  run "ping -W 1 -c 1 10.5.0.2 "

  pane=$tmux
  run "# start smurf containers ..."
  run "# type: docker compose up flood"
}

main "$@"