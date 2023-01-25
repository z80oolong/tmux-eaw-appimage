Vagrant.configure("2") do |config|
  config.vm.provision "shell", privileged: false, inline: "brew reinstall --with-extract #{Config::appimage_tap_name}/appimagetool"
  config.vm.provision "shell", privileged: false, inline: "brew reinstall #{Config::appimage_tap_name}/appimage-runtime"
  if Config::stable_version? then
    Config::current_version_list.each do |version|
      config.vm.provision "shell", privileged: false, inline: %[
        brew appimage-build -v -o ./#{Config::current_appimage_name}-#{version}-#{Config::appimage_arch}.AppImage \
             -r #{Config::lib_dir}/#{Config::current_builder_name}@#{version}.rb \
                #{Config::current_tap_name}/#{Config::current_formula_name}@#{version}
      ]
    end
  else
    config.vm.provision "shell", privileged: false, inline: %[
      brew appimage-build -v -o ./#{Config::current_appimage_name}-#{Config::current_version_list[0]}-#{Config::appimage_arch}.AppImage \
           -r #{Config::lib_dir}/#{Config::current_builder_name}@#{Config::current_head_formula_version}.rb \
              #{Config::lib_dir}/#{Config::current_formula_name}@#{Config::current_head_formula_version}.rb
    ]
  end
  config.vm.provision "shell", privileged: false, inline: "mv ./*.AppImage #{Config::release_dir}"
end
