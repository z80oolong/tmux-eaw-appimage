module Config
  module_function

  def stable_version?
    false
  end

  def current_vm_provider
    return "lxc"
    #return "libvirt"
  end

  def current_libvirt_driver
    return "qemu"
    #return "kvm"
  end

  def appimage_arch
    return "x86_64"
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

  def current_builder_path
    if stable_version? then
      return "#{lib_dir}/#{current_builder_name}@#{current_version}.rb"
    else
      return "#{lib_dir}/#{current_builder_name}-head.rb"
    end
  end

  def current_appimage_path
    return "./#{current_appimage_name}-#{current_version}-#{appimage_arch}.AppImage"
  end

  def current_version
    if stable_version? then
      return "3.5a"
    else
      return "HEAD-#{commit}"
    end
  end

  def all_stable_version
    return %w[3.3 3.3a 3.4 3.5 3.5a]
  end

  def commit_long
    return "00894d188d2a60767a80ae749e7c3fc810fca8cd"
  end

  def commit
    return commit_long[0..7]
  end

  def current_formula
    if stable_version? then
      return "#{current_tap_name}/#{current_formula_name}@#{current_version}"
    else
      return "#{current_tap_name}/#{current_formula_name}-head"
    end
  end
  
  def all_formulae
    result = all_stable_version.map do |v|
      "#{current_tap_name}/#{current_formula_name}@#{v}"
    end
    result << "#{current_tap_name}/#{current_formula_name}-head"
    return result
  end

  def current_appimage_revision
    return 56
  end

  def release_dir
    return "/vagrant/opt/releases"
  end

  def lib_dir
    return "/vagrant/lib"
  end
end
