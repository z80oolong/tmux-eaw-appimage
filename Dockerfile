## Author: Nelson E Hernandez
## Author: Z.OOL. (NAKATSUKA, Yukitaka) <zool@zool.jpn.org>
## Date:

FROM centos:centos6.9

## install build tools

RUN /usr/bin/yum groupinstall -y "Development Tools"
RUN /usr/bin/yum install -y wget gawk

## setup the environment to build tmux

RUN mkdir -p /usr/local/tmux/archive && mkdir -p /usr/local/tmux/workdir 

ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

## install linuxdeploy

RUN wget -O /usr/local/tmux/archive/linuxdeploy-x86_64.AppImage https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage \
    && echo "fd2b101e59f42d98b53d76d4856993c3cce5bf6f9336da56e2422b575c15f967  /usr/local/tmux/archive/linuxdeploy-x86_64.AppImage" | sha256sum --check -

RUN cd /usr/local \
    && chmod +x /usr/local/tmux/archive/linuxdeploy-x86_64.AppImage \
    && /usr/local/tmux/archive/linuxdeploy-x86_64.AppImage --appimage-extract \
    && cd /usr/local/bin \
    && ln -nfs ../squashfs-root/usr/bin/linuxdeploy ./linuxdeploy

## install m4

RUN wget -O /usr/local/tmux/archive/m4-1.4.18.tar.xz https://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.xz \
    && echo "f2c1e86ca0a404ff281631bdc8377638992744b175afb806e25871a24a934e07  /usr/local/tmux/archive/m4-1.4.18.tar.xz" | sha256sum --check -

RUN cd /usr/local/tmux/workdir \
    && tar -xvf ../archive/m4-1.4.18.tar.xz \
    && cd m4-1.4.18 \
    && mkdir ./build && cd ./build \
    && /usr/bin/env LD_RUN_PATH="" LIBRARY_PATH="" PKG_CONFIG_PATH="" PKG_CONFIG_LIBDIR="" \
                    CFLAGS="-I/usr/local/include" CPPFLAGS="-I/usr/local/include" LDFLAGS="-L/usr/local/lib" \
                    ../configure --prefix=/usr/local --disable-dependency-tracking --disable-silent-rules --disable-debug \
    && make -j5 \
    && make install

## install autoconf

RUN wget -O /usr/local/tmux/archive/autoconf-2.69.tar.gz https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz \
    && echo "954bd69b391edc12d6a4a51a2dd1476543da5c6bbf05a95b59dc0dd6fd4c2969  /usr/local/tmux/archive/autoconf-2.69.tar.gz" | sha256sum --check -

RUN cd /usr/local/tmux/workdir \
    && tar -xvf ../archive/autoconf-2.69.tar.gz \
    && cd autoconf-2.69 \
    && mkdir ./build && cd ./build \
    && /usr/bin/env LD_RUN_PATH="" LIBRARY_PATH="" PKG_CONFIG_PATH="" PKG_CONFIG_LIBDIR="" \
                    CFLAGS="-I/usr/local/include" CPPFLAGS="-I/usr/local/include" LDFLAGS="-L/usr/local/lib" \
                    ../configure --prefix=/usr/local --disable-dependency-tracking --disable-silent-rules --disable-debug \
    && make -j5 \
    && make install

## install automake

RUN wget -O /usr/local/tmux/archive/automake-1.16.1.tar.xz https://ftp.gnu.org/gnu/automake/automake-1.16.1.tar.xz \
    && echo "5d05bb38a23fd3312b10aea93840feec685bdf4a41146e78882848165d3ae921  /usr/local/tmux/archive/automake-1.16.1.tar.xz" | sha256sum --check -

RUN cd /usr/local/tmux/workdir \
    && tar -xvf ../archive/automake-1.16.1.tar.xz \
    && cd automake-1.16.1 \
    && mkdir ./build && cd ./build \
    && /usr/bin/env LD_RUN_PATH="" LIBRARY_PATH="" PKG_CONFIG_PATH="" PKG_CONFIG_LIBDIR="" \
                    CFLAGS="-I/usr/local/include" CPPFLAGS="-I/usr/local/include" LDFLAGS="-L/usr/local/lib" \
                    ../configure --prefix=/usr/local --disable-dependency-tracking --disable-silent-rules --disable-debug \
    && make -j5 \
    && make install

