#!/usr/bin/env bash

username=`whoami`
SOFT_PATH="/home/${username}/mAnalytics/softwares"
SRC_PATH="/home/${username}/tmp/make"
TARGET_PATH="/home/${username}/local"


function install_apache() {
    soft_name='httpd-2.2.29'
    echo 'install ${soft_name}'
    cd ${SRC_PATH} && tar -xvf ${SOFT_PATH}/${soft_name}.tar.gz \
    && cd ${soft_name} \
    &&  ./configure --with-layout=Apache --prefix=${TARGET_PATH}/apache --with-port=80 --enable-modules=most --enable-module=so --enable-module=rewrite --enable-ssl --enable-mime-magic \
    && make && make install
}

function install_mod() {
    soft_name='mod_evasive'
    echo 'install ${soft_name}'
    cd ${SRC_PATH} && tar -zxvf ${SOFT_PATH}/${soft_name}_1.10.1.tar.gz \
    && cd ${soft_name} \
    && ${TARGET_PATH}/apache/bin/apxs -cia mod_evasive20.c
}

mkdir -p ${SRC_PATH}
install_apache
install_mod