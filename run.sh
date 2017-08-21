#!/bin/bash

DOCKER=`docker ps -f name=wifi-container | wc -l`

if (( $DOCKER == 1 ))
then
    /opt/docker-wifi/pidbind.sh &
    docker run -dit --device /dev/rfkill:/dev/rfkill --network bridge --cap-add=NET_ADMIN --cap-add=SYS_MODULE --name=wifi-container image_type
    #docker run -dit --device /dev/rfkill:/dev/rfkill --privileged --network bridge --name=wifi-container image_type
fi

docker exec -ti wifi-container bash
