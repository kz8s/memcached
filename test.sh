#!/bin/bash -eu

NAME=memcached

# docker-machine
DOCKER_MACHINE=$(which docker-machine)
if [ -n "$DOCKER_MACHINE" ]; then
  ACTIVE_MACHINE=$($DOCKER_MACHINE active)
  if [ -n "$ACTIVE_MACHINE" ]; then
    DOCKER_IP=$($DOCKER_MACHINE ip ${ACTIVE_MACHINE})
  fi
fi

DOCKER_IP=${DOCKER_IP:-127.0.0.1}

echo "✓ Docker Host IP: $DOCKER_IP"

docker run --detach --publish 21211:11211 --name ${NAME} kz8s/memcached; sleep 10
(echo -e 'stats\nquit'; sleep 1) | nc ${DOCKER_IP} 21211

docker kill ${NAME} && docker rm ${NAME}
