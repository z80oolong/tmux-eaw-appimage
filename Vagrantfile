$:.unshift((Pathname.new(__FILE__).dirname).realpath.to_s)

require "lib/config"
require "lib/provision/initialize"
require "lib/provision/reinstall"
require "lib/provision/build_appimage"
require "lib/provision/create_formula"

Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2004"
  config.vm.define "vm_for_build_tmux_eaw_appimage_0.0.1"
  config.ssh.insert_key = false
  config.vm.synced_folder "./", "/vagrant", type: "9p", disabled: false, \
                                            accessmode: "squash", owner: "1000"

  config.vm.provider :libvirt do |libvirt|
    libvirt.cpus              = 1
    libvirt.memory            = 10240
    libvirt.machine_type      = "pc-q35-4.2"
    libvirt.disk_bus          = 'sata'
    libvirt.storage_pool_name = "default"
    libvirt.video_type        = "qxl"
    libvirt.graphics_type     = "spice"
  end
end