## install libtool

RUN wget -O /usr/local/tmux/archive/libtool-2.4.6.tar.xz https://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.xz \
    && echo "7c87a8c2c8c0fc9cd5019e402bed4292462d00a718a7cd5f11218153bf28b26f  /usr/local/tmux/archive/libtool-2.4.6.tar.xz" | sha256sum --check -

RUN cd /usr/local/tmux/workdir \
    && tar -xvf ../archive/libtool-2.4.6.tar.xz \
    && cd libtool-2.4.6 \
    && mkdir ./build && cd ./build \
    && /usr/bin/env LD_RUN_PATH="" LIBRARY_PATH="" PKG_CONFIG_PATH="" PKG_CONFIG_LIBDIR="" \
                    CFLAGS="-I/usr/local/include" CPPFLAGS="-I/usr/local/include" LDFLAGS="-L/usr/local/lib" \
                    ../configure --prefix=/usr/local --disable-dependency-tracking --disable-silent-rules --disable-debug --enable-ltdl-install \
    && make -j5 \
    && make install

## install pkgconfig

RUN wget -O /usr/local/tmux/archive/pkg-config-0.29.2.tar.gz https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.2.tar.gz \
    && echo "6fc69c01688c9458a57eb9a1664c9aba372ccda420a02bf4429fe610e7e7d591  /usr/local/tmux/archive/pkg-config-0.29.2.tar.gz" | sha256sum --check -

RUN cd /usr/local/tmux/workdir \
    && tar -xvf ../archive/pkg-config-0.29.2.tar.gz \
    && cd pkg-config-0.29.2 \
    && mkdir ./build && cd ./build \
    && /usr/bin/env LD_RUN_PATH="" LIBRARY_PATH="" PKG_CONFIG_PATH="" PKG_CONFIG_LIBDIR="" \
                    CFLAGS="-I/usr/local/include" CPPFLAGS="-I/usr/local/include" LDFLAGS="-L/usr/local/lib" \
                    ../configure --prefix=/usr/local --disable-dependency-tracking --disable-silent-rules --disable-debug --disable-host-tool \
		                 --with-internal-glib --with-pc-path=/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:/usr/lib/pkgconfig:/usr/share/pkgconfig \
    && make -j5 \
    && make install

## install bison

RUN wget -O /usr/local/tmux/archive/bison-3.4.2.tar.xz https://ftp.gnu.org/gnu/bison/bison-3.4.2.tar.xz \
    && echo "27d05534699735dc69e86add5b808d6cb35900ad3fd63fa82e3eb644336abfa0  /usr/local/tmux/archive/bison-3.4.2.tar.xz" | sha256sum --check -

RUN cd /usr/local/tmux/workdir \
    && tar -xvf ../archive/bison-3.4.2.tar.xz \
    && cd bison-3.4.2 \
    && mkdir ./build && cd ./build \
    && /usr/bin/env LD_RUN_PATH="" LIBRARY_PATH="" PKG_CONFIG_PATH="" PKG_CONFIG_LIBDIR="" \
                    CFLAGS="-I/usr/local/include" CPPFLAGS="-I/usr/local/include" LDFLAGS="-L/usr/local/lib" \
                    ../configure --prefix=/usr/local --disable-dependency-tracking --disable-silent-rules --disable-debug \
    && make -j5 \
    && make install

## install libressl

RUN wget -O /usr/local/tmux/archive/libressl-3.0.2.tar.gz https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-3.0.2.tar.gz \
    && echo "df7b172bf79b957dd27ef36dcaa1fb162562c0e8999e194aa8c1a3df2f15398e  /usr/local/tmux/archive/libressl-3.0.2.tar.gz" | sha256sum --check -

RUN cd /usr/local/tmux/workdir \
    && tar -xvf ../archive/libressl-3.0.2.tar.gz \
    && cd libressl-3.0.2 \
    && mkdir ./build && cd ./build \
    && /usr/bin/env LD_RUN_PATH="" LIBRARY_PATH="" PKG_CONFIG_PATH="" PKG_CONFIG_LIBDIR="" \
                    CFLAGS="-I/usr/local/include" CPPFLAGS="-I/usr/local/include" LDFLAGS="-L/usr/local/lib" \
                    ../configure --prefix=/usr/local --disable-dependency-tracking --disable-silent-rules --disable-debug \
    && make -j5 \
    && make install

