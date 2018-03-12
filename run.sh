#!/bin/bash


# Check execution conditions
if [ $# -eq 0 ]; then
    echo "Usage: $0 [image_type (options: ethanol | ubuntu16 | \
ubuntu14]"
    exit 0
fi

CONTAINER=$1
DOCKER=`docker ps -f name=wifi-container | wc -l`

if (( $DOCKER == 1 )) # Only the header line returned from 'docker ps'
then                  # meaning no container is active on this machine.
    docker run -dit \
    --device /dev/rfkill:/dev/rfkill \    # These three lines add the
    -v /tmp/.X11-unix:/tmp/.X11-unix \    # capability of opening a GUI
    -e DISPLAY=unix$DISPLAY \             # inside of the container.
    --device /dev/snd \                   # This line enables sound.
    --privileged \
    --network bridge \
    --cap-add=NET_ADMIN \
    --cap-add=SYS_MODULE \
    --name=wifi-container \
    $CONTAINER > /dev/null 2> /dev/null
    /opt/docker-wifi/pidbind.sh &
fi

# Open a bash inside of the container and return the tty.
docker exec -ti wifi-container bash
