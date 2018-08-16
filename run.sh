#!/bin/bash

# Check execution conditions
if [ $# -eq 0 ]; then
    echo "Usage: $0 [image_type]"
    echo "image_type must be one of:"
    cat docker-pc-images
    cat docker-rasp-images
    cat lxc-pc-images
    exit 0
fi

CONTAINER=$1

ISDOCKERPC=`cat docker-pc-images | grep $CONTAINER | wc -l`
ISDOCKERRASP=`cat docker-rasp-images | grep $CONTAINER | wc -l`
ISLXCPC=`cat lxc-pc-images | grep $CONTAINER | wc -l`

if (( $ISDOCKERPC || $ISDOCKERRASP ))
then
  DOCKER=`docker ps -a | grep wifi-container | wc -l`
  # Container is of type docker
  if (( $DOCKER == 0 )) # Only the header line returned from 'docker ps'
  then                  # meaning no container is active on this machine.
      docker run -dit \
      --device /dev/rfkill:/dev/rfkill \
      -v /tmp/.X11-unix:/tmp/.X11-unix \
      -e DISPLAY=unix$DISPLAY \
      --device /dev/snd \
      --privileged \
      --network bridge \
      --cap-add=NET_ADMIN \
      --cap-add=SYS_MODULE \
      --name=wifi-container $CONTAINER > /dev/null 2> /dev/null
      /opt/docker-wifi/pidbind.sh $CONTAINER &
  fi
  # Open a bash inside of the container and return the tty.
  docker exec -ti wifi-container bash
else # Container is of type LXC
  LXCLIST=`lxc list | grep wifi-container | wc -l`
  if (( $LXCLIST == 0 )) # No other container is currently running
  then
    lxc launch $CONTAINER wifi-container > /dev/null 2> /dev/null
    /opt/docker-wifi/pidbind.sh $CONTAINER &
  fi
  # Open a bash inside of the container and return the tty.
  lxc exec wifi-container bash
fi
