Vagrant.configure("2") do |config|
  tmux_versions = TmuxM::stable_version_list + TmuxM::devel_version_list

  config.vm.provision "shell", privileged: true, inline: "sudo apt-get update"
  config.vm.provision "shell", privileged: true, inline: "sudo apt-get -y upgrade"

  config.vm.provision "shell", privileged: false, inline: "brew remove --force tmux@#{TmuxM::head_version}"
  config.vm.provision "shell", privileged: false, inline: "brew doctor"
  config.vm.provision "shell", privileged: false, inline: "brew update"
  config.vm.provision "shell", privileged: false, inline: "brew upgrade"

  tmux_versions.each do |v|
    config.vm.provision "shell", privileged: false, inline: "brew reinstall z80oolong/tmux/tmux@#{v}"
  end
  config.vm.provision "shell", privileged: false, inline: "brew reinstall --formula #{TmuxM::lib_dir}/tmux@#{TmuxM::head_version}.rb"
end
