Vagrant.configure("2") do |config|
  Config::stable_version_list.each do |v|
    config.vm.provision "shell", privileged: false, inline: %[
      brew appimage-build -v -o ./#{Config::appimage_name}-#{v}-#{Config::appimage_arch}.AppImage \
           -r #{Config::lib_dir}/tmux-builder@#{v}.rb #{Config::formula_fullname}@#{v}
    ]
  end

  if Config::devel_version_list[0] then
    config.vm.provision "shell", privileged: false, inline: %[
      brew appimage-build -v -o ./#{Config::appimage_name}-#{Config::devel_version}-#{Config::appimage_arch}.AppImage \
           -r #{Config::lib_dir}/tmux-builder@#{Config::devel_version_list[0]}.rb #{Config::formula_fullname}@#{Config::devel_version_list[0]}
    ]
  end

  config.vm.provision "shell", privileged: false, inline: %[
    brew appimage-build -v -o ./#{Config::appimage_name}-HEAD-#{Config::commit}-#{Config::appimage_arch}.AppImage \
         -r #{Config::lib_dir}/tmux-builder@#{Config::head_version}.rb #{Config::lib_dir}/#{Config::formula_name}@#{Config::head_version}.rb
  ]

  config.vm.provision "shell", privileged: false, inline: "mv ./*.AppImage #{Config::release_dir}"
end
