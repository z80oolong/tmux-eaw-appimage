#!/bin/bash

export OPTDIR="/home/linuxbrew/opt"
export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
export LD_LIBRARY_PATH="$HOMEBREW_PREFIX/opt/tmux-ncurses@6.2/lib:$HOMEBREW_PREFIX/opt/tmux-libevent@2.2/lib:$HOMEBREW_PREFIX/lib:$LD_LIBRARY_PATH"

cd $OPTDIR
mkdir ./releases
mkdir -p ./AppDir/usr/lib

case "$RELEASE_TAG" in
  HEAD-*)  RELEASE="3.3-next"      ;;
  3.2-rc*) RELEASE="3.2"      ;;
  *)       RELEASE="$RELEASE_TAG" ;;
esac

chmod +x $OPTDIR/AppRun
cp -pRv $HOMEBREW_PREFIX/opt/tmux-ncurses@6.2/share/terminfo ./AppDir/usr/lib

sudo env OUTPUT="$OPTDIR/releases/tmux-eaw-$RELEASE_TAG-x86_64.AppImage" \
  $HOMEBREW_PREFIX/opt/linuxdeploy/bin/linuxdeploy --appdir=AppDir \
  -i $OPTDIR/tmux-logo-square.png \
  -d $OPTDIR/tmux.desktop \
  -e $HOMEBREW_PREFIX/opt/tmux@$RELEASE/bin/tmux \
  --custom-apprun=$OPTDIR/AppRun \
  --output=appimage
