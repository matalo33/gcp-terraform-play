#!/bin/bash

apt-get update
apt-get upgrade -y
apt-get install -y apache2 mysql-client php php-mysql unzip less traceroute
service apache2 restart
cd /var/www
wget https://wordpress.org/latest.tar.gz && tar xfz latest.tar.gz
cd wordpress/
cp wp-config-sample.php wp-config.php
perl -pi -e "s/database_name_here/${db_db}/g" wp-config.php
perl -pi -e "s/username_here/${db_username}/g" wp-config.php
perl -pi -e "s/password_here/${db_password}/g" wp-config.php
perl -pi -e "s/localhost/${db_host}/g" wp-config.php
rm -rf /var/www/html
ln -s /var/www/wordpress /var/www/html

curl "http://localhost/wp-admin/install.php?step=2" \
  --data-urlencode "weblog_title=${wp_install_domain}"\
  --data-urlencode "user_name=${wp_install_admin_username}" \
  --data-urlencode "admin_email=${wp_install_admin_email}" \
  --data-urlencode "admin_password=${wp_install_admin_password}" \
  --data-urlencode "admin_password2=${wp_install_admin_password}" \
  --data-urlencode "pw_weak=1"