#!/bin/bash

export RELEASE="3.1b"
export HEAD_COMMIT="98aa8350"
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
        release=*)
          export RELEASE=$(echo ${OPTARG} | sed -e 's/release=\(.*\)/\1/g')
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
    r)
      export RELEASE="${OPTARG}"
      ;;
    u)
      export UPDATE="yes"
      ;;
    esac
done

if [ "$RELEASE" = "HEAD" ]; then
  export RELEASE="HEAD-$HEAD_COMMIT"
fi

if [ "$UPDATE" = "yes" ]; then
  date +"%Y%m%d%H%M%S" > ./opt/BREW_UPDATE_TIME
fi

mkdir -p ./opt/releases

docker build . -t tmux --build-arg TMUX_RELEASE=$RELEASE && \
docker create -ti --name tmuxcontainer tmux /bin/bash && \
docker cp tmuxcontainer:/home/linuxbrew/opt/releases/tmux-eaw-$RELEASE-x86_64.AppImage ./opt/releases && \
docker rm -f tmuxcontainer
