Vagrant.configure("2") do |config|
  config.vm.provision "shell", privileged: false, inline: "brew reinstall --with-extract #{Config::appimage_tap_name}/appimagetool"
  config.vm.provision "shell", privileged: false, inline: "brew reinstall #{Config::appimage_tap_name}/appimage-runtime"
  config.vm.provision "shell", privileged: false, inline: %[
    brew appimage-build -v -o #{Config::current_appimage_path} -r #{Config::current_builder_path} #{Config::current_formula}
    ]
  config.vm.provision "shell", privileged: false, inline: "mv ./*.AppImage #{Config::release_dir}"
end
