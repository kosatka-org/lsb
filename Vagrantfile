# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # config.vm.box = "bento/ubuntu-16.04"
  config.vm.box = "generic/ubuntu1604"

  config.vm.provider :libvirt do |libvirt|
    libvirt.cpu_mode = "host-passthrough"
    config.vm.synced_folder './', '/vagrant', type: 'nfs', nfs_udp: false, nfs_version: 3
  end

  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.network "forwarded_port", guest: 80, host: 8088


  # System packages
  config.vm.provision "Install essential packages with apt", type: "shell", path: "vagrant_scripts/vagrant_provision.sh"

  # Environment
  config.vm.provision "Install Ruby using RVM", type: "shell", path: "vagrant_scripts/ruby_install.sh", args: "2.6.1 bundler", privileged: false
  config.vm.provision "Install Nodejs using NVM", type: "shell", path: "vagrant_scripts/node_install.sh", privileged: false
  config.vm.provision "Install Composer for PHP package management", type: "shell", path: "vagrant_scripts/composer_install.sh", privileged: false

  # Install packages
  config.vm.provision "Install Ruby packages from Gemfile", type: "shell", inline: "cd /vagrant && bundle install", privileged: false
  config.vm.provision "Install PHP packages from composer.json", type: "shell", inline: "cd /vagrant && composer install > /vagrant/logs/composer.log 2>&1", privileged: false
  # config.vm.provision "Install Nodejs packages from package.json", inline: "npm install", privileged: false

  config.vm.provision "Copy config file", type: "shell", inline: "cp /vagrant/Config.class.php.example /vagrant/Config.class.php", privileged: false
  config.vm.provision "Copy .env file", type: "shell", inline: "cp /vagrant/.env.example /vagrant/.env", privileged: false

  # Create database
  config.vm.provision "Import database data", type: "shell", inline: "cd /vagrant/cron && bundle exec ruby db_import.rb > /vagrant/logs/db_import.log 2>&1", privileged: false

  config.vm.provision "shell", inline: "systemctl restart apache2 > /dev/null 2>&1", run: "always"
  config.vm.provision "shell", inline: '/usr/bin/redis-cli flushall', run: "always", privileged: false
  config.vm.provision "shell", inline: '/bin/bash --login -c "cd /vagrant/cron && nohup bundle e rerun --background --force-polling -- bundle e puma --config puma_config.rb </dev/null >logs/rerun.log 2>&1 &"', run: "always", privileged: false
  config.vm.provision "shell", inline: '/bin/bash --login -c "cd /vagrant/cron && nohup bundle e rerun --background --force-polling -- bundle e puma --config roda_config.rb </dev/null >logs/rerun.log 2>&1 &"', run: "always", privileged: false
end
