#!/usr/bin/env bash

username=`whoami`
SOFT_PATH="/home/${username}/mAnalytics/softwares"
SRC_PATH="/home/${username}/tmp/make"
TARGET_PATH="/home/${username}/local"

function create_dir() {
    myPath=$1
    if [ ! -d "$myPath" ]; then
        mkdir -p "$myPath"
    fi
}
function start_memcached(){
    proc_name="memcached"
    echo "start ${proc_name}..."
    cd ${TARGET_PATH}/memcached
    create_dir logs
    nohup bin/memcached -m 512  -u work -c 100 -p 11211 >/dev/null 2>> logs/memcached11211.log &
    nohup bin/memcached -m 512  -u work -c 100 -p 11212 >/dev/null 2>> logs/memcached11212.log &
}

function start_mysql(){
    proc_name="mysql"
    echo "start ${proc_name}..."
    cd ${TARGET_PATH}/mysql
    create_dir 'var' && create_dir 'data'
    nohup bin/mysqld_safe  --defaults-file=etc/my.cnf &
}

function start_redis(){
    proc_name="redis"
    echo "start ${proc_name}..."
    cd ${TARGET_PATH}/redis
    bin/redis-server redis.conf
}

function start_mongodb(){
    proc_name="mongodb"
    echo "start ${proc_name}..."
    cd ${TARGET_PATH}/mongodb
    bin/mongod --dbpath=data/ --logpath=logs/mongod.log --logappend &
}

function start_apache(){
    proc_name="apache"
    echo "start ${proc_name}..."
    cd ${TARGET_PATH}/apache
    create_dir logs/online
    bin/apachectl start
}

function start_ct_tracker() {
    if [ -d "${TARGET_PATH}/ct-tracker/bin" ]; then
        proc_name="ct-tracker"
        echo "start ${proc_name}..."
        cd ${TARGET_PATH}/ct-tracker/bin
        sh start.sh
    fi
}

function start_ct_slave() {
    if [ -d "${TARGET_PATH}/ct-slave/bin" ]; then
        proc_name="ct-slave"
        echo "start ${proc_name}..."
        cd ${TARGET_PATH}/ct-slave/bin
        sh start.sh
    fi
}
start_memcached && start_redis && start_mongodb && start_mysql && start_apache && start_ct_tracker && start_ct_slave