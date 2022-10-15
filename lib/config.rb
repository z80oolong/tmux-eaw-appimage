module Config
  module_function

  def stable_version?
    false
  end

  def appimage_tap_name
    return "z80oolong/appimage"
  end

  def current_tap_name
    return "z80oolong/tmux"
  end

  def current_formula_name
    return "tmux"
  end

  def current_builder_name
    return "tmux-builder"
  end

  def current_appimage_name
    return "#{current_formula_name}-eaw"
  end

  def current_version
    if stable_version? then
      return "2.6"
    else
      return "HEAD-#{commit}"
    end
  end

  def all_stable_version
    return %w[2.6 2.7 2.8 2.9 2.9a 3.0 3.0a 3.1 3.1a 3.1b 3.1c 3.2 3.2a 3.3 3.3a]
  end

  def current_head_formula_version
    return "3.4-next"
  end

  def all_stable_formulae
    return all_stable_version.map do |v|
      "#{Config::current_tap_name}/#{Config::current_formula_name}@#{v}"
    end
  end

  def current_head_formula
    return "#{lib_dir}/#{current_formula_name}@#{current_head_formula_version}.rb"
  end

  def commit_long
    return "9ef854f5a9112a7d50c382dec403432dea2c3579"
  end

  def commit
    return commit_long[0..7]
  end

  def current_appimage_revision
    return 50
  end

  def release_dir
    return "/vagrant/opt/releases"
  end

  def lib_dir
    return "/vagrant/lib"
  end

  def appimage_arch
    return "x86_64"
  end
end
