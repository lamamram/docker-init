## Toute commande doit-ere exécution dans le répertoire contenant le Vagrantfile
## UP / DOWN
# vagrant up : lance TOUT
# vagrant up <hostname>: lance hostname
# vagrant halt [<hostname>]: arête tout ou seulement hostname
# vagrant destroy [-f] [<hostname>] : détruit [-f sans confirmation] //
# vagrant reload [<hostname>]: halt && up
## CNX
# vagrant ssh [<hostname>]: connexion SSH sur le compte "vagrant" 
#                           via l'interface NAT (127.0.0.1 + redirection 2222 <=> 22)
# vagrant ssh-config: configuration du vagrant ssh
# vagrant global-config
# vagrant plugin (un)install <plg>
##------------------------------------------------------------------

Vagrant.configure(2) do |config|
  # interface réseau à utiliser (ipconfig /all | ip a)
  int = "Intel(R) Ethernet Connection (7) I219-V"
  # gamme d'ip disponibles à utiliser
  range = "192.168.1.3"
  # masque de sous réseau
  cidr = "24"

  image = "mlamamra/debian12-plus"
  subject = "docker"
  hostname = "#{subject}.lan"

  NODES = [
    # { :hostname => "worker1.#{hostname}", :ip => "#{range}1", :mem => 1024, :cpus => 1 },
    # { :hostname => "worker2.#{hostname}", :ip => "#{range}2", :mem => 1024, :cpus => 1 },
    { :hostname => "#{hostname}", :ip => "#{range}0", :mem => 2048, :cpus => 2 },
  ]

  etcHosts = ""
  NODES.each do |node|
    etcHosts += "echo '" + node[:ip] + "   " + node[:hostname] + "' >> /etc/hosts" + "\n"
  end

  

  NODES.each do |node|
    config.vm.define node[:hostname] do |machine|

      machine.vm.provider "virtualbox" do |v|
        v.memory = node[:mem]
        v.cpus = node[:cpus]
        v.name = node[:hostname]
        v.customize ["modifyvm", :id, "--ioapic", "on"]
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      end
      machine.vm.box = "#{image}"
      machine.vm.hostname = node[:hostname]
      machine.vm.network "public_network",
        bridge: "#{int}",
        ip: node[:ip],
        netmask: "#{cidr}"
      machine.ssh.insert_key = false
      # lancer l'install de docker dès le lancement
      machine.vm.provision "shell", 
        path: "install_docker.sh",
        reboot: true,
        args: [hostname]
    end
  end
end
