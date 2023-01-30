build: 
	docker compose build

build-if-missing:
	@docker image inspect cyd-kali &>/dev/null || docker compose build

up: build-if-missing
	docker compose up -d

run: up
	docker exec -it arp-tmux-1 ./demo-setup.sh

demo: up
	docker exec -e SLEEP=0.05 -it arp-tmux-1 ./demo.sh

record:
	asciinema rec -t "ARP poisioning" arp.cast

down:
	docker compose down -t 0
	