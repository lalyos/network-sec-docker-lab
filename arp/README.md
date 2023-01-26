## ARP demo

In this exercise we will demostrate how a bad actor can steal the IP address of a victim.

## Setup

startup session:

```
docker compose up -d
```

## Demo

```
docker compose exec tmux ./demo.sh
```

## Re-run the demo

While developing the demo.sh script, you might want to re-run the whole script.
You have to:
- restart the *driver* container
- run the demo script in the new container

```
docker compose restart tmux -t 0 && docker exec -e SLEEP=0.01 -it arp-tmux-1 ./demo.sh
```

With the `SLEEP` env var you can controll the fake typing speed (default is 0.07 sec)