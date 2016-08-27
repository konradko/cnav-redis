SHELL := /bin/bash

build:
	docker build . -t konradko/cnav-redis
	mkdir -p $(PWD)/data

run:
	docker run --detach --name cnav-redis konradko/cnav-redis

run_with_storage:
	docker run --detach --name cnav-redis --volume=$(PWD)/data:/data konradko/cnav-redis redis-server --appendonly yes

container = $(docker ps -a -q --filter ancestor=konradko/cnav-redis --format="{{.ID}}")
logs:
	docker logs -f $(value container)

stop_and_remove = docker rm $(docker stop $(docker ps -a -q --filter ancestor=konradko/cnav-redis --format="{{.ID}}"))
remove:
	$(value stop_and_remove)


.PHONY: build run run_with_storage remove logs
