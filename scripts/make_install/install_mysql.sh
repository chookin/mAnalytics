#!/usr/bin/env bash

username=`whoami`
SOFT_PATH="/home/${username}/mAnalytics/softwares"
SRC_PATH="/home/${username}/tmp/make"
TARGET_PATH="/home/${username}/local"


function install_mysql() {
    soft_name='mysql-5.6.21'
    echo 'install ${soft_name}'
    cd ${SRC_PATH} && tar -zxvf ${SOFT_PATH}/${soft_name}.src.tgz \
    && cd ${soft_name} \
    &&  cmake \
        -DCMAKE_INSTALL_PREFIX=${TARGET_PATH}/mysql \
        -DMYSQL_DATADIR=${TARGET_PATH}/mysql/data \
        -DSYSCONFDIR=${TARGET_PATH}/mysql/etc \
        -DWITH_MYISAM_STORAGE_ENGINE=1 \
        -DWITH_INNOBASE_STORAGE_ENGINE=1 \
        -DWITH_MEMORY_STORAGE_ENGINE=1 \
        -DWITH_READLINE=1 \
        -DMYSQL_UNIX_ADDR=${TARGET_PATH}/mysql/var/mysql.sock \
        -DMYSQL_TCP_PORT=3306 \
        -DENABLED_LOCAL_INFILE=1 \
        -DWITH_PARTITION_STORAGE_ENGINE=1 \
        -DEXTRA_CHARSETS=all \
        -DDEFAULT_CHARSET=utf8 \
        -DDEFAULT_COLLATION=utf8_general_ci \
    && make && make install
}

mkdir -p ${SRC_PATH}
install_mysql