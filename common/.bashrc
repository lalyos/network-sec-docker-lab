myip() { 
    ip -4 -o a show dev eth0 | sed 's/.*inet \([0-9\.]*\).*/\1/'
}

alias ll='ls -lah'

export PS1='[$(myip)] \h \w \$ '