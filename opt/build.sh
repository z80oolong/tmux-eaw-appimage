#!/bin/bash

cd /usr/local/tmux/workdir
mkdir -p ./AppDir/usr/lib
mkdir /opt/releases

if [ "$RELEASE_TAG" = "HEAD" ]; then
	export RELEASE_TAG="$RELEASE_TAG-$HEAD_COMMIT"
fi

chmod +x /opt/AppRun
cp -pRv /usr/local/share/terminfo ./AppDir/usr/lib

export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
export OUTPUT="/opt/releases/tmux-eaw-$RELEASE_TAG-x86_64.AppImage"

/usr/local/bin/linuxdeploy --appdir=AppDir \
  -i /opt/tmux-logo-square.png \
  -d /opt/tmux.desktop \
  -e /usr/local/bin/tmux \
  --custom-apprun=/opt/AppRun \
  --output=appimage
