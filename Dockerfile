FROM docker.io/ubuntu:14.04

RUN apt-get update && \
    apt-get -qy install apt-utils curl libssl-dev libnl-dev libnl1 \
#        libnl-3-dev libnl-genl-3-dev 
	build-essential python python-pip make cmake \
        ca-certificates net-tools iputils-ping usbutils\
        vim pkg-config nano openssh-client openssh-server git \
        bridge-utils iptables wireless-tools man rfkill \
        wpasupplicant  

RUN git clone git://w1.fi/srv/git/hostap.git /home/hostap
ADD .config /home/hostap/hostapd/.config
RUN cd /home/hostap/hostapd && make && make install
RUN cd /home
RUN wget -c https://www.kernel.org/pub/software/network/iw/iw-4.9.tar.gz
RUN tar zxvf iw-4.9.tar.gz
RUN cd iw-4.9/ && make && make install
