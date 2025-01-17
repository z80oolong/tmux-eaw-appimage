class TmuxBuilder < AppImage::Builder
  # For brew appimage-build
  def apprun; <<~EOS
    #!/bin/sh
    #export APPDIR="/tmp/.mount-tmuxXXXXXX"
    if [ "x${APPDIR}" = "x" ]; then
      export APPDIR="$(dirname "$(readlink -f "${0}")")"
    fi

    if [ "x${HOMEBREW_PREFIX}" = "x" ]; then
      export TMUX_CONF='$APPDIR/etc/tmux.conf:~/.tmux.conf:$XDG_CONFIG_HOME/tmux/tmux.conf:~/.config/tmux/tmux.conf'
      export PATH="${APPDIR}/usr/bin/:${HOMEBREW_PREFIX}/bin/:${PATH:+:$PATH}"
      export XDG_DATA_DIRS="${APPDIR}/usr/share/:${HOMEBREW_PREFIX}/share/:${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
      export LOCPATH="${HOMEBREW_PREFIX}/opt/glibc/lib/locale:${HOME}/.local/lib/locale:/usr/lib/locale:${APPDIR}/usr/lib/locale"
    else
      export TMUX_CONF='$APPDIR/etc/tmux.conf:$HOMEBREW_PREFIX/etc/tmux.conf:~/.tmux.conf:$XDG_CONFIG_HOME/tmux/tmux.conf:~/.config/tmux/tmux.conf'
      export PATH="${APPDIR}/usr/bin/:${PATH:+:$PATH}"
      export XDG_DATA_DIRS="${APPDIR}/usr/share/:${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
      export LOCPATH="${HOME}/.local/lib/locale:/usr/lib/locale:${APPDIR}/usr/lib/locale"
    fi

    export TERMINFO="${APPDIR}/usr/share/terminfo"
    unset ARGV0

    TMUX="${APPDIR}/usr/bin/tmux"
    LDSO="${APPDIR}/usr/bin/ld.so"

    if [ -x "${LDSO}" ]; then
      exec "${LDSO}" "${TMUX}" "$@"
    else
      exec "${TMUX}" "$@"
    fi
    EOS
  end

  def tmux_conf; <<~EOS
    ### ${APPDIR}/etc/tmux.conf
    ###
    #set-environment -g NCURSES_NO_UTF8_ACS 0
    #set-option -g prefix C-b
    #
    #bind z   send-prefix
    #bind C-z send-prefix
    #bind C-c new-window
    #bind C-0 select-window -t :0
    #bind C-1 select-window -t :1
    #bind C-2 select-window -t :2
    #bind C-3 select-window -t :3
    #bind C-4 select-window -t :4
    #bind C-5 select-window -t :5
    #bind C-6 select-window -t :6
    #bind C-7 select-window -t :7
    #bind C-8 select-window -t :8
    #bind C-9 select-window -t :9
    #bind C-n next-window
    #bind C-o select-pane -t :.+
    #bind C-p previous-window
    #
    #bind | split-window -h
    #bind - split-window -v
    #
    #set-window-option -g mode-keys emacs
    #set -g base-index 1
    #set -g pane-base-index 1
    #set -g pane-border-ascii on
    #set -g utf8-cjk on
    #
    #set -g status on
    #set -g status-left "#[bg=green, fg=black] [#S]#[default]"
    #set -g status-right "#(date +'%Y/%m/%d %H:%M')"
    #set -g default-terminal "screen-256color"
    EOS
  end

  def exec_path_list
    return [opt_bin/"tmux"]
  end

  def pre_build_appimage(appdir, verbose)
    (appdir/"etc").mkpath
    ohai "Install #{appdir}/etc/tmux.conf" if verbose
    (appdir/"etc/tmux.conf").write(tmux_conf)
    system("mkdir -p #{appdir.lib}/locale")
    system("#{Formula["glibc"].opt_bin}/localedef -i en_US -f UTF-8 #{appdir.lib}/locale/en_US")
    system("#{Formula["glibc"].opt_bin}/localedef -i en_US -f UTF-8 #{appdir.lib}/locale/en_US.utf8")
    system("#{Formula["glibc"].opt_bin}/localedef -i ja_JP -f UTF-8 #{appdir.lib}/locale/ja_JP")
    system("#{Formula["glibc"].opt_bin}/localedef -i ja_JP -f UTF-8 #{appdir.lib}/locale/ja_JP.utf8")
    system("cp -pRv #{Formula["z80oolong/tmux/tmux-ncurses@6.2"].opt_share}/terminfo #{appdir.share}")
  end
end
