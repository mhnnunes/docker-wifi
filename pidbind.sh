#!/bin/bash
CONTAINER=$1

# Check if network namespace directory exists, if not, create it
NETNS=`ls /var/run | grep netns | wc -l`

if [ $NETNS == 0 ]
then
  sudo mkdir /var/run/netns
fi

if [[ "${CONTAINER}" =~ ^(ethanol|srslte|ubuntu16|ubuntu14)$ ]]; then
  # Container is of type docker
  # Gets the PID of the running container
  PID=$(docker inspect -f '{{.State.Pid}}' wifi-container)
 else
  # Container is of type LXC
  PID=`lxc info wifi-container | grep Pid | awk '{print $2}'`
fi

WIFI_INTERFACE=`ifconfig | grep wl | awk '{print $1}'`
# Make a link for the interface inside the process PID
sudo ln -s /proc/$PID/ns/net /var/run/netns/$PID >/dev/null 2>/dev/null
# Move the interface to the process' namespace
sudo iw phy phy0 set netns $PID >/dev/null 2>/dev/null
# Bring up the interface inside the container
sudo ip netns exec $PID ip link set $WIFI_INTERFACE up >/dev/null 2>/dev/null
# After these steps, the interface will be shown inside the container.
# Run 'ifconfig' and you will see wlp2s0, with no IP address set,
# but up and running  

# Start configuring the ethernet interface inside the container
# Add a new virtual interface, binding it in bridge mode to br0
# It will receive a dinalmically allocated MAC address from the kernel
sudo ip link add virtual0 link br0 type macvlan mode bridge >/dev/null \
  2>/dev/null
# Bring interface up
sudo ip link set virtual0 up >/dev/null 2>/dev/null 
# Bring interface up inside the container
sudo ip link set virtual0 netns $PID >/dev/null 2>/dev/null
sudo ip netns exec $PID ip link set virtual0 up >/dev/null 2>/dev/null


# Get virtual0 a working IP address inside of container
if [[ "${CONTAINER}" =~ ^(ethanol|srslte|ubuntu16|ubuntu14)$ ]]; then
  # Container is of type docker
  docker exec wifi-container dhclient virtual0 >/dev/null 2>/dev/null
else
  # Container is of type LXC
  lxc exec wifi-container dhclient virtual0 >/dev/null 2>/dev/null
fi
