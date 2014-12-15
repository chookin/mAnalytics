#!/usr/bin/env bash

username=`whoami`
SRC_PATH="/home/${username}/mAnalytics/conf"
TARGET_PATH="/home/${username}/local"

function create_dir() {
    myPath=$1
    if [ ! -d "$myPath" ]; then
        mkdir -p "$myPath"
    fi
}
function update_userpath() {
    echo 'update userpath'
    sed -i "s/home\/work/home\/${username}/g" `grep home/work -rl ${SRC_PATH}`
}
function update_apache() {
    echo 'update apache'
    cd ${TARGET_PATH}/apache
    rm -rf conf
    cp -rf ${SRC_PATH}/http-conf ${TARGET_PATH}/apache/conf
}

function update_php() {
    echo 'udpate php'
    cp ${SRC_PATH}/php.ini ${TARGET_PATH}/php/lib/php.ini
}

function update_redis() {
    echo 'update redis'
    cd ${TARGET_PATH}/redis
    cp ${SRC_PATH}/redis.conf
}
function update_targetV3() {
    echo 'update targetV3'
    targetV3_conf_path="${SRC_PATH}/targetV3_conf"
    targetV3_path="/home/${username}/targetV3"

    cp ${targetV3_conf_path}/db.ini ${targetV3_path}/webapp/application/configs/
    cp ${targetV3_conf_path}/log.ini ${targetV3_path}/webapp/application/configs/
    cp ${targetV3_conf_path}/recom.ini ${targetV3_path}/webapp/application/configs/
    cp ${targetV3_conf_path}/site.ini ${targetV3_path}/webapp/application/configs/

    cp ${targetV3_conf_path}/cache.inc.php ${targetV3_path}/webapp/inc/
    cp ${targetV3_conf_path}/webreport.ini ${targetV3_path}/webapp/application/modules/webreport/configs/

    cp ${targetV3_conf_path}/ct.ini ${targetV3_path}/webapp/application/modules/ct/configs/

    cp /home/${username}/mAnalytics/softwares/test.php ${targetV3_path}/webapp/public/
    create_dir "/home/${username}/share/idea/ideatpl/"
}
function update_mysql() {
    echo 'update mysql'
    cd ${TARGET_PATH}/mysql
    create_dir 'etc'
    cp ${SRC_PATH}/my.cnf etc/my.cnf
}
update_userpath
update_mysql
update_apache
update_php
update_targetV3
