#!/bin/bash

# Check execution conditions
if [ $# -eq 0 ]; then
    echo "Usage: $0 [image_type (options: ethanol | srslte | ubuntu16 | \
ubuntu14]"
    exit 0
fi

CONTAINER=$1
if [[ "${CONTAINER}" =~ ^(ethanol|srslte|ubuntu16|ubuntu14)$ ]]; then
  DOCKER=`docker ps -a | grep wifi-container | wc -l`
  # Container is of type docker
  if (( $DOCKER == 0 )) # Only the header line returned from 'docker ps'
  then                  # meaning no container is active on this machine.
      docker run -dit --device /dev/rfkill:/dev/rfkill -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY --device /dev/snd --privileged --network bridge --cap-add=NET_ADMIN --cap-add=SYS_MODULE --name=wifi-container $CONTAINER > /dev/null 2> /dev/null
      docker exec wifi-container apt install -y tcpdump > /dev/null 2> /dev/null
      docker exec wifi-container mv /usr/sbin/tcpdump /usr/bin > /dev/null 2> /dev/null
      docker exec wifi-container ln -s /usr/bin/tcpdump /usr/sbin/tcpdump > /dev/null 2> /dev/null
      /opt/docker-wifi/pidbind.sh $CONTAINER &
  fi
  # Open a bash inside of the container and return the tty.
  docker exec -ti wifi-container bash
else # Container is of type LXC
  LXCLIST=`lxc list | grep wifi-container | wc -l`
  if (( $LXCLIST == 0 )) # No other container is currently running
  then
    lxc launch $CONTAINER wifi-container > /dev/null 2> /dev/null
  fi
  # Open a bash inside of the container and return the tty.
  lxc exec wifi-container bash
fi
