module Config
  module_function

  def stable_version?
    false
  end

  def current_vm_provider
    return "lxc"
  end

  def current_libvirt_driver
    return "qemu"
  end

  def current_vm_provider
    return "lxc"
    #return "libvirt"
  end

  def current_libvirt_driver
    return "qemu"
    #return "kvm"
  end

  def current_vm_provider
    return "lxc"
    #return "libvirt"
  end

  def current_libvirt_driver
    return "qemu"
    #return "kvm"
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

  def current_version_list
    if stable_version? then
      return ["3.5a"]
    else
      return ["HEAD-#{commit}"]
    end
  end

  def all_stable_version
    return %w[2.6 2.7 2.8 2.9 2.9a 3.0 3.0a 3.1 3.1a 3.1b 3.1c 3.2 3.2a 3.3 3.3a 3.4 3.5 3.5a]
  end

  def current_head_formula_version
    return "3.6-next"
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
    return "1fe30bb2e810fa63692ed61903e8ac6ba494c799"
  end

  def commit
    return commit_long[0..7]
  end

  def current_appimage_revision
    return 55
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
