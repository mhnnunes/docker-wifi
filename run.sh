#!/bin/bash
./pidbind.sh &

docker run -it --rm --network none --cap-add NET_ADMIN --name=wifi-container mhnnunes/ubuntu-wifi


