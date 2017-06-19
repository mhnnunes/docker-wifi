#!/bin/bash
/opt/pidbind.sh &

DOCKER=`docker ps -a | wc -l`
if [[ $DOCKER > 1 ]];
    docker rm -f $(docker ps -a)
fi


docker run -it --rm --network bridge --cap-add NET_ADMIN --name=wifi-container futebolufmg/ubuntu-wifi


