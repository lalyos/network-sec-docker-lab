#!/usr/bin/env bash

: ${SLEEP:=0.07}

run() {
  #declare pane=$1 ; shift
  : ${pane:? required}

  msg="$*"
  for (( i=0; i<${#msg}; i++ )); do
    sleep ${SLEEP:-0.07}
    tmux send-keys -t ${pane} "${msg:$i:1}"
  done
  tmux send-keys -t ${pane} ENTER
}

setup() {
  local prj=icmp
  tmux new-session -ds demo "docker exec -it ${prj}-alice-1 bash"
  tmux split-window -dt 0 "docker exec -it ${prj}-bob-1 bash"
  tmux split-window -dht 0 "docker exec -it ${prj}-mitm-1 bash"
  tmux split-window -dht 2 "docker exec -it ${prj}-tmux-1 bash"
}

demo() {
  alice=0
  bob=2
  poison=1
  tmux=3

  pane=$bob
  run "ifconfig eth0 | head -2"
  run "# ping ALICE ..."
  run "ping -W 1 -c 1 10.5.0.2 "

  pane=$tmux
  run "# start sumrf containers ..."
  run "# type: docker compose up flood"
}

setup
demo &
tmux attach

