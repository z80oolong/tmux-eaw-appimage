$:.unshift((Pathname.new(__FILE__).dirname).realpath.to_s)

require "lib/config"
require "lib/provision/initialize"
require "lib/provision/reinstall"
require "lib/provision/build_appimage"

case Config::current_vm_provider
when "libvirt"
  ENV["VAGRANT_DEFAULT_PROVIDER"] = "libvirt"
when "lxc"
  ENV["VAGRANT_DEFAULT_PROVIDER"] = "lxc"
else
  raise "Invalid Config::current_vm_provider"
end

Vagrant.configure("2") do |config|
  case ENV["VAGRANT_DEFAULT_PROVIDER"]
  when "libvirt"
    config.vm.box = "generic/ubuntu2004"
  when "lxc"
    config.vm.box = "isc/lxc-ubuntu-20.04"
  end
  config.vm.define "vm_for_build_tmux_eaw_appimage_#{Config::current_appimage_revision}"
  config.ssh.insert_key = false
  config.vm.network :forwarded_port, guest: 22, host: 12022
  config.vm.synced_folder "./", "/vagrant", type: "rsync", disabled: false, \
                                             accessmode: "squash", owner: "1000"

  config.vm.provider :libvirt do |libvirt|
    case Config::current_libvirt_driver
    when "qemu"
      libvirt.driver          = "qemu"
    when "kvm"
      libvirt.driver          = "kvm"
    else
      raise "Invalid Config::current_libvirt_driver"
    end
    libvirt.cpus              = 1
    libvirt.memory            = 10240
    libvirt.machine_type      = "pc-q35-4.2"
    libvirt.disk_bus          = 'sata'
    libvirt.storage_pool_name = "default"
    libvirt.video_type        = "qxl"
    libvirt.graphics_type     = "spice"
  end

  config.vm.provider :lxc do |lxc|
    lxc.customize 'cgroup.memory.limit_in_bytes', '20480M'
  end
end
