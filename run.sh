#!/bin/bash
/opt/docker-wifi/pidbind.sh &

DOCKER=`docker ps -a | wc -l`
if [ $DOCKER > 1 ]
then
    docker rm -f $(docker ps -a)
fi


docker run -it --rm --network bridge --cap-add NET_ADMIN --name=wifi-container futebolufmg/ubuntu-wifi


