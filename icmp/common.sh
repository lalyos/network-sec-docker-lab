#!/usr/bin/env bash

: ${SLEEP:=0.07}

debug() {
    if ((DEBUG)); then
       echo "===> [${FUNCNAME[1]}] $*" 1>&2
    fi
}

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

tmux-usage() {
  sleep 0.1
  tmux send-keys -t 0 "# you can exit tmux by: CTR-b d" ENTER
  tmux send-keys -t 0 "# switch pane: CTR-b <arrow>" ENTER
}

setup-wrapper() {
  # figure out actual project name by local docke-compose.yaml
  tmuxid=$(docker compose ps -q tmux)
  composePrj=$(docker inspect $tmuxid --format '{{ index  .Config.Labels "com.docker.compose.project" }}')

  tmux kill-session -t demo &>/dev/null || true
  setup
}

# starts tmux session for student to play around
play() {
  setup-wrapper
  tmux-usage
  tmux attach
}

demo() {
  setup-wrapper
  demo-steps &
  tmux attach
}


main() {
  debug main started ...
  # if last arg is -d sets DEBUG
  [[ ${@:$#} =~ -d ]] && { set -- "${@:1:$(($#-1))}" ; DEBUG=1 ; } || :

  # command specified as 1.st param
  if [[ "$1" ]]; then
    "$@"
  else 
    # default-command
    play
  fi 
}

#[[ "$0" == "$BASH_SOURCE" ]] && main "$@" || true
