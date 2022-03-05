Vagrant.configure("2") do |config|
  tmux_versions = TmuxM::stable_version_list + TmuxM::devel_version_list
  tmuxs = (tmux_versions.map {|v| "z80oolong/tmux/tmux@#{v}" }).join(" ")

  config.vm.provision "shell", privileged: false, inline: %[
    if [ ! -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
      sudo apt-get update && \
      sudo apt-get -y upgrade && \
      sudo apt-get -y install build-essential ruby && \
      env NONINTERACTIVE=1 \
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
      echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.profile && \
      echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.bashrc  && \
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && \
      brew install gcc && \
      brew tap z80oolong/appimage && \
      brew tap z80oolong/tmux && \
      brew install --only-dependencies #{tmuxs} && \
      brew install --only-dependencies --formula #{TmuxM::lib_dir}/tmux@#{TmuxM::head_version}.rb
    fi
  ]
end
