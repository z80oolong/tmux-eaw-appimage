Vagrant.configure("2") do |config|
  config.vm.provision "shell", privileged: true, inline: "sudo apt-get update"
  config.vm.provision "shell", privileged: true, inline: "sudo apt-get -y upgrade"

  config.vm.provision "shell", privileged: false, inline: "git -C $(brew --repo) checkout master"
  config.vm.provision "shell", privileged: false, inline: "brew remove --force #{Config::all_formulae.join(' ')}"
  config.vm.provision "shell", privileged: false, inline: "brew doctor"
  config.vm.provision "shell", privileged: false, inline: "brew update"
  config.vm.provision "shell", privileged: false, inline: "brew upgrade"

  config.vm.provision "shell", privileged: false, inline: "env HOMEBREW_ARCH='x86-64' brew reinstall #{Config::current_formula}"
end