## install libevent

RUN wget -O /usr/local/tmux/archive/libevent-9a9b92ed.zip https://github.com/libevent/libevent/archive/9a9b92ed06249be8326d82e2483b87e1a1b4caac.zip \
    && echo "5c23997986432e42f12c2b70f1b3200295a2d93082db7768cfbba442bcf0bba8  /usr/local/tmux/archive/libevent-9a9b92ed.zip" | sha256sum --check -

RUN cd /usr/local/tmux/workdir \
    && unzip ../archive/libevent-9a9b92ed.zip \
    && mv libevent-9a9b92ed06249be8326d82e2483b87e1a1b4caac libevent-9a9b92ed \
    && cd libevent-9a9b92ed \
    && sed -i.bak -e 's/^#pragma GCC diagnostic .*$//g' ./sample/watch-timing.c \
    && ./autogen.sh \
    && /usr/bin/env LD_RUN_PATH="" LIBRARY_PATH="" PKG_CONFIG_PATH="" PKG_CONFIG_LIBDIR="" \
                    CFLAGS="-I/usr/local/include" CPPFLAGS="-I/usr/local/include" LDFLAGS="-L/usr/local/lib" \
                    ./configure --prefix=/usr/local --disable-dependency-tracking --disable-silent-rules --disable-debug \
    && make -j5 \
    && make install

## install ncurses

RUN wget -O /usr/local/tmux/archive/ncurses-6.1.tar.gz https://ftpmirror.gnu.org/ncurses/ncurses-6.1.tar.gz \
    && echo "aa057eeeb4a14d470101eff4597d5833dcef5965331be3528c08d99cebaa0d17  /usr/local/tmux/archive/ncurses-6.1.tar.gz" | sha256sum --check -

RUN cd /usr/local/tmux/workdir \
    && tar -xvf ../archive/ncurses-6.1.tar.gz \
    && cd ncurses-6.1 \
    && mkdir ./build && cd ./build \
    && /usr/bin/env LD_RUN_PATH="" LIBRARY_PATH="" PKG_CONFIG_PATH="" PKG_CONFIG_LIBDIR="" \
                    CFLAGS="-I/usr/local/include" CPPFLAGS="-I/usr/local/include" LDFLAGS="-L/usr/local/lib" \
                    ../configure --prefix=/usr/local --datarootdir=/usr/local/share \
		                 --with-terminfo-dirs="/usr/local/share/terminfo:/usr/local/lib/terminfo:/usr/share/terminfo:/usr/lib/terminfo:/lib/terminfo" \
		                 --disable-dependency-tracking --disable-silent-rules --disable-debug \
		                 --enable-pc-files --enable-sigwinch --enable-symlinks --enable-widec --with-shared --with-gpm=no \
    && make -j5 \
    && make install \
    && cd /usr/local/lib \
    && ln -sf libformw.so.6 libform.so.6 && ln -sf libformw.so.6 libform.so \
    && ln -sf libmenuw.so.6 libmenu.so.6 && ln -sf libmenuw.so.6 libmenu.so \
    && ln -sf libncursesw.so.6 libncurses.so.6 && ln -sf libncursesw.so.6 libncurses.so \
    && ln -sf libpanelw.so.6 libpanel.so.6 && ln -sf libpanelw.so.6 libpanel.so \
    && ln -sf libformw.a libform.a && ln -sf libformw_g.a libform_g.a \
    && ln -sf libmenuw.a libmenu.a && ln -sf libmenuw_g.a libmenu_g.a \
    && ln -sf libncursesw.a libncurses.a && ln -sf libncursesw_g.a libncurses_g.a \
    && ln -sf libpanelw.a libpanel.a && ln -sf libpanelw_g.a libpanel_g.a \
    && ln -sf libncurses++w.a libncurses++.a && ln -sf libncurses.a libcurses.a \
    && ln -sf libncurses.so libcurses.so && ln -sf libncurses.so libtermcap.so \
    && ln -sf libncurses.so libtinfo.so \
    && cd /usr/local/bin \
    && ln -sf ncursesw6-config ncurses6-config \
    && cd /usr/local/include \
    && ln -sf ncursesw/curses.h curses.h && ln -sf ncursesw/form.h form.h \
    && ln -sf ncursesw/ncurses.h ncurses.h && ln -sf ncursesw/panel.h panel.h \
    && ln -sf ncursesw/term.h term.h && ln -sf ncursesw/termcap.h termcap.h

