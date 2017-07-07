#!/bin/bash

DOCKER=`docker ps -f name=wifi-container | wc -l`

if (( $DOCKER == 1 ))
then
    /opt/docker-wifi/pidbind.sh &
    docker run -dit --device /dev/rfkill:/dev/rfkill --network bridge --cap-add=NET_ADMIN --cap-add=SYS_MODULE --name=wifi-container futebolufmg/ubuntu14-wifi
fi

docker exec -ti wifi-container bash
