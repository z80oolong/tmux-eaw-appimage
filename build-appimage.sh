#!/bin/bash

export RELEASE="3.1b"
export HEAD_COMMIT="a5f99e14"
export UPDATE="no"

while getopts ":vhur-:" opt; do
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
        release)
          shift 1
          export RELEASE=$1
          ;;
      esac
      ;;
    h)
      echo "Usage: $0 [-hvu] [-r RELEASE] [--help|--version|--update|--release RELEASE]"
      exit 0
      ;;
    v)
      echo "$0 version 0.0.1"
      exit 0
      ;;
    r)
      shift 1
      export RELEASE=$1
      ;;
    esac
done

if [ "$RELEASE" = "HEAD" ]; then
  export RELEASE="HEAD-$HEAD_COMMIT"
fi

mkdir -p ./opt/releases

docker build . -t tmux --build-arg TMUX_RELEASE=$RELEASE --build-arg BREW_UPDATE=`date +'%Y%m%d'` && \
docker create -ti --name tmuxcontainer tmux /bin/bash && \
docker cp tmuxcontainer:/opt/releases/tmux-eaw-$RELEASE-x86_64.AppImage ./opt/releases && \
docker rm -f tmuxcontainer
