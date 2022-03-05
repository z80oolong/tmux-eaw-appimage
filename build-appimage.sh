#!/bin/sh
vagrant up --provision 2>&1 | tee build-appimage-tmux.log
vagrant halt
