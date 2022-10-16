#!/bin/bash

if [[ `docker image list jhl:latest | wc -l` -le 1 ]] || [[ $2 == "--new-image" ]]; then
    docker build -t jhl:latest .
    if [[ $? -ne 0 ]]; then
        echo "image build failed, try again"
        exit 1
    fi
fi

if [[ $2 == "--new-image" ]]; then
    docker container stop `docker container list -a -q -f name=$1`
    docker container rm `docker container list -a -q -f name=$1`
fi

if [[ `docker container list -a -f name=$1 | wc -l` -le 1 ]]; then
    docker run --name $1 --hostname $1 -e "USERID=$1" -d -v $PWD:/JHL jhl:latest
    docker exec `docker container list -q -f name=$1` sh -c "screen -U -T screen-256color -dmS jhl ./start.sh $1"
elif [[ $2 == "--renew" ]]; then
    docker container stop `docker container list -a -q -f name=$1`
    docker container rm `docker container list -a -q -f name=$1`
    docker run --name $1 --hostname $1 -e "USERID=$1" -d -v $PWD:/JHL jhl:latest
    docker exec `docker container list -q -f name=$1` sh -c "screen -U -T screen-256color -dmS jhl ./start.sh $1"
fi

docker exec -it `docker container list -q -f name=$1` sh -c "screen -R jhl"