## download the source code of tmux-$VERSION

ARG VERSION=3.0a
ENV RELEASE_TAG=$VERSION

RUN case "$RELEASE_TAG" in \
      3.1-rc3) wget -O /usr/local/tmux/archive/tmux-$RELEASE_TAG.tar.gz https://github.com/tmux/tmux/releases/download/3.1/tmux-$RELEASE_TAG.tar.gz ;; \
      HEAD)    true ;; \
      *)       wget -O /usr/local/tmux/archive/tmux-$RELEASE_TAG.tar.gz https://github.com/tmux/tmux/releases/download/$RELEASE_TAG/tmux-$RELEASE_TAG.tar.gz ;; \
    esac \
    && case "$RELEASE_TAG" in \
         2.3)     echo "55313e132f0f42de7e020bf6323a1939ee02ab79c48634aa07475db41573852b  /usr/local/tmux/archive/tmux-2.3.tar.gz"     | sha256sum --check - ;; \
         2.4)     echo "757d6b13231d0d9dd48404968fc114ac09e005d475705ad0cd4b7166f799b349  /usr/local/tmux/archive/tmux-2.4.tar.gz"     | sha256sum --check - ;; \
         2.5)     echo "ae135ec37c1bf6b7750a84e3a35e93d91033a806943e034521c8af51b12d95df  /usr/local/tmux/archive/tmux-2.5.tar.gz"     | sha256sum --check - ;; \
         2.6)     echo "b17cd170a94d7b58c0698752e1f4f263ab6dc47425230df7e53a6435cc7cd7e8  /usr/local/tmux/archive/tmux-2.6.tar.gz"     | sha256sum --check - ;; \
         2.7)     echo "9ded7d100313f6bc5a87404a4048b3745d61f2332f99ec1400a7c4ed9485d452  /usr/local/tmux/archive/tmux-2.7.tar.gz"     | sha256sum --check - ;; \
         2.8)     echo "7f6bf335634fafecff878d78de389562ea7f73a7367f268b66d37ea13617a2ba  /usr/local/tmux/archive/tmux-2.8.tar.gz"     | sha256sum --check - ;; \
         2.9)     echo "34901232f486fd99f3a39e864575e658b5d49f43289ccc6ee57c365f2e2c2980  /usr/local/tmux/archive/tmux-2.9.tar.gz"     | sha256sum --check - ;; \ 
         2.9a)    echo "839d167a4517a6bffa6b6074e89a9a8630547b2dea2086f1fad15af12ab23b25  /usr/local/tmux/archive/tmux-2.9a.tar.gz"    | sha256sum --check - ;; \
         3.0)     echo "9edcd78df80962ee2e6471a8f647602be5ded62bb41c574172bb3dc3d0b9b4b4  /usr/local/tmux/archive/tmux-3.0.tar.gz"     | sha256sum --check - ;; \
         3.0a)    echo "4ad1df28b4afa969e59c08061b45082fdc49ff512f30fc8e43217d7b0e5f8db9  /usr/local/tmux/archive/tmux-3.0a.tar.gz"    | sha256sum --check - ;; \
	 3.1-rc3) echo "882025b6b2b0da67b429825851ff10925046e692ef96c5bf1db459b3610b96b1  /usr/local/tmux/archive/tmux-3.1-rc3.tar.gz" | sha256sum --check - ;; \
	 HEAD)    true  ;; \
	 *)       false ;; \
       esac

RUN case "$RELEASE_TAG" in \
      HEAD) wget -O /usr/local/tmux/archive/tmux-HEAD-5b71943f-fix.diff https://raw.githubusercontent.com/z80oolong/tmux-eaw-fix/master/tmux-HEAD-5b71943f-fix.diff ;; \
      *)    wget -O /usr/local/tmux/archive/tmux-$RELEASE_TAG-fix.diff  https://raw.githubusercontent.com/z80oolong/tmux-eaw-fix/master/tmux-$RELEASE_TAG-fix.diff  ;; \
    esac \
    && case "$RELEASE_TAG" in \
         2.3)     echo "1e2a5dae47fd72c4daf4a398c0c7735cbfa4a607bf83b1ae96c9cef92310a6a9  /usr/local/tmux/archive/tmux-2.3-fix.diff"           | sha256sum --check - ;; \
         2.4)     echo "f38f3042385bf464eb52a72e2d71897fd101098bb5ccabd725fad8a35f75dc20  /usr/local/tmux/archive/tmux-2.4-fix.diff"           | sha256sum --check - ;; \
         2.5)     echo "f34a7c1e59ed0b58990ddcc878e192c3e8ad86dbb2046d723ba5a324fe0d8063  /usr/local/tmux/archive/tmux-2.5-fix.diff"           | sha256sum --check - ;; \
         2.6)     echo "04266939b43cad4f08136890103ea073e8f9f0c494080b9a5a612b26f0bdf0d9  /usr/local/tmux/archive/tmux-2.6-fix.diff"           | sha256sum --check - ;; \
         2.7)     echo "c16bb71d87c9d320676beb7bca9a1b4d69a14d3b747b3b2106f2dfa67e94dc12  /usr/local/tmux/archive/tmux-2.7-fix.diff"           | sha256sum --check - ;; \
         2.8)     echo "23256a8df82b80d598c3bb1090f839de9195f2027613bdf11fb63b3bcbba9f76  /usr/local/tmux/archive/tmux-2.8-fix.diff"           | sha256sum --check - ;; \
         2.9)     echo "148bbe3a4f86dcd9c4528f4e898a2def93c50cef3c12f512c69ef27473f45187  /usr/local/tmux/archive/tmux-2.9-fix.diff"           | sha256sum --check - ;; \
         2.9a)    echo "148bbe3a4f86dcd9c4528f4e898a2def93c50cef3c12f512c69ef27473f45187  /usr/local/tmux/archive/tmux-2.9a-fix.diff"          | sha256sum --check - ;; \
         3.0)     echo "b5e994fc07d96b6bafcaa2dd984274662bd73f7cb4a916a4048ac0757bf7c97e  /usr/local/tmux/archive/tmux-3.0-fix.diff"           | sha256sum --check - ;; \
         3.0a)    echo "d223ddc4d7621416ae0f8ac874155bc963a16365ada9598eff74129141ad7948  /usr/local/tmux/archive/tmux-3.0a-fix.diff"          | sha256sum --check - ;; \
         3.1-rc3) echo "f9efcbdcd7048b549141ca06be435dbc142d99fefc06464995aea650f778d480  /usr/local/tmux/archive/tmux-3.1-rc3-fix.diff"       | sha256sum --check - ;; \
         HEAD)    echo "25727b55d7e96ce3de2c43ca7468443556dd52484812838b9b75bc1a2cab79ea  /usr/local/tmux/archive/tmux-HEAD-5b71943f-fix.diff" | sha256sum --check - ;; \
         *)       false ;; \
       esac

## build tmux-$RELEASE_TAG

RUN cd /usr/local/tmux/workdir \
    && case "$RELEASE_TAG" in \
         HEAD) git clone https://github.com/tmux/tmux.git tmux-$RELEASE_TAG ;; \
         *)    tar -xvf ../archive/tmux-$RELEASE_TAG.tar.gz ;; \
       esac \
    && cd tmux-$RELEASE_TAG \
    && case "$RELEASE_TAG" in \
         HEAD) patch -p1 < /usr/local/tmux/archive/tmux-HEAD-5b71943f-fix.diff ;; \
         *)    patch -p1 < /usr/local/tmux/archive/tmux-$RELEASE_TAG-fix.diff  ;; \
       esac \
    && if [ "$RELEASE_TAG" = "HEAD" ]; then ./autogen.sh; fi \
    && /usr/bin/env LD_RUN_PATH="" LIBRARY_PATH="" PKG_CONFIG_PATH="" PKG_CONFIG_LIBDIR="" \
                    CFLAGS="-I/usr/local/include" CPPFLAGS="-I/usr/local/include" LDFLAGS="-L/usr/local/lib" \ 
                    ./configure --prefix=/usr/local --disable-dependency-tracking --disable-silent-rules --disable-debug \
    && make -j5 \
    && make install

## build tmux-eaw-$RELEASE_TAG-x86_64.ApppImage

CMD /opt/build.sh
