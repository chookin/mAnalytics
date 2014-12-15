#!/usr/bin/env bash

username=`whoami`
SRC_PATH="/home/${username}/mAnalytics/softwares/conf"
TARGET_PATH="/home/${username}/local"

cd ${TARGET_PATH}/mysql

scripts/mysql_install_db --defaults-file=etc/my.cnf
mkdir var
bin/mysqld_safe  --defaults-file=etc/my.cnf &
bin/mysqladmin -u root password "123456"