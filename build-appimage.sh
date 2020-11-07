#!/bin/bash

export DOCKER="/usr/bin/docker"
#export DOCKER="/usr/bin/podman"
export APPIMAGE_VERSION='v3.1c-eaw-appimage-0.1.0'
export STABLE_RELEASE='3.1c'
export RELEASE=$STABLE_RELEASE
export HEAD_COMMIT=`/usr/bin/env ruby ./opt/tmux@3.3-next.rb`
export UPDATE="no"
export TIME=`date +'%Y%m%d%H%M%S'`

while getopts "vhur:-:" opt; do
  case "$opt" in
    -)
      case "${OPTARG}" in
        help)
          echo "Usage: $0 [-hv] [-r RELEASE] [--help|--version|--release RELEASE]"
          exit 0
          ;;
        version)
          echo "$0 version 0.0.1"
          exit 0
          ;;
        update)
          export UPDATE="yes"
          ;;
      esac
      ;;
    h)
      echo "Usage: $0 [-hvu] [-r RELEASE] [--help|--version|--update|--release=RELEASE]"
      exit 0
      ;;
    v)
      echo "$0 version 0.0.1"
      exit 0
      ;;
    u)
      export UPDATE="yes"
      ;;
    esac
done

if [ "$UPDATE" = "yes" ]; then
  date +"%Y%m%d%H%M%S" > ./opt/BREW_UPDATE_TIME
fi

mkdir -p ./opt/releases
mkdir -p ./opt/formula

for RELEASE in 2.6 2.7 2.8 2.9 2.9a 3.0 3.0a 3.1 3.1a 3.1b 3.1c 3.2-rc3 HEAD-$HEAD_COMMIT; do
  ${DOCKER} build . -t tmux --build-arg TMUX_RELEASE=$RELEASE && \
  ${DOCKER} create -ti --name tmuxcontainer tmux /bin/bash && \
  ${DOCKER} cp tmuxcontainer:/home/linuxbrew/opt/releases/tmux-eaw-$RELEASE-x86_64.AppImage ./opt/releases && \
  ${DOCKER} rm -f tmuxcontainer
done

for RELEASE in 2.6 2.7 2.8 2.9 2.9a 3.0 3.0a 3.1 3.1a 3.1b 3.1c 3.2-rc3; do
  cat ./opt/appimage-tmux@templete.rb | \
      sed -e "s/%%TMUX_VERSION%%/$RELEASE/g" \
          -e "s/%%APPIMAGE_VERSION%%/$APPIMAGE_VERSION/g" \
	  -e "s/%%TMUX_VERSION_CLASS%%/`echo $RELEASE | sed -e 's/\([0-9]*\)\.\([0-9]*[a-z]*\).*/\1\2/g'`/g" \
	  -e "s/%%SHA256_TMUX_STABLE%%/`sha256sum ./opt/releases/tmux-eaw-$RELEASE-x86_64.AppImage | sed -e 's/\([0-9a-f]*\).*/\1/g'`/g" \
	  > ./opt/formula/appimage-tmux@${RELEASE/-rc*/}.rb
done

cat ./opt/appimage-tmux-templete.rb | \
    sed -e "s/%%TMUX_VERSION%%/$STABLE_RELEASE/g" \
        -e "s/%%APPIMAGE_VERSION%%/$APPIMAGE_VERSION/g" \
	-e "s/%%TMUX_COMMIT%%/$HEAD_COMMIT/g" \
	-e "s/%%SHA256_TMUX_STABLE%%/`sha256sum ./opt/releases/tmux-eaw-3.1c-x86_64.AppImage | sed -e 's/\([0-9a-f]*\).*/\1/g'`/g" \
	-e "s/%%SHA256_TMUX_HEAD%%/`sha256sum ./opt/releases/tmux-eaw-HEAD-$HEAD_COMMIT-x86_64.AppImage | sed -e 's/\([0-9a-f]*\).*/\1/g'`/g" \
	> ./opt/formula/appimage-tmux.rb
