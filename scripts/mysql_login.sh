#!/usr/bin/env bash

action=$1

case $action in
    "root" )
        ~/local/mysql/bin/mysql -uroot -p123456
        ;;
    "yyttest" )
        ~/local/mysql/bin/mysql -uyyttest -pAbc@123
        ;;
    *)
        echo -e "Used to login to mysql database. \nUsage:
        sh mysql_login.sh username"
esac