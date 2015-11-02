# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

$bootstrap = <<SCRIPT
apt-get update

#Install Docker
#curl -sSL https://get.docker.com/ubuntu/ | sudo sh
wget -qO- https://get.docker.com/ | sed 's/lxc-docker/lxc-docker-1.8.1/' | sh
gpasswd -a vagrant docker
service docker restart

# Install docker-compose
sudo sh -c "curl -L https://github.com/docker/compose/releases/download/1.4.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
sudo chmod +x /usr/local/bin/docker-compose
sudo sh -c "curl -L https://raw.githubusercontent.com/docker/compose/1.4.0/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"

# Others
apt-get -y install git


SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.network "forwarded_port", guest: 8000, host: 8000

  config.vm.network "private_network", ip: "192.168.33.10"

  # map sbex.local to local ip (need plugin: vagrant plugin install vagrant-hostsupdater)
  config.hostsupdater.aliases = ["dev.local"]

  config.vm.provider "virtualbox" do |vb|
     vb.customize ["modifyvm", :id, "--memory", "2048"]
     vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
  end

  config.vm.synced_folder ".", "/vagrant"
  
 config.vm.provision :shell, inline: $bootstrap
 # config.vm.provision :shell, inline: $db
 # config.vm.provision :shell, inline: $django

end
