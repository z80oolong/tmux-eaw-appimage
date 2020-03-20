#!/bin/bash

mkdir /opt/releases

export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
export OUTPUT="/opt/releases/tmux-eaw-$RELEASE_TAG-x86_64.AppImage"

/usr/local/bin/linuxdeploy --appdir=AppDir \
  -i /opt/tmux-logo-square.png \
  -d /opt/tmux.desktop \
  -e /usr/local/bin/tmux --output=appimage
