require 'yaml'
require 'json'
require 'fileutils'

if File.exist?("./vagrant/config.yml")
  vm_config = YAML.load_file("./vagrant/config.yml")
else
  vm_config = YAML.load_file("./vagrant/config.default.yml")
end

set_environment = <<SCRIPT
tee "/etc/profile.d/vagrant.sh" > "/dev/null" <<EOF
export PATH="${HOME}/bin:${PATH}"
EOF
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.define :zimagi do |machine|
    machine.vm.box = vm_config["box_name"]
    machine.vm.hostname = vm_config["hostname"]
    machine.vm.network "private_network", type: "dhcp"

    machine.vm.provider :virtualbox do |v|
      v.name = vm_config["hostname"]
      v.memory = vm_config["memory_size"]
      v.cpus = vm_config["cpus"]
      v.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
    end

    machine.ssh.username = vm_config["user"]

    machine.vm.synced_folder ".", "/vagrant", disabled: true
    machine.vm.synced_folder "./k8s", "/home/vagrant/k8s", owner: "vagrant", group: "vagrant"
    machine.vm.synced_folder "./clusters", "/home/vagrant/clusters", owner: "vagrant", group: "vagrant"

    machine.vm.provision :shell, inline: set_environment, run: "always"

    Dir.foreach("./scripts") do |script|
      next if script == '.' or script == '..'
      script_name = File.basename(script, File.extname(script))
      machine.vm.provision :file,
        source: "./scripts/#{script}",
        destination: "bin/#{script_name}"
    end

    if vm_config["copy_vimrc"]
      machine.vm.provision :file, source: "~/.vimrc", destination: ".vimrc"
    end

    if vm_config["copy_profile"]
      machine.vm.provision :file, source: "~/.profile", destination: ".profile"
    end
    if vm_config["copy_bash_aliases"]
      machine.vm.provision :file, source: "~/.bash_aliases", destination: ".bash_aliases"
    end
    if vm_config["copy_bashrc"]
      machine.vm.provision :file, source: "~/.bashrc", destination: ".bashrc"
    end

    machine.vm.provision :shell do |s|
      s.name = "Bootstrapping development environment"
      s.path = "scripts/bootstrap.sh"
      s.args = [ 
        'vagrant', 
        vm_config['log_output'], 
        vm_config['time_zone'], 
        vm_config['kubernetes_version'] 
      ]
    end
  end
end
