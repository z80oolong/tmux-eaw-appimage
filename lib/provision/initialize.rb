Vagrant.configure("2") do |config|
  formula_versions = Config::stable_version_list + Config::devel_version_list
  formulae = (formula_versions.map {|v| "#{Config::formula_fullname}@#{v}" }).join(" ")

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
      brew tap #{Config::formula_tap} && \
      brew install --only-dependencies #{formulae} && \
      brew install --only-dependencies --formula #{Config::lib_dir}/#{Config::formula_name}@#{Config::head_version}.rb
    fi
  ]
end
