#!/bin/bash

cd /opt
mkdir /opt/releases
mkdir -p ./AppDir/usr/lib

export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
export LD_LIBRARY_PATH="$HOMEBREW_PREFIX/opt/tmux-ncurses@6.2/lib:$HOMEBREW_PREFIX/lib:$LD_LIBRARY_PATH"
export OUTPUT="/opt/releases/tmux-eaw-$RELEASE_TAG-x86_64.AppImage"

case "$RELEASE_TAG" in
  HEAD-*) RELEASE="3.2-dev"      ;;
  *)      RELEASE="$RELEASE_TAG" ;;
esac

chmod +x /opt/AppRun
cp -pRv $HOMEBREW_PREFIX/opt/tmux-ncurses@6.2/share/terminfo ./AppDir/usr/lib

/usr/local/bin/linuxdeploy --appdir=AppDir \
  -i /opt/tmux-logo-square.png \
  -d /opt/tmux.desktop \
  -e $HOMEBREW_PREFIX/opt/tmux@$RELEASE/bin/tmux \
  --custom-apprun=/opt/AppRun \
  --output=appimage
