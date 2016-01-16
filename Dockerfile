FROM phusion/baseimage
MAINTAINER Gabriel Borges <gpborges@gmail.com>

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /data

# Atom editor version
ENV ATOM_VERSION v1.4.0

# Contatenate all RUN commands into one sentence to optmize fs layer creation and reduce image size
RUN apt-get update \
    && apt-get install -y --force-yes --no-install-recommends supervisor \
        pwgen sudo vim-tiny \
        net-tools \
        lxde x11vnc xvfb \
        gtk2-engines-murrine ttf-ubuntu-font-family \
        fonts-wqy-microhei \
        mesa-utils libgl1-mesa-dri \

        # Install Atom editor and dependencies
        git \
        wget \
        curl \
        nodejs \
        npm \
        firefox \
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
    ln -s /usr/bin/nodejs /usr/bin/node \

    # Cleanup everything

    && apt-get clean \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

ADD https://dl.dropboxusercontent.com/u/23905041/x11vnc_0.9.14-1.1ubuntu1_amd64.deb /tmp/
ADD https://dl.dropboxusercontent.com/u/23905041/x11vnc-data_0.9.14-1.1ubuntu1_all.deb /tmp/
RUN dpkg -i /tmp/x11vnc*.deb

RUN git clone https://github.com/mirolima/lab3865app.git \
  cd lab3865app \
  npm install \
  node app

ADD startup.sh /
ADD supervisord.conf /etc/supervisor/conf.d/
ADD doro-lxde-wallpapers /usr/share/doro-lxde-wallpapers/

#Expose VNC/NODE ports
EXPOSE 5900
EXPOSE 3000

# Define working directory.
WORKDIR /data

ENTRYPOINT ["/startup.sh"]
