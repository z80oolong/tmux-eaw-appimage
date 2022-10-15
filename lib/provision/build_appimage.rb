Vagrant.configure("2") do |config|
  if Config::stable_version? then
    config.vm.provision "shell", privileged: false, inline: %[
      brew appimage-build -v -o ./#{Config::current_appimage_name}-#{Config::current_version}-#{Config::appimage_arch}.AppImage \
           -r #{Config::lib_dir}/#{Config::current_builder_name}@#{Config::current_version}.rb \
              #{Config::current_tap_name}/#{Config::current_formula_name}@#{Config::current_version}
    ]
  else
    config.vm.provision "shell", privileged: false, inline: %[
      brew appimage-build -v -o ./#{Config::current_appimage_name}-#{Config::current_version}-#{Config::appimage_arch}.AppImage \
           -r #{Config::lib_dir}/#{Config::current_builder_name}@#{Config::current_head_formula_version}.rb \
              #{Config::lib_dir}/#{Config::current_formula_name}@#{Config::current_head_formula_version}.rb
    ]
  end
  config.vm.provision "shell", privileged: false, inline: "mv ./*.AppImage #{Config::release_dir}"
end
