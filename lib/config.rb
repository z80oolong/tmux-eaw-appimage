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
    return "ac16f2c641d3d16276f3a41b2aae26832ad5fd9c"
  end

  def commit
    return commit_long[0..7]
  end

  def commit_sha256
    @@curl ||= %x{which curl}.chomp!
    @@sha256sum ||= %x{which sha256sum}.chomp!
    @@archive_url ||= "https://github.com/tmux/tmux/archive"
    @@commit_sha256 ||= %x{#{@@curl} -s -L -o - #{@@archive_url}/#{commit_long}.tar.gz | #{@@sha256sum} -}.chomp.gsub(/^([0-9a-f]*).*/) { $1 }
    return @@commit_sha256
  end

  def head_version
    return "3.4-next"
  end

  def appimage_version
    return "v#{stable_version}-eaw-appimage-0.5.2"
  end

  def appimage_revision
    return 34
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
