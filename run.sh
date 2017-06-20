#!/bin/bash

DOCKER=`docker ps -f name=wifi-container`
if [ $DOCKER > 1 ]
then
    # docker rm -f $(docker ps -a | tail -n +2 |awk '{print $1}' ) &> /dev/null
    docker attach wifi-container
else
    /opt/docker-wifi/pidbind.sh &
    docker run -it --network bridge --cap-add NET_ADMIN --name=wifi-container futebolufmg/ubuntu-wifi
fi


