#!/bin/bash

##############################################################
#build all software required by uc-*.
#
#include:
#       xml     libxml2-2.6.26.tar.gz
#       zlib    zlib-1.2.3.tar.gz
#       mcript  libmcrypt-2.5.7.tar.gz
#       png     libpng-1.2.8-config.tar.gz
#       jpeg    libjpeg-6b.tar.gz
#       freetype        freetype-2.3.9.tar.gz
#       gd      gd-2.0.33.tar.gz
#       php     php-5.2.4.tar.gz
#       memcached       memcache-2.2.6.tgz
#       apc     APC-3.0.16.tar
#
#@version 1.0
#@author fushiguang <larryfu@stonesun-tech.com>, revised by chookin
#@access public
##############################################################

# dir config
username=`whoami`
SOFT_PATH="/home/${username}/mAnalytics/softwares"
SRC_PATH="/home/${username}/tmp/make"
TARGET_PATH="/home/${username}/local"

S_PHP_PATH=$SRC_PATH/php-5.3.8
S_APC_PATH=$SRC_PATH/APC-3.1.6
S_GD_PATH=$SRC_PATH/gd-2.0.33
S_JPEG_PATH=$SRC_PATH/jpeg-6b
# S_PNG_PATH=$SRC_PATH/libpng-1.6.15
S_PNG_PATH=$SRC_PATH/libpng-1.2.8-config
S_XML_PATH=$SRC_PATH/libxml2-2.6.26
S_MEM_PATH=$SRC_PATH/memcache-2.2.6
S_ZLIB_PATH=$SRC_PATH/zlib-1.2.3
S_LIBMCRYPT_PATH=$SRC_PATH/libmcrypt-2.5.8
S_FREETYPE_PATH=$SRC_PATH/freetype-2.3.9


#install target dir config
T_APACHE_PATH=$TARGET_PATH/apache
T_PHP_PATH=$TARGET_PATH/php
T_GD_PATH=$TARGET_PATH/gd
T_JPEG_PATH=$TARGET_PATH/jpeg
T_PNG_PATH=$TARGET_PATH/libpng
T_XML_PATH=$TARGET_PATH/libxml2
T_ZLIB_PATH=$TARGET_PATH/zlib
T_FREETYPE_PATH=$TARGET_PATH/freetype
T_MYSQL_PATH=$TARGET_PATH/mysql
T_LIBMCRYPT_PATH=$TARGET_PATH/with-mcrypt

