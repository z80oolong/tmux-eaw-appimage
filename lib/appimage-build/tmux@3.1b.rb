class TmuxAT31b
  # For brew appimage-build
  def apprun; <<~EOS
    #!/bin/sh
    #export APPDIR="/tmp/.mount-tmuxXXXXXX"
    if [ "x${APPDIR}" = "x" ]; then
      export APPDIR="$(dirname "$(readlink -f "${0}")")"
    fi
    export PATH="${APPDIR}/usr/bin/:${PATH:+:$PATH}"
    export LD_LIBRARY_PATH="${APPDIR}/usr/lib/:${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    export XDG_DATA_DIRS="${APPDIR}/usr/share/${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
    export TERMINFO="${APPDIR}/usr/share/terminfo"
    unset ARGV0

    exec "tmux" "$@"
    EOS
  end

  def exec_path_list
    return [opt_bin/"tmux"]
  end

  def pre_build_appimage(appdirpath, verbose)
    system("cp -pRv #{Formula["z80oolong/tmux/tmux-ncurses@6.2"].opt_share}/terminfo #{appdirpath}/usr/share")
  end
end
