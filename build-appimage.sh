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
	export RELEASE="3.0a"
fi

sudo docker build . -t tmux --build-arg VERSION=$RELEASE && sudo -v && sudo docker run -it -v $PWD/opt:/opt tmux
