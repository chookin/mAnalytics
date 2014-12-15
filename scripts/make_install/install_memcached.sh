#!/usr/bin/env bash

username=`whoami`
SOFT_PATH="/home/${username}/mAnalytics/softwares"
SRC_PATH="/home/${username}/tmp/make"
TARGET_PATH="/home/${username}/local"

function install_libevent() {
    soft_name='libevent-2.0.21-stable'
    echo 'install ${soft_name}'
    cd ${SRC_PATH} && tar -zxvf ${SOFT_PATH}/${soft_name}.tar.gz \
    && cd ${soft_name} \
    && ./configure --prefix=${TARGET_PATH}/libevent && make && make install
}
function install_memcached() {
    soft_name='memcached-1.4.21'
    echo 'install ${soft_name}'
    cd ${SRC_PATH} && tar -zxvf ${SOFT_PATH}/${soft_name}.tar.gz \
    && cd ${soft_name} \
    && ./configure --prefix=${TARGET_PATH}/memcached --with-libevent=${TARGET_PATH}/libevent \
    &&  make && make install
}

mkdir -p ${SRC_PATH}
install_libevent
install_memcached