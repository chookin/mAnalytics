#!/usr/bin/env bash

username=`whoami`
TARGET_PATH="/home/${username}/local"
function exist_process() {
    if [ $# = 0 ]; then
        echo -1
    fi

    taskid=`ps -ef | grep $1 | grep -v grep | awk -F" " '{print $2}'`
    if [ ! -z "$taskid" ];then
        echo 1
    else
        echo 0
    fi
}
function kill_process() {
    if [ $# = 0 ]; then
        return
    fi
    for proc_name in $*
    do
        taskid=`ps -ef | grep $proc_name | grep -v grep | awk -F" " '{print $2}'`
        taskid=`echo "$taskid" | tr '\n' ' '` # convert newlines into spaces
        echo "stop $proc_name, taskid is $taskid"
        if [ ! -z "$taskid" ];then
            nohup kill $taskid &
        fi
    done
}

function stop_apache() {
    proc_name="apache"
    echo "stop ${proc_name}..."

    is_exist=`exist_process ${proc_name}`
    if [ $is_exist = 1 ]; then
        cd ${TARGET_PATH}/apache && bin/apachectl stop
    fi
}
function stop_memcached() {
    proc_name="mongodb"
    echo "stop ${proc_name}..."

    is_exist=`exist_process ${proc_name}`
    if [ $is_exist = 1 ]; then
        cd ${TARGET_PATH}/mongodb && bin/mongod --dbpath=data/ --shutdown
    fi
}
function stop_mongodb() {
    kill_process mongod
}
function stop_mysql() {
    proc_name="mysql"
    echo "stop ${proc_name}..."

    is_exist=`exist_process ${proc_name}`
    if [ $is_exist = 1 ]; then
        cd ${TARGET_PATH}/mysql && bin/mysqladmin --defaults-file=etc/my.cnf  -uroot -p123456  shutdown
    fi
}
function stop_redis() {
    kill_process redis-server
}

function stop_ct_tracker() {
    if [ -d "${TARGET_PATH}/ct-tracker/bin" ]; then
        echo "stop ct-tracker"
        cd ${TARGET_PATH}/ct-tracker/bin
        sh stop.sh
    fi
}

function stop_ct_slave() {
    if [ -d "${TARGET_PATH}/ct-slave/bin" ]; then
        echo "stop ct-slave"
        cd ${TARGET_PATH}/ct-slave/bin
        sh stop.sh
    fi
}

stop_apache && stop_memcached && stop_redis && stop_mongodb && stop_mysql && stop_ct_tracker && stop_ct_slave