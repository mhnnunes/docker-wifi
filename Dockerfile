FROM docker.io/ubuntu:14.04

RUN apt-get update && \
    apt-get -qy install apt-utils curl libnl1 libnl-dev \
        build-essential python python-pip \
        ca-certificates net-tools iputils-ping usbutils\
        vim pkg-config nano openssh-client openssh-server git \
        bridge-utils iptables wireless-tools man rfkill \
        wpasupplicant hostapd

RUN git clone git://w1.fi/srv/git/hostap.git /home/
RUN cd /home/hostap/hostapd
ADD ../hostap/hostapd/.config /home/hostap/hostapd/.config
RUN make
RUN make install
RUN cd /home
RUN wget -c https://www.kernel.org/pub/software/network/iw/iw-4.9.tar.gz
RUN tar zxvf iw-4.9.tar.gz
RUN cd iw-4.9/
RUN make
RUN make install
