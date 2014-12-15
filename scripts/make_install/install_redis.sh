#!/usr/bin/env bash

username=`whoami`
SOFT_PATH="/home/${username}/mAnalytics/softwares"
TARGET_PATH="/home/${username}/local"
cd /tmp && tar zxvf {SOFT_PATH}/redis-2.4.15.tgz
cp -rf /tmp/redis-2.4.15 ${TARGET_PATH}/redis
