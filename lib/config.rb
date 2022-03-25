module Config
  module_function

  def stable_version_list
    return %w(2.6 2.7 2.8 2.9 2.9a 3.0 3.0a 3.1 3.1a 3.1b 3.1c 3.2 3.2a)
  end

  def stable_version
    return stable_version_list[-1]
  end

  def devel_version_list
    return ["3.3"]
  end

  def devel_version
    return "3.3-rc"
  end

  def commit_long
    return "ee3f1d25d568a425420cf14ccba6a1b2a012f7dd"
  end

  def commit
    return commit_long[0..7]
  end

  COMMIT_SHA256 = %x{curl -s -L -o - https://github.com/tmux/tmux/archive/#{commit_long}.tar.gz | sha256sum -}.chomp.gsub(/^([0-9a-f]*).*/) { $1 } 

  def commit_sha256
    return COMMIT_SHA256
  end

  def head_version
    return "3.4-next"
  end

  def appimage_version
    return "v#{stable_version}-eaw-appimage-0.5.1"
  end

  def appimage_revision
    return 32
  end

  def release_dir
    return "/vagrant/opt/releases"
  end

  def formula_dir
    return "/vagrant/opt/formula"
  end

  def lib_dir
    return "/vagrant/lib"
  end

  def appimage_builder_rb
    return "tmux-builder.rb"
  end

  def appimage_name
    return "tmux-eaw"
  end

  def appimage_command
    return "tmux"
  end

  def appimage_arch
    return "x86_64"
  end

  def formula_tap
    return "z80oolong/tmux"
  end

  def formula_name
    return "tmux"
  end

  def formula_fullname
    return "#{formula_tap}/#{formula_name}"
  end

  def formula_desc
    return "AppImage package of Terminal multiplexer"
  end

  def formula_homepage
    return "https://tmux.github.io/"
  end

  def formula_download_url
    return "https://github.com/z80oolong/tmux-eaw-appimage/releases/download"
  end
end
