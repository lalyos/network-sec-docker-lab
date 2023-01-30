## ARP demo

In this exercise we will demostrate how a bad actor can steal the IP address of a victim.

## Interactive Session

startup session:

```
make run
```
starts all containers and attaches to a preconfigured tmux session (running in a comtainer)

## Exit from session

To leave the interactive tmux session yoiu have to **detach**:
- `CTRL-b d` : control-b followed by a "d" (without ctrl)

## Clean up

Still in the same directory you can:
```
make down
```
It will stop containers belonging to the actual docker-compose.yaml

Or if you have other containers running from a previous example
```
make nuke
```

## Demo

```
make demo
```

## Building images

Normally you don't need to run this manually ...

Docker images are built automatically if missing. But if you make changes to Dockerfiles
you can rebuild images by

```
make build
```
