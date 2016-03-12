NAME := kz8s/memcached
TAG := latest

DOCKER_HOST_IP := 127.0.0.1

all: build test

build: ; @docker build --tag ${NAME}:${TAG} .

clean: ; @docker rmi --force ${NAME}:${TAG}

test:
	@docker run ${NAME}:${TAG} memcached -h | grep "^memcached"
	docker run --detach --publish 21211:11211 --name memcached kz8s/memcached; sleep 10
	(echo -e 'stats\nquit'; sleep 1) | nc ${DOCKER_HOST_IP} 21211
	docker kill memcached
	docker rm memcached

.PHONY: all build clean test
