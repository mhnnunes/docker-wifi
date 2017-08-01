FROM docker.io/ubuntu:14.04

RUN apt-get update && \
    apt-get -qy install apt-utils curl libssl-dev libnl1 libnl-dev \
        build-essential python python-pip make cmake \
        ca-certificates net-tools iputils-ping usbutils\
        vim pkg-config nano openssh-client openssh-server git \
        bridge-utils iptables wireless-tools man rfkill \
        wpasupplicant libnl-3-dev libnl-genl-3-dev

RUN git clone git://w1.fi/srv/git/hostap.git /home/hostap
RUN cd /home/hostap/hostapd
ADD .config /home/hostap/hostapd/.config
RUN make
RUN make install
RUN cd /home
RUN wget -c https://www.kernel.org/pub/software/network/iw/iw-4.9.tar.gz
RUN tar zxvf iw-4.9.tar.gz
RUN cd iw-4.9/
RUN make
RUN make install
