#!/bin/bash
#Checks if the container has already loaded. 
#If positive, moves the interface to the namespace of the container
LINES=`docker ps -a | wc -l`
NETNS=`ls /var/run | grep netns | wc -l`
#DOCKER=`docker ps -a | wc -l`

while [[ $LINES == 1 ]];
do
	LINES=`docker ps -a | wc -l`
done

if [ $NETNS == 0 ]
then
    sudo mkdir /var/run/netns
fi

#if [ $DOCKER > 1 ]
#then
   # docker rm -f $(docker ps -a)
#fi

#Gets the PID of the running container
PID=$(docker inspect -f '{{.State.Pid}}' wifi-container)
#Make a link for the interface inside the process PID
sudo ln -s /proc/$PID/ns/net /var/run/netns/$PID
#Move the interface to the process' namespace
sudo iw phy phy0 set netns $PID
#Bring up the interface inside the container
sudo ip netns exec $PID ip link set wlp2s0 up
#After these steps, the interface will be shown inside the container.
#Run 'ifconfig' and you will see wlp2s0, with no IP address set, but up and running	

