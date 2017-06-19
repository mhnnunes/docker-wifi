#!/bin/bash

DOCKER=`docker ps -a | wc -l`
if [ $DOCKER > 1 ]
then
    docker rm -f $(docker ps -a | tail -n +2 |awk '{print $1}' ) 
fi

/opt/docker-wifi/pidbind.sh &

docker run -it --rm --network bridge --cap-add NET_ADMIN --name=wifi-container futebolufmg/ubuntu-wifi


