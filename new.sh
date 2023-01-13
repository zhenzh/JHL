#!/bin/sh

if [ ! -f "ids/$1" ]; then
    printf "请输入帐户登录密码："
    read passwd
    sed "s/xxx/$1/g;s/000/$passwd/g" ids/EXAMPLE > ids/$1
fi

docker container rm -f $(docker container list -q -f name=$1) 2> /dev/null
docker run --name $1 -it -d --hostname $1 -v $PWD:/paotin/mud/jhl -v $PWD/ids:/paotin/var/ids -v $PWD/bin/start-ui:/paotin/bin/start-ui mudclient/paotin:latest daemon
docker exec -it $1 start-ui auto
