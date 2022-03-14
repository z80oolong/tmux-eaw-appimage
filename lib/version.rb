module TmuxM
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
    "/vagrant/opt/releases"
  end

  def formula_dir
    "/vagrant/opt/formula"
  end

  def lib_dir
    "/vagrant/lib"
  end
end