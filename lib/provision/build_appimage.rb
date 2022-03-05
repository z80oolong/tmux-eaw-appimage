Vagrant.configure("2") do |config|
  TmuxM::stable_version_list.each do |v|
    config.vm.provision "shell", privileged: false, inline: %[
      brew appimage-build -v -o ./tmux-eaw-#{v}-x86_64.AppImage z80oolong/tmux/tmux@#{v}
    ]
  end

  if TmuxM::devel_version_list[0] then
    config.vm.provision "shell", privileged: false, inline: %[
      brew appimage-build -v -o ./tmux-eaw-#{TmuxM::devel_version}-x86_64.AppImage z80oolong/tmux/tmux@#{TmuxM::devel_version_list[0]}
    ]
  end

  config.vm.provision "shell", privileged: false, inline: %[
    brew appimage-build -v -o ./tmux-eaw-HEAD-#{TmuxM::commit}-x86_64.AppImage #{TmuxM::lib_dir}/tmux@#{TmuxM::head_version}.rb
  ]

  config.vm.provision "shell", privileged: false, inline: "mv ./tmux-eaw-*-x86_64.AppImage #{TmuxM::release_dir}"
end
