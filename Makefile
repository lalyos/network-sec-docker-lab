REPO=cyd

build-common:
	docker build -t $(REPO)-common common

build-kali:
	docker build -t $(REPO)-kali kali

build-arp:
	docker build -t $(REPO)-arp arp --build-arg BASE=$(REPO)-common

build-all: build-common build-arp build-kali

.PHONY: build-