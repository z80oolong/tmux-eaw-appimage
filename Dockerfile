## Author: Z.OOL. (NAKATSUKA, Yukitaka) <zool@zool.jpn.org>

FROM z80oolong/debian-linuxbrew-container:latest
MAINTAINER Z.OOL. (NAKATSUKA, Yukitaka) <zool@zool.jpn.org>

USER linuxbrew
WORKDIR /home/linuxbrew

## install autoconf, automake, libtool, etc.

## brew tap z80oolong/tmux

RUN brew tap z80oolong/tmux

## brew update && brew upgrade

COPY ./opt/BREW_UPDATE_TIME /home/linuxbrew/opt/
RUN brew update
RUN brew upgrade

RUN brew unlink git

## install z80oolong/tmux/tmux@$RELEASE_TAG dependencies.

RUN brew install -s z80oolong/tmux/tmux-libevent@2.2
RUN brew install -s z80oolong/tmux/tmux-ncurses@6.2

## install  z80oolong/tmux/tmux@$RELEASE_TAG

RUN brew install -s z80oolong/tmux/tmux@2.6
RUN brew install -s z80oolong/tmux/tmux@2.7
RUN brew install -s z80oolong/tmux/tmux@2.8
RUN brew install -s z80oolong/tmux/tmux@2.9
RUN brew install -s z80oolong/tmux/tmux@2.9a
RUN brew install -s z80oolong/tmux/tmux@3.0
RUN brew install -s z80oolong/tmux/tmux@3.0a
RUN brew install -s z80oolong/tmux/tmux@3.1
RUN brew install -s z80oolong/tmux/tmux@3.1a
RUN brew install -s z80oolong/tmux/tmux@3.1b
RUN brew install -s z80oolong/tmux/tmux@3.2

COPY ./opt/tmux@3.3-next.rb /home/linuxbrew/opt/
RUN brew install -s /home/linuxbrew/opt/tmux@3.3-next.rb --HEAD

## build tmux-eaw-$RELEASE_TAG-x86_64.ApppImage

ARG TMUX_RELEASE=3.1b
ENV RELEASE_TAG=$TMUX_RELEASE

COPY ./opt/AppRun ./opt/build.sh ./opt/tmux-logo-square.png ./opt/tmux.desktop /home/linuxbrew/opt/
RUN /home/linuxbrew/opt/build.sh

## Produces artifact
## /opt/releases/tmux-eaw-$RELEASE_TAG-x86_64.AppImage

CMD /home/linuxbrew/opt/build.sh
