#!/bin/bash

export DOCKER="/usr/bin/docker"
#export DOCKER="/usr/bin/podman"
export APPIMAGE_VERSION=`/usr/bin/env ruby ./opt/tmux@3.4-next.rb appimage_version`
export STABLE_RELEASE=`/usr/bin/env ruby ./opt/tmux@3.4-next.rb stable_version`
export DEVEL_RELEASE=`/usr/bin/env ruby ./opt/tmux@3.4-next.rb devel_version`
export STABLE_RELEASE_LIST=`/usr/bin/env ruby ./opt/tmux@3.4-next.rb stable_version_list`
export TMUX_REVISION=`/usr/bin/env ruby ./opt/tmux@3.4-next.rb appimage_revision`
export RELEASE=$STABLE_RELEASE
export HEAD_COMMIT=`/usr/bin/env ruby ./opt/tmux@3.4-next.rb commit`
export UPDATE="no"
export TIME=`date +'%Y%m%d%H%M%S'`

while getopts "vhur:-:" opt; do
  case "$opt" in
    -)
      case "${OPTARG}" in
        help)
          echo "Usage: $0 [-hvu] [--help|--version|--update]"
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
      echo "Usage: $0 [-hvu] [--help|--version|--update]"
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

for RELEASE in $STABLE_RELEASE_LIST $DEVEL_RELEASE HEAD-$HEAD_COMMIT; do
   echo $RELEASE
   ${DOCKER} build . -t tmux --build-arg TMUX_RELEASE=$RELEASE && \
   ${DOCKER} create -ti --name tmuxcontainer tmux /bin/bash && \
   ${DOCKER} cp tmuxcontainer:/home/linuxbrew/opt/releases/tmux-eaw-$RELEASE-x86_64.AppImage ./opt/releases && \
   ${DOCKER} rm -f tmuxcontainer
done

for RELEASE in $STABLE_RELEASE_LIST $DEVEL_RELEASE; do
  cat ./opt/appimage-tmux@templete.rb | \
      sed -e "s/%%TMUX_VERSION%%/$RELEASE/g" -e "s/%%TMUX_REVISION%%/$TMUX_REVISION/g" \
          -e "s/%%APPIMAGE_VERSION%%/$APPIMAGE_VERSION/g" \
	  -e "s/%%TMUX_VERSION_CLASS%%/`echo $RELEASE | sed -e 's/\([0-9]*\)\.\([0-9]*[a-z]*\).*/\1\2/g'`/g" \
	  -e "s/%%SHA256_TMUX_STABLE%%/`sha256sum ./opt/releases/tmux-eaw-$RELEASE-x86_64.AppImage | sed -e 's/\([0-9a-f]*\).*/\1/g'`/g" \
	  > ./opt/formula/appimage-tmux@${RELEASE/-rc*/}.rb
done

cat ./opt/appimage-tmux-templete.rb | \
    sed -e "s/%%TMUX_VERSION%%/$STABLE_RELEASE/g" -e "s/%%TMUX_REVISION%%/$TMUX_REVISION/g" \
        -e "s/%%APPIMAGE_VERSION%%/$APPIMAGE_VERSION/g" \
	-e "s/%%TMUX_COMMIT%%/$HEAD_COMMIT/g" \
	-e "s/%%SHA256_TMUX_STABLE%%/`sha256sum ./opt/releases/tmux-eaw-$STABLE_RELEASE-x86_64.AppImage | sed -e 's/\([0-9a-f]*\).*/\1/g'`/g" \
	-e "s/%%SHA256_TMUX_HEAD%%/`sha256sum ./opt/releases/tmux-eaw-HEAD-$HEAD_COMMIT-x86_64.AppImage | sed -e 's/\([0-9a-f]*\).*/\1/g'`/g" \
	> ./opt/formula/appimage-tmux.rb
