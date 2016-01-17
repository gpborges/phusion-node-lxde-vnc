FROM phusion/baseimage
MAINTAINER Gabriel Borges <gpborges@gmail.com>

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

# Atom editor version
ENV ATOM_VERSION v1.4.0

# Contatenate all RUN commands into one sentence to optmize fs layer creation and reduce image size
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get dist-upgrade -y \
    && apt-get install -y --force-yes --no-install-recommends supervisor \
        pwgen sudo vim-tiny \
        net-tools \
        lxde x11vnc xvfb \
        gtk2-engines-murrine ttf-ubuntu-font-family \
        fonts-wqy-microhei \
        mesa-utils libgl1-mesa-dri \

        #Install Node.js and npm
        nodejs npm \

        # Install Firefox
        firefox \

        # Install Atom editor and dependencies
        git \
        wget \
        curl \
        ca-certificates \
        libgtk2.0-0 \
        libxtst6 \
        libnss3 \
        libgconf-2-4 \
        libasound2 \
        fakeroot \
        gconf2 \
        gconf-service \
        libcap2 \
        libnotify4 \
        libxtst6 \
        libnss3 \
        gvfs-bin \
        xdg-utils -y --no-install-recommends \
    && curl -L https://github.com/atom/atom/releases/download/${ATOM_VERSION}/atom-amd64.deb > /tmp/atom.deb \
    && dpkg -i /tmp/atom.deb \
    && rm -f /tmp/atom.deb \

    # Create a symlink to nodejs
    && ln -s /usr/bin/nodejs /usr/bin/node \

    # Cleanup everything

    && apt-get clean \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# We need to insatll a newer version of x11vnc package because the one available in default
# Ubuntu repository (0.9.13) crashes when a VNC client connects from a host machine 
# which has ipv6.disable=1 on kernel boot.

ADD https://dl.dropboxusercontent.com/u/23905041/x11vnc_0.9.14-1.1ubuntu1_amd64.deb /tmp/
ADD https://dl.dropboxusercontent.com/u/23905041/x11vnc-data_0.9.14-1.1ubuntu1_all.deb /tmp/
RUN dpkg -i /tmp/x11vnc*.deb

ADD startup.sh /
ADD supervisord.conf /etc/supervisor/conf.d/
ADD doro-lxde-wallpapers /usr/share/doro-lxde-wallpapers/

#Expose VNC and Node ports
EXPOSE 5900
EXPOSE 3000

# Define working directory.
WORKDIR /root

# Create a mouting point on the container so that files written to this directory
# persists outside the container. The host machine can specify a directory to be
# mapped to this mounting point using the -v switch
VOLUME /data

ENTRYPOINT ["/startup.sh"]
