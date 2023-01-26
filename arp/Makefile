setup:
	docker compose up -d

run: setup
	docker compose restart tmux -t 0
	docker exec -e SLEEP=0.07 -it arp-tmux-1 ./demo.sh

record:
	asciinema rec -t "ARP poisioning" arp.cast