NAME := kz8s/memcached
TAG := latest

all: build test

build: ; @docker build --tag ${NAME}:${TAG} .

clean: ; @docker rmi --force ${NAME}:${TAG}

test:
	@docker run ${NAME}:${TAG} memcached -h | grep "^memcached"
	./test.sh

.PHONY: all build clean test