function stepNotice(){
    msg="";
    if [ $# -gt 0 ]; then
        msg=$1
    fi
    echo ".Process{$msg}..................................................."
    echo "pre task finished, press key 'q' to exit: "
    read num

    if [ ${num}x = "q"x ]; then
            exit
    else
            echo ".Continue...................................................."
    fi
}
function unzip_all(){
    cd $SRC_PATH
    tar -xvf ${SOFT_PATH}/APC-3.1.6.tgz
    tar -zxf ${SOFT_PATH}/libmcrypt-2.5.8.tar.gz
    tar -zxf ${SOFT_PATH}/libjpeg-6b.tar.gz
    tar -zxf ${SOFT_PATH}/libxml2-2.6.26.tar.gz
    tar -zxf ${SOFT_PATH}/memcache-2.2.6.tgz
    tar -zxf ${SOFT_PATH}/php-5.3.8.tar.gz
    tar -zxf ${SOFT_PATH}/zlib-1.2.3.tar.gz
    tar -zxf ${SOFT_PATH}/freetype-2.3.9.tar.gz
    # tar -zxf ${SOFT_PATH}/libpng-1.6.15.tar.gz
    tar -zxf ${SOFT_PATH}/libpng-1.2.8-config.tar.gz
    tar -zxf ${SOFT_PATH}/gd-2.0.33.tar.gz
    echo 'unzip all the files done.'
}


function install_libxml(){
    cd $S_XML_PATH
    ./configure --prefix=$T_XML_PATH
    make
    make install

    stepNotice "install libxml finished"
}
function install_zlib(){
    cd $S_ZLIB_PATH
    make clean
    ./configure --prefix=$T_ZLIB_PATH
    CFLAGS='-fPIC -O3 -DUSE_MMAP'
    sed < Makefile "
    /^CFLAGS *=/s#=.*#=$CFLAGS#
    " > Makefile.new
    rm Makefile
    mv Makefile.new Makefile
    make
    make install

    stepNotice "install zlib finished"
}
function install_libmcrypt(){
    cd $S_LIBMCRYPT_PATH
    ./configure --prefix=$T_LIBMCRYPT_PATH
    make
    make install

    stepNotice "install libmcrypt finished"
}
function install_libpng(){
    cd $S_PNG_PATH
    ./configure --prefix=$T_PNG_PATH
    make
    make install

    stepNotice "install libpng finished"
}

function install_jpeg(){
    cd $S_JPEG_PATH
    make clean
    ./configure --prefix=$T_JPEG_PATH --enable-shared --enable-static

    echo "fix makefile..../libtool->libtool"
    sed < Makefile "/^LIBTOOL = *\.\/libtool/s%=.*%= libtool%" > Makefile.new
    mv Makefile.new Makefile

    mkdir -p $T_JPEG_PATH/include
    mkdir -p $T_JPEG_PATH/lib
    mkdir -p $T_JPEG_PATH/bin
    mkdir -p $T_JPEG_PATH/man/man1
    make
    make install
    stepNotice "install jpeg finished"
}
function install_freetype() {
    cd $S_FREETYPE_PATH
    make clean
    ./configure --prefix=$T_FREETYPE_PATH
    make
    make install
    stepNotice "install freetype finished"
}
function install_gd() {
    cd $S_GD_PATH
    make clean
    ./configure --prefix=$T_GD_PATH --enable-shared --enable-static --with-freetype=$T_FREETYPE_PATH
    make
    make install
    stepNotice "install gd finished"
}

function install_php(){
    cd $S_PHP_PATH
    make clean
    ./configure --prefix=$T_PHP_PATH --with-libxml-dir=$T_XML_PATH --with-mcrypt=$T_LIBMCRYPT_PATH --with-zlib-dir=$T_ZLIB_PATH --with-apxs2=$T_APACHE_PATH/bin/apxs --with-mysql=$T_MYSQL_PATH --enable-soap --enable-iconv --enable-track-vars --with-gd=$T_GD_PATH --with-jpeg-dir=$T_JPEG_PATH --with-freetype-dir=$T_FREETYPE_PATH --enable-ftp --enable-sockets --enable-wddx --enable-mbstring --enable-dom --with-pdo-mysql=$T_MYSQL_PATH --enable-shmop
    make
    make install
    stepNotice "install php finished"
}


function install_memcache(){
    cd $S_MEM_PATH
    make clean
    $T_PHP_PATH/bin/phpize
    ./configure --enable-memcache --with-php-config=$T_PHP_PATH/bin/php-config
    make
    make install

    stepNotice "install memcached finished"
}

function install_apc(){
    cd $S_APC_PATH
    make clean
    $T_PHP_PATH/bin/phpize
    ./configure --enable-apc-mmap --with-apxs=$T_APACHE_PATH/bin/apxs --with-php-config=$T_PHP_PATH/bin/php-config
    make
    make install

    stepNotice "install apc finished"
}

function install_redis() {
    cp ${SOFT_PATH}/redis.so ${TARGET_PATH}/php/lib/php/extensions/no-debug-non-zts-20090626/
    stepNotice "install redis finished"
}

function install_xdebug() {
    cd $SRC_PATH
    tar zxvf ${SOFT_PATH}/xdebug-2.2.6.tgz
    cd xdebug-2.2.6
    $T_PHP_PATH/bin/phpize
    ./configure  --with-php-config=$T_PHP_PATH/bin/php-config
    make
    make install

}
mkdir -p ${SRC_PATH}
unzip_all
install_libxml
install_zlib
install_libmcrypt
install_libpng
install_jpeg
install_freetype
install_gd
install_php
install_memcache
install_apc
install_redis
install_xdebug