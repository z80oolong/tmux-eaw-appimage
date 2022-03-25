Vagrant.configure("2") do |config|
  Config::stable_version_list.each do |v|
    config.vm.provision "shell", privileged: false, inline: %[
      brew appimage-install -O -n appimage-#{Config::formula_name}@#{v} -c #{Config::appimage_command} \
           #{Config::release_dir}/#{Config::appimage_name}-#{v}-#{Config::appimage_arch}.AppImage | \
        sed -e 's|#desc ".*"|desc "#{Config::formula_desc}"|g' \
            -e 's|#homepage ".*"|homepage "#{Config::formula_homepage}"|g' \
            -e 's|url ".*"|url "#{Config::formula_download_url}/#{Config::appimage_version}/#{Config::appimage_name}-#{v}-#{Config::appimage_arch}.AppImage"|g' \
            -e 's|version ".*"|version "#{v}"|g' \
            -e 's|#revision 0|revision #{Config::appimage_revision}|g' \
	    > #{Config::formula_dir}/appimage-#{Config::formula_name}@#{v}.rb
    ]
  end

  if Config::devel_version_list[0] then
    v1dev = Config::devel_version
    v2dev = Config::devel_version_list[0]
    config.vm.provision "shell", privileged: false, inline: %[
      brew appimage-install -O -n appimage-#{Config::formula_name}@#{v2dev} -c #{Config::appimage_command} \
           #{Config::release_dir}/#{Config::appimage_name}-#{v1dev}-#{Config::appimage_arch}.AppImage | \
        sed -e 's|#desc ".*"|desc "#{Config::formula_desc}"|g' \
            -e 's|#homepage ".*"|homepage "#{Config::formula_homepage}"|g' \
            -e 's|url ".*"|url "#{Config::formula_download_url}/#{Config::appimage_version}/#{Config::appimage_name}-#{v1dev}-#{Config::appimage_arch}.AppImage"|g' \
            -e 's|version ".*"|version "#{v1dev}"|g' \
            -e 's|#revision 0|revision #{Config::appimage_revision}|g' \
            > #{Config::formula_dir}/appimage-#{Config::formula_name}@#{v2dev}.rb
    ]
  end

  vhead = "HEAD-#{Config::commit}"
  config.vm.provision "shell", privileged: false, inline: %[
    brew appimage-install -O -n appimage-#{Config::formula_name}@#{Config::head_version} -c #{Config::appimage_command} \
         #{Config::release_dir}/#{Config::appimage_name}-#{vhead}-#{Config::appimage_arch}.AppImage | \
      sed -e 's|#desc ".*"|desc "#{Config::formula_desc}"|g' \
          -e 's|#homepage ".*"|homepage "#{Config::formula_homepage}"|g' \
          -e 's|url ".*"|url "#{Config::formula_download_url}/#{Config::appimage_version}/#{Config::appimage_name}-#{vhead}-#{Config::appimage_arch}.AppImage"|g' \
          -e 's|version ".*"|version "#{vhead}"|g' \
          -e 's|#revision 0|revision #{Config::appimage_revision}|g' \
          > #{Config::formula_dir}/appimage-#{Config::formula_name}@#{Config::head_version}.rb
  ]
end
