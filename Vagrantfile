VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/trusty64"
  config.vm.provision :shell, path: "vagrant/provision.sh"
  config.ssh.forward_agent = true

  config.vm.network "private_network", ip: "192.168.20.3"
  config.vm.synced_folder ".", "/vagrant"
  config.vm.synced_folder "firesafe", "/var/www/firesafe.dev", owner: "www-data", group: "www-data", mount_options: ["dmode=775,fmode=775"]

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
  end

end