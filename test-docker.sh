#!/bin/bash -eu

NAME=memcached

function clean {
  echo "✓ Kill and remove container named: $NAME"
  {
    docker kill ${NAME} ||:
    docker rm ${NAME} ||:
  } &> /dev/null
}
clean

DOCKER_IP=$(echo $DOCKER_HOST | awk -F'[/:]' '{print $4}')
: ${DOCKER_IP:=$(ifconfig docker0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*')}
echo "✓ Docker Host IP: $DOCKER_IP"

echo "✓ Create container in detached mode:"
docker run --detach --publish 21211:11211 --name ${NAME} kz8s/memcached

echo "✓ Take a short nap before sending 'stats' query to memcached"
sleep 10
(echo -e 'stats\nquit'; sleep 1) | nc ${DOCKER_IP} 21211
clean
echo "✓ Done"
