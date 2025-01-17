
#!/bin/bash

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash > /vagrant/logs/nvm.log 2>&1

export NVM_DIR="/home/vagrant/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

nvm install node  > /vagrant/logs/nvm.log 2>&1
npm install -g brunch  > /vagrant/logs/nvm.log 2>&1
