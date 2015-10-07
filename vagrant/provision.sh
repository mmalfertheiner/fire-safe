#!/bin/bash

# Locales
grep -q 'LC_ALL="en_US.UTF-8"' /etc/environment || echo 'LC_ALL="en_US.UTF-8"' >> /etc/environment

# Hostname, Hosts
cp /vagrant/vagrant/files/hostname /etc/hostname
cp /vagrant/vagrant/files/hosts /etc/hosts

# Timezone
cp /vagrant/vagrant/files/timezone /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata

# Bash profile
grep -q "export PATH=\"\$PATH:./vendor/bin:~/.composer/vendor/bin\"" /home/vagrant/.bashrc || echo "export PATH=\"\$PATH:./vendor/bin:~/.composer/vendor/bin\"" >> /home/vagrant/.bashrc
grep -q "export PATH=\"\$PATH:./node_modules/.bin\"" /home/vagrant/.bashrc || echo "export PATH=\"\$PATH:./node_modules/.bin\"" >> /home/vagrant/.bashrc
grep -q "alias artisan='php artisan'" /home/vagrant/.bashrc || echo "alias artisan='php artisan'" >> /home/vagrant/.bashrc

# Updates
apt-get update
apt-get upgrade -y

# Basic packages
apt-get install -y build-essential software-properties-common curl wget vim git

# Firewall
cp /vagrant/vagrant/files/iptables.firewall.rules /etc/iptables.firewall.rules
cp /vagrant/vagrant/files/firewall /etc/network/if-pre-up.d/firewall
chmod 755 /etc/network/if-pre-up.d/firewall
iptables-restore < /etc/iptables.firewall.rules

# Fail2ban
apt-get install -y fail2ban
cp /vagrant/vagrant/files/jail.local /etc/fail2ban/jail.local
service fail2ban restart

# MySQL
debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'
apt-get install -y mysql-client mysql-server
mysql --user=root --password=password --database=mysql --execute="DELETE FROM user where user='root' and host='127.0.0.1'"
mysql --user=root --password=password --database=mysql --execute="DELETE FROM user where user='root' and host='::1'"
mysql --user=root --password=password --database=mysql --execute="DELETE FROM user where user='root' and host='vagrant-ubuntu-trusty-64'"
mysql --user=root --password=password --database=mysql --execute="DELETE FROM user where user='debian-sys-maint' and host='localhost'"
mysql --user=root --password=password --database=mysql --execute="CREATE DATABASE firesafe"
mysql --user=root --password=password --database=mysql --execute="GRANT ALL ON firesafe.* TO firesafe@localhost IDENTIFIED BY 'password'"
service mysql restart

# PHP-FPM
add-apt-repository -y ppa:ondrej/php5
apt-get update
apt-get install -y --force-yes php5-fpm php5-cli php5-mysql php5-sqlite php5-curl php5-gd php5-mcrypt php5-json php5-xdebug

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/cli/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/cli/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php5/cli/php.ini
sed -i "s/;date.timezone.*/date.timezone = Europe\/Rome/" /etc/php5/cli/php.ini

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php5/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = Europe\/Rome/" /etc/php5/fpm/php.ini

grep -q "xdebug.remote_enable = 1" /etc/php5/fpm/conf.d/20-xdebug.ini || echo "xdebug.remote_enable = 1" >> /etc/php5/fpm/conf.d/20-xdebug.ini
grep -q "xdebug.remote_connect_back = 1" /etc/php5/fpm/conf.d/20-xdebug.ini || echo "xdebug.remote_connect_back = 1" >> /etc/php5/fpm/conf.d/20-xdebug.ini
grep -q "xdebug.remote_port = 9000" /etc/php5/fpm/conf.d/20-xdebug.ini || echo "xdebug.remote_port = 9000" >> /etc/php5/fpm/conf.d/20-xdebug.ini
grep -q "xdebug.max_nesting_level = 200" /etc/php5/fpm/conf.d/20-xdebug.ini || echo "xdebug.max_nesting_level = 200" >> /etc/php5/fpm/conf.d/20-xdebug.ini

service php5-fpm restart

# Nginx
add-apt-repository -y ppa:nginx/stable
apt-get update
apt-get install -y nginx
cp -R /vagrant/vagrant/files/h5bp /etc/nginx/
cp /vagrant/vagrant/files/mime.types /etc/nginx/
cp /vagrant/vagrant/files/nginx.conf /etc/nginx/
chmod -R 755 /etc/nginx/h5bp
chmod 644 /etc/nginx/h5bp/basic.conf
chmod 644 /etc/nginx/h5bp/directive-only/*
chmod 644 /etc/nginx/h5bp/location/*
chmod 644 /etc/nginx/mime.types
chmod 644 /etc/nginx/nginx.conf
rm -f /etc/nginx/sites-enabled/default
rm -f /etc/nginx/sites-available/default
cp /vagrant/vagrant/files/firesafe.dev.conf /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/firesafe.dev.conf /etc/nginx/sites-enabled/firesafe.dev.conf
service nginx restart

# Composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer


# Nodejs
apt-get install -y nodejs nodejs-legacy npm

# Sass
gem install sass

