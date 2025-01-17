#!/bin/bash

echo -e "\n--- Installing rvm dependencies ---\n"
sudo apt-get -yqq install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev > /vagrant/logs/rvm.log 2>&1

echo -e "\n--- Installing rvm ---\n"
gpg --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s head
source $HOME/.rvm/scripts/rvm

echo -e "\n--- Installing ruby dependencies ---\n"
sudo apt-get -yqq install zlib1g-dev libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev libffi-dev gawk pkg-config libgmp-dev > /vagrant/logs/rvm.log 2>&1

echo -e "\n--- Installing ruby ---\n"
rvm use --default --install $1

shift

if (( $# ))
then gem install $@
fi

rvm cleanup all
