#!/bin/bash
/opt/docker-wifi/pidbind.sh &

docker run -it --rm --network bridge --cap-add NET_ADMIN --name=wifi-container futebolufmg/ubuntu-wifi


