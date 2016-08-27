SHELL := /bin/bash

build:
	docker build . -t konradko/cnav-redis
	mkdir -p $(PWD)/data

run:
	docker run --detach -p 6379:6379 --name cnav-redis --volume=$(PWD)/data:/data konradko/cnav-redis redis-server --appendonly yes

docker_logs = docker logs -f $(docker ps -a -q --filter ancestor=konradko/cnav-redis --format="{{.ID}}")
logs:
	$(value docker_logs)

docker_stop_and_remove = docker rm $(docker stop $(docker ps -a -q --filter ancestor=konradko/cnav-redis --format="{{.ID}}"))
remove:
	$(value docker_stop_and_remove)

start: remove build run logs

redis_cli = docker run -it --link cnav-redis --rm konradko/cnav-redis redis-cli -h cnav-redis -p 6379
cli:
	$(value redis_cli)


.PHONY: build start run remove logs cli
