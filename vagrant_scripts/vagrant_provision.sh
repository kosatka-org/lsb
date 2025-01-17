#! /usr/bin/env bash

# Variables
DBHOST=localhost
DBNAME=lsboutique
DBUSER=vagrant
DBPASSWD=vagrant
LOG_DIR=/vagrant/logs

apt-get -y install curl > $LOG_DIR/vm_build.log 2>&1

echo -e "\n--- Select fastest Ubuntu mirror ---\n"
FAST_MIRROR=$(curl -s http://mirrors.ubuntu.com/mirrors.txt | xargs -n1 -I {} sh -c 'echo `curl -r 0-102400 -s -w %{speed_download} -o /dev/null {}/ls-lR.gz` {}' |sort -g -r |head -1| awk '{ print $2  }')
echo "Selected $FAST_MIRROR \n"
sudo sed -i "s|http://us.archive.ubuntu.com|$FAST_MIRROR|g" /etc/apt/sources.list


echo -e "\n--- Updating packages list ---\n"
apt-get -qq update >> $LOG_DIR/vm_build.log 2>&1

echo -e "\n--- Install base packages ---\n"
apt-get -y install vim build-essential locales-all software-properties-common python-software-properties git >> $LOG_DIR/vm_build.log 2>&1

echo -e "\n--- Add php5.6 repository ---\n"
add-apt-repository -y ppa:ondrej/php >> $LOG_DIR/vm_build.log 2>&1
add-apt-repository -y ppa:nijel/phpmyadmin >> $LOG_DIR/vm_build.log 2>&1

echo -e "\n--- Updating packages list ---\n"
apt-get -qq update

echo -e "\n--- Installing PHP-specific packages ---\n"
apt-get -y install php5.6 apache2 libapache2-mpm-itk php5.6-mbstring php5.6-xml php-gettext php5.6-curl php5.6-gd php5.6-gettext libapache2-mod-php5.6 >> $LOG_DIR/vm_build.log 2>&1

# MySQL setup for development purposes ONLY
echo -e "\n--- Install MySQL specific packages and settings ---\n"
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBPASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"
apt -y install mysql-server libmysqlclient-dev php5.6-mysql >> $LOG_DIR/vm_build.log 2>&1
apt -y install phpmyadmin >> $LOG_DIR/vm_build.log 2>&1
sudo ln -sfn /usr/bin/php5.6 /etc/alternatives/php

echo -e "\n--- Setting up our MySQL user and db ---\n"
mysql -uroot -p$DBPASSWD -e "CREATE DATABASE $DBNAME;" >> $LOG_DIR/vm_build.log 2>&1
mysql -uroot -p$DBPASSWD -e "grant all privileges on $DBNAME.* to '$DBUSER'@'localhost' identified by '$DBPASSWD';" >> $LOG_DIR/vm_build.log 2>&1
mysql -uroot -p$DBPASSWD -e "ALTER DATABASE $DBNAME CHARACTER SET utf8 COLLATE utf8_unicode_ci;" >> $LOG_DIR/vm_build.log 2>&1

echo -e "\n--- Disable MySQL strict mode  ---\n"
echo "sql_mode=IGNORE_SPACE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" >> /etc/mysql/mysql.conf.d/mysqld.cnf

echo -e "\n--- Enabling mod-rewrite and mod-proxy ---\n"
a2enmod rewrite >> $LOG_DIR/vm_build.log 2>&1
a2enmod proxy >> $LOG_DIR/vm_build.log 2>&1
a2enmod proxy_http >> $LOG_DIR/vm_build.log 2>&1

echo -e "\n--- Allowing Apache override to all ---\n"
sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

echo -e "\n--- Setting document root to public directory ---\n"
rm -rf /var/www/html
ln -fs /vagrant /var/www/html
rm /etc/apache2/sites-enabled/*
cp /vagrant/vagrant_scripts/lsboutique.test.conf /etc/apache2/sites-enabled/lsboutique.test.conf

echo -e "\n--- We definitly need to see the PHP errors, turning them on ---\n"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/5.6/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/5.6/apache2/php.ini

echo -e "\n--- Restarting Apache ---\n"
systemctl restart apache2 >> $LOG_DIR/vm_build.log 2>&1

echo -e "\n--- Restarting Mysql server ---\n"
systemctl restart mysql.service >> $LOG_DIR/vm_build.log 2>&1

echo -e "\n--- Install Redis ---\n"
apt-get -y install redis-server >> $LOG_DIR/vm_build.log 2>&1

echo -e "\n--- Resetting default language to English ---\n"
update-locale --reset
update-locale LANG=en_US.UTF-8

echo -e "\n--- Setting default SSH directory to /vagrant ---\n"
echo "cd /vagrant" >> /home/vagrant/.bashrc
