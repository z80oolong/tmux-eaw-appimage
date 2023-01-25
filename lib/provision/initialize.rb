Vagrant.configure("2") do |config|
  config.vm.provision "shell", privileged: false, inline: %[
    if [ ! -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
      sudo apt-get update && \
      sudo apt-get -y upgrade && \
      sudo apt-get -y install build-essential ruby curl git && \
      env NONINTERACTIVE=1 \
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
      echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.profile && \
      echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.bashrc  && \
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && \
      brew install gcc && \
      brew tap #{Config::appimage_tap_name} && \
      brew tap #{Config::current_tap_name} && \
      brew install --only-dependencies #{Config::all_stable_formulae.join(" ")} && \
      brew install --only-dependencies --formula #{Config::current_head_formula}
    fi
  ]
end
