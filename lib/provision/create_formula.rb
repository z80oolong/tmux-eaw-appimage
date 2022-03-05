Vagrant.configure("2") do |config|
  TmuxM::stable_version_list.each do |v|
    config.vm.provision "shell", privileged: false, inline: %[
      brew appimage-install -O -n appimage-tmux@#{v} -c tmux #{TmuxM::release_dir}/tmux-eaw-#{v}-x86_64.AppImage | \
        sed -e 's|#desc ".*"|desc "AppImage package of Terminal multiplexer"|g' \
            -e 's|#homepage ".*"|homepage "https://tmux.github.io/"|g' \
            -e 's|url ".*"|url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/#{TmuxM::appimage_version}/tmux-eaw-#{v}-x86_64.AppImage"|g' \
            -e 's|version ".*"|version "#{v}"|g' \
            -e 's|#revision 0|revision #{TmuxM::appimage_revision}|g' \
	    > #{TmuxM::formula_dir}/appimage-tmux@#{v}.rb
    ]
  end

  if TmuxM::devel_version_list[0] then
    v1dev = TmuxM::devel_version
    v2dev = TmuxM::devel_version_list[0]
    config.vm.provision "shell", privileged: false, inline: %[
      brew appimage-install -O -n appimage-tmux@#{v2dev} -c tmux #{TmuxM::release_dir}/tmux-eaw-#{v1dev}-x86_64.AppImage | \
        sed -e 's|#desc ".*"|desc "AppImage package of Terminal multiplexer"|g' \
            -e 's|#homepage ".*"|homepage "https://tmux.github.io/"|g' \
            -e 's|url ".*"|url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/#{TmuxM::appimage_version}/tmux-eaw-#{v1dev}-x86_64.AppImage"|g' \
            -e 's|version ".*"|version "#{v1dev}"|g' \
            -e 's|#revision 0|revision #{TmuxM::appimage_revision}|g' \
            > #{TmuxM::formula_dir}/appimage-tmux@#{v2dev}.rb
    ]
  end

  vhead = "HEAD-#{TmuxM::commit}"
  config.vm.provision "shell", privileged: false, inline: %[
    brew appimage-install -O -n appimage-tmux@#{TmuxM::head_version} -c tmux #{TmuxM::release_dir}/tmux-eaw-#{vhead}-x86_64.AppImage | \
      sed -e 's|#desc ".*"|desc "AppImage package of Terminal multiplexer"|g' \
          -e 's|#homepage ".*"|homepage "https://tmux.github.io/"|g' \
          -e 's|url ".*"|url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/#{TmuxM::appimage_version}/tmux-eaw-#{vhead}-x86_64.AppImage"|g' \
          -e 's|version ".*"|version "#{vhead}"|g' \
          -e 's|#revision 0|revision #{TmuxM::appimage_revision}|g' \
          > #{TmuxM::formula_dir}/appimage-tmux@#{TmuxM::head_version}.rb
  ]
end
