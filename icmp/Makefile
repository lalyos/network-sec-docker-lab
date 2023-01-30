build: 
	docker compose build

build-if-missing:
	@docker image inspect cyd-kali &>/dev/null || docker compose build

up: build-if-missing
	docker compose up -d

run: up
	docker compose exec tmux ./start.sh

demo: up
	docker compose exec -e SLEEP=0.05 tmux ./start.sh demo

record:
	asciinema rec -t "ARP poisioning" arp.cast

down:
	docker compose down -t 0

logs:
	docker compose logs --no-color --follow

nuke:
	@echo remove all containers ...
	@docker rm -f $(shell docker ps -qa) 2>/dev/null | true
	@echo remove all networks
	@docker network prune -f
	