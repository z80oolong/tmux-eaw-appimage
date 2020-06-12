#!/bin/bash

while getopts ":vhr-:" opt; do
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
      echo "Usage: $0 [-hv] [-r RELEASE] [--help|--version|--release RELEASE]"
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

if [ "x$RELEASE" = "x" ]; then
  export RELEASE="3.1b"
fi

export HEAD_COMMIT="208d9449"

mkdir -p ./opt/releases

docker build . -t tmux --build-arg VERSION=$RELEASE && \
docker create -ti --name tmuxcontainer tmux /bin/bash && \
if [ "$RELEASE" = "HEAD" ]; then \
  export RELEASE="HEAD-$HEAD_COMMIT"; \
fi && \
docker cp tmuxcontainer:/opt/releases/tmux-eaw-$RELEASE-x86_64.AppImage ./opt/releases && \
docker rm -f tmuxcontainer
