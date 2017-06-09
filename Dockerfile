FROM docker.io/ubuntu

RUN apt-get update && \
    apt-get -qy install apt-utils curl \
		build-essential python python-pip \
                ca-certificates net-tools iputils-ping usbutils\
                vim openssh-client openssh-server git \
                bridge-utils iptables iw wireless-tools man
