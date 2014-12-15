#!/usr/bin/env bash

username=`whoami`
SOFT_PATH="/home/${username}/mAnalytics/softwares"
TARGET_PATH="/home/${username}/local"
cd /tmp && tar zxvf ${SOFT_PATH}/ct-tracker.tgz
cp -rf /tmp/ct-tracker ${TARGET_PATH}/
