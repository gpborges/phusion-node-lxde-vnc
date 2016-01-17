phusion-node-lxde-vnc
=====================

This image is a fork of https://github.com/fcwu/docker-ubuntu-vnc-desktop.git

The following changes were applied:

- Removed noVNC and dependencies
- Tweaked supervisor, removing unecessary code after removing noVNC
- Added Node.js
- Added Atom editor

From Docker Hub
```
docker pull gpborges/gpborges/phusion-node-lxde-vnc
```

Build yourself
```
git clone https://github.com/gpborges/phusion-node-lxde-vnc.git
docker build -t gpborges/phusion-node-lxde-vnc .
```

Run
```
docker run -d -p 5900:5900 -p 3000:3000 gpborges/phusion-node-lxde-vnc
```

<img src="https://raw.github.com/gpborges/phusion-node-lxde-vnc/master/screenshots/phusion-node-lxde-vnc-desktop.png" width=400/>


Troubleshooting
==================

1. boot2docker connection issue, https://github.com/fcwu/docker-ubuntu-vnc-desktop/issues/2


License
==================

desktop-mirror is under the Apache 2.0 license. See the LICENSE file for details.
