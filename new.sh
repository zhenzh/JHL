#!/bin/sh

sed "s/xxx/$1/g" ids/EXAMPLE > ids/$1

docker container rm -f $(docker container list -q -f name=$1) 2> /dev/null
docker run --name $1 -it -d --hostname $1 -v $PWD:/paotin/mud/jhl -v $PWD/ids:/paotin/var/ids mudclient/paotin:latest daemon
docker exec -it $1 start-ui
