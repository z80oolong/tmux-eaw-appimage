Vagrant.configure("2") do |config|
  config.vm.provision "shell", privileged: true, inline: "sudo apt-get update"
  config.vm.provision "shell", privileged: true, inline: "sudo apt-get -y upgrade"

  config.vm.provision "shell", privileged: false, inline: "git -C $(brew --repo) checkout master"
  config.vm.provision "shell", privileged: false, inline: "brew remove --force #{Config::all_stable_formulae.join(' ')}"
  config.vm.provision "shell", privileged: false, inline: "brew remove --force #{Config::current_formula_name}@#{Config::current_head_formula_version}"
  config.vm.provision "shell", privileged: false, inline: "brew doctor"
  config.vm.provision "shell", privileged: false, inline: "brew update"
  config.vm.provision "shell", privileged: false, inline: "brew upgrade"

  if Config::stable_version? then
    Config::current_version_list.each do |version|
      config.vm.provision "shell", privileged: false, inline: "brew reinstall #{Config::current_formula_name}@#{version}"
    end
  else
    config.vm.provision "shell", privileged: false, inline: %[
      brew reinstall --formula #{Config::lib_dir}/#{Config::current_formula_name}@#{Config::current_head_formula_version}.rb
    ]
  end
end
