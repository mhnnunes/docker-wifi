#!/bin/bash


if [ $# -eq 0 ]; then
    echo "Usage: $0 [image_type (options: ethanol | ubuntu16 | \
ubuntu14]"
    exit 0
fi

DOCKER=`docker ps -f name=wifi-container | wc -l`

if (( $DOCKER == 1 ))
then
    docker run -dit --device /dev/rfkill:/dev/rfkill --privileged --network bridge --cap-add=NET_ADMIN --cap-add=SYS_MODULE --name=wifi-container $1 > /dev/null 2> /dev/null
    #docker run -dit --device /dev/rfkill:/dev/rfkill --privileged --network bridge --name=wifi-container image_type
    /opt/docker-wifi/pidbind.sh &
fi

docker exec -ti wifi-container bash
