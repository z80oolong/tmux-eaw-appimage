## Author: Nelson E Hernandez
## Author: Z.OOL. (NAKATSUKA, Yukitaka) <zool@zool.jpn.org>
## Date:

FROM debian:jessie
MAINTAINER Z.OOL. (NAKATSUKA, Yukitaka) <zool@zool.jpn.org>

## setup Debian Jessie environment.

ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ENV DEBIAN_FRONTEND=noninterractive

RUN /usr/bin/env LANG=C apt-get update && /usr/bin/env LANG=C apt-get upgrade -y --no-install-recommends

RUN apt-get install -y --no-install-recommends apt-utils locales \
    && echo "en_US.UTF-8 UTF-8" >  /etc/locale.gen \
    && echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen \
    && /usr/sbin/locale-gen \
    && update-locale LANG=ja_JP.UTF-8

## install package required by Linuxbrew.

RUN apt-get install -y --no-install-recommends build-essential coreutils curl wget file git sudo ca-certificates

## clean /var/cache/apt/archives/* and /var/lib/apt/lists/*

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

## install linuxdeploy

RUN cd /usr/local/src \
    && wget -O ./linuxdeploy-x86_64.AppImage https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage \
    && echo "99202da2806cc3e522793fbc447b33ce5599440dc22c1ec6db4dba3e4ee1e3aa  ./linuxdeploy-x86_64.AppImage" | sha256sum --check -

RUN cd /usr/local \
    && chmod +x ./src/linuxdeploy-x86_64.AppImage \
    && ./src/linuxdeploy-x86_64.AppImage --appimage-extract \
    && cd /usr/local/bin \
    && ln -nfs ../squashfs-root/usr/bin/linuxdeploy ./linuxdeploy

## create user "linuxbrew".

RUN localedef -i en_US -f UTF-8 en_US.UTF-8 && useradd -m -s /bin/bash linuxbrew \
    && echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers

## install Linuxbrew environment.

USER linuxbrew
WORKDIR /home/linuxbrew

RUN echo "" | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

ENV SHELL=/bin/bash
ENV USER=linuxbrew

ENV HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
ENV HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
ENV HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX/Homebrew"
ENV PATH="$HOMEBREW_PREFIX/sbin:$HOMEBREW_PREFIX/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ENV MANPATH="$HOMEBREW_PREFIX/share/man"
ENV INFOPATH="$HOMEBREW_PREFIX/share/info"

ENV HOMEBREW_NO_ANALYTICS=1
ENV HOMEBREW_NO_AUTO_UPDATE=1
ENV HOMEBREW_MAKE_JOBS=6

## install autoconf, automake, libtool, etc.

RUN brew install patchelf m4 gdbm libbsd berkeley-db expat
RUN brew install -s perl
RUN brew install autoconf automake libtool pkg-config bison
RUN brew install bzip2 unzip gpatch

## brew tap z80oolong/tmux and install z80oolong/tmux/tmux@$RELEASE_TAG dependencies.

RUN brew tap z80oolong/tmux
RUN brew install -s z80oolong/tmux/tmux-libevent@2.2 z80oolong/tmux/tmux-ncurses@6.2

## brew update && brew upgrade

ARG BREW_UPDATE=no
RUN [ "x$BREW_UPDATE" != "xno" ] && brew update && brew upgrade || true

## brew install z80oolong/tmux/tmux@RELEASE_TAG

ARG TMUX_RELEASE=3.1b
ENV RELEASE_TAG=$TMUX_RELEASE

#COPY ./opt/tmux@3.2-dev.rb $HOMEBREW_PREFIX/Homebrew/Library/Taps/z80oolong/homebrew-tmux/Formula/
COPY ./opt/tmux@3.3-next.rb /home/linuxbrew/

RUN case "$RELEASE_TAG" in \
      HEAD-*) brew install -s --HEAD /home/linuxbrew/tmux@3.3-next.rb && brew link --force tmux@3.3-next ;; \
      3.2-rc) brew install -s z80oolong/tmux/tmux@3.2                 && brew link --force z80oolong/tmux/tmux@3.2     ;; \
      *)      brew install -s z80oolong/tmux/tmux@$RELEASE_TAG        && brew link --force z80oolong/tmux/tmux@$RELEASE_TAG ;; \
    esac

## build tmux-eaw-$RELEASE_TAG-x86_64.ApppImage

USER root

COPY ./opt/AppRun ./opt/build.sh ./opt/tmux-logo-square.png ./opt/tmux.desktop /opt/
RUN /opt/build.sh

## Produces artifact
## /opt/releases/tmux-eaw-$RELEASE_TAG-x86_64.AppImage

CMD /opt/build.sh
