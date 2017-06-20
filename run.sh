#!/bin/bash

DOCKER=`docker ps -f name=wifi-container | wc -l`

if (( $DOCKER == 1 ))
then
    /opt/docker-wifi/pidbind.sh &
    docker run -dit --network bridge --cap-add NET_ADMIN --name=wifi-container futebolufmg/ubuntu-wifi
fi

docker exec -ti wifi-container bash
