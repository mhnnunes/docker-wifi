FROM docker.io/ubuntu:14.04

RUN apt-get update && \
    apt-get -qy install apt-utils curl libnl1 \
        build-essential python python-pip \
        ca-certificates net-tools iputils-ping usbutils\
        vim pkg-config nano openssh-client openssh-server git \
        bridge-utils iptables iw wireless-tools man rfkill \
        wpasupplicant hostapd

RUN git clone git://w1.fi/srv/git/hostap.git /home/
RUN cd /home/hostap/hostapd
ADD ../hostap/hostapd/.config /home/hostap/hostapd/.config
RUN make
RUN make install
