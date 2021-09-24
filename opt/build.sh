#!/bin/bash

export OPTDIR="/home/linuxbrew/opt"
export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"

mkdir $OPTDIR/releases
mkdir -p $OPTDIR/AppDir/usr/lib

case "$RELEASE_TAG" in
  HEAD-*)  RELEASE="3.4-next"      ;;
  3.3-rc*) RELEASE="3.3"      ;;
  *)       RELEASE="$RELEASE_TAG" ;;
esac

chmod +x $OPTDIR/AppRun
cp -pRv $HOMEBREW_PREFIX/opt/tmux-ncurses@6.2/share/terminfo $OPTDIR/AppDir/usr/lib

export LD_LIBRARY_PATH="$HOMEBREW_PREFIX/opt/tmux-ncurses@6.2/lib:$HOMEBREW_PREFIX/opt/tmux-libevent@2.2/lib:$HOMEBREW_PREFIX/lib:$LD_LIBRARY_PATH"

/usr/bin/sudo /usr/bin/env OUTPUT="$OPTDIR/releases/tmux-eaw-$RELEASE_TAG-x86_64.AppImage" \
  $HOMEBREW_PREFIX/opt/linuxdeploy/bin/linuxdeploy --appdir=$OPTDIR/AppDir \
  -i $OPTDIR/tmux-logo-square.png \
  -d $OPTDIR/tmux.desktop \
  -e $HOMEBREW_PREFIX/opt/tmux@$RELEASE/bin/tmux \
  --custom-apprun=$OPTDIR/AppRun \
  --output=appimage
