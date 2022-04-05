Vagrant.configure("2") do |config|
  formula_versions = Config::stable_version_list + Config::devel_version_list

  config.vm.provision "shell", privileged: true, inline: "sudo apt-get update"
  config.vm.provision "shell", privileged: true, inline: "sudo apt-get -y upgrade"

  config.vm.provision "shell", privileged: false, inline: "brew remove --force #{Config::formula_name}@#{Config::head_version}"
  config.vm.provision "shell", privileged: false, inline: "brew doctor"
  config.vm.provision "shell", privileged: false, inline: "brew update"
  config.vm.provision "shell", privileged: false, inline: "brew upgrade"

  formula_versions.each do |v|
    config.vm.provision "shell", privileged: false, inline: "brew reinstall #{Config::formula_fullname}@#{v}"
  end
  config.vm.provision "shell", privileged: false, inline: "brew reinstall --formula #{Config::lib_dir}/#{Config::formula_name}@#{Config::head_version}.rb"
end
