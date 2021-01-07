---
title: 在CentOS搭建环境笔记
date: 2015-07-08 04:02:17
update: 2015-11-05 04:02:17
tags: [linux]
---

## 搭建环境

* Linux：Centos 6.5
* Nginx：1.9.2
* Mysql：5.6
* PHP：5.6
* Redis：3.0
* Swoole
* Ftp
* Memcached

<!-- more -->

## 先增加两个账号和组

    groupadd mysql
    useradd -g mysql mysql -s /bin/false
    groupadd www
    useradd -g www www -s /bin/false

## Nginx

### 安装：

Nginx：1.9.2

地址：[http://nginx.org/download/nginx-1.9.2.tar.gz](http://nginx.org/download/nginx-1.9.2.tar.gz)

````
    tar -zxvf nginx-1.9.2.tar.gz
    cd nginx-1.9.2 # 切换到源码目录
    
    ./configure  \
    --prefix=/opt/app/nginx \
    --pid-path=/opt/app/nginx/var/run \
    --user=www \
    --group=www \
    --with-pcre \
    --with-http_stub_status_module \
    --with-http_ssl_module \
    --with-http_gzip_static_module
    make && make install
    ./sbin/nginx
````
    
    
### 设置

#### 下载启动脚本

[http://wiki.nginx.org/RedHatNginxInitScript](http://wiki.nginx.org/RedHatNginxInitScript) 

↓↓↓

`/etc/init.d/nginx`
    
#### 编辑 /etc/init.d/nginx 文件

````
    vim /etc/init.d/nginx
    
    nginx="/usr/sbin/nginx"
    ↓↓↓
    nginx="/opt/app/nginx/sbin/nginx"
    
````

#### 最新版本centos7脚本用systemd管理

[https://www.nginx.com/resources/wiki/start/topics/examples/systemd/](https://www.nginx.com/resources/wiki/start/topics/examples/systemd/)

#### 移动配置文件

````
    cd /opt/app/nginx/
    cp ./conf/. /etc/nginx/ -r #可以不转移
````

#### 赋予权限

````
    chmod +x /etc/init.d/nginx
````

### 启动

````
    /etc/init.d/nginx start
````

### 常见错误

> /configure: error: the HTTP rewrite module requires the PCRE library.
 
    yum -y install pcre-devel openssl openssl-devel
    
    
### 优化配置

[高流量站点NGINX与PHP-fpm配置优化（译）](http://youngsterxyf.github.io/2014/05/03/optimizing-nginx-and-php-fpm-for-high-traffic-sites/)


## Mysql

### 安装

下载地址：[http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.25.tar.gz](http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.25.tar.gz)

````
    cd /opt/src
    yum -y install cmake
    wget http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.25.tar.gz
    tar zxvf mysql-5.6.25.tar.gz
    cd mysql-5.6.25
    
    cmake \
    -DCMAKE_INSTALL_PREFIX=/opt/app/mysql \
    -DMYSQL_DATADIR=/opt/app/mysql/data \
    -DWITH_MYISAM_STORAGE_ENGINE=1 \
    -DWITH_INNOBASE_STORAGE_ENGINE=1 \
    -DWITH_MEMORY_STORAGE_ENGINE=1 \
    -DWITH_READLINE=1 \
    -DMYSQL_TCP_PORT=3306 \
    -DENABLED_LOCAL_INFILE=1 \
    -DWITH_PARTITION_STORAGE_ENGINE=1 \
    -DEXTRA_CHARSETS=all \
    -DDEFAULT_CHARSET=utf8 \
    -DDEFAULT_COLLATION=utf8_general_ci
    	
    make && make install
    
    ↑↑↑漫长的等待....

    # 初始化数据
    cd /opt/app/mysql
    chown -R mysql .
    chgrp -R mysql .

    chmod +x ./scripts/mysql_install_db
    ./scripts/mysql_install_db --user=mysql --basedir=/opt/app/mysql

    # 运行
    chmod +x ./bin/mysqld_safe
    mkdir /var/log/mariadb/
    ./bin/mysqld_safe --user=mysql &
    
    # 配置
    cp -f support-files/mysql.server /etc/init.d/mysqld
    chmod +x  /etc/init.d/mysqld
    
    cp -f support-files/my-default.cnf /etc/my.cnf
        ↓↓↓
        #basedir = /opt/app/mysql
        #datadir = /opt/app/mysql/data
        #log-error = /var/log/mysql/mysql_error.log
        #pid-file = /var/log/mysql/mysql.pid
    
    # 开机启动
    chkconfig --add mysqld
    chkconfig --level 3 mysqld on
    
    # 设置root账号
    ./bin/mysqladmin -u root password 'xxxxxxxx'
    
    # 把mysql客户端放到默认路径
    ln -s /opt/app/mysql/bin/mysql /usr/bin/mysql
    
    # 64位要使用/usr/lib64/
    ln -s /opt/app/mysql/lib/libmysqlclient.so.18 /usr/lib64/
    ln -s /opt/app/mysql/lib/libmysqlclient.so /usr/lib64/

````

### 创建账号

````
    mysql -uroot -p

    # 创建普通用户
    CREATE USER 'hello'@'localhost' IDENTIFIED BY '123456';
    GRANT ALL ON hello_db.* TO 'hello'@'localhost';
    grant create, alter, drop, references, index, select, insert, update, delete on testdb.* to common_user@'%'
    
    # 创建某ip管理员
    grant all privileges on *.* to 'admin'@'60.x.x.9' identified by "!@#";
    
    # 创建某ip管理员并有grant权限, 需重启mysqld
    grant all privileges on *.* to 'admin'@'60.x.x.9' identified by "!@#" with grant option;
    
    # flush
    flush privileges;
    
````

[MySQL的Grant命令](http://www.cnblogs.com/hcbin/archive/2010/04/23/1718379.html)

### 常见错误

> cmake 需要的包

````
    yum install gcc-c++
    yum install ncurses-devel
````

> cmake 清理缓存

````
rm -f CMakeCache.txt
````

> 内存不足

````
2016-03-07 09:06:56 29646 [Note] InnoDB: Initializing buffer pool, size = 128.0M
InnoDB: mmap(137363456 bytes) failed; errno 12
2016-03-07 09:06:56 29646 [ERROR] InnoDB: Cannot allocate memory for the buffer pool

key_buffer=16K
table_open_cache=4
query_cache_limit=256K
query_cache_size=4M
max_allowed_packet=1M
sort_buffer_size=64K
read_buffer_size=256K
thread_stack=64K
innodb_buffer_pool_size = 56M
````

## PHP

### 安装

相关扩展 ：curl，date，dom，ereg，fileinfo，filter，hash，httpparser
	iconv，json，libxml，mbstring，mcrypt，memcached，mongo
	mysql，mysqlnd，openssl，pcre，PDO，pdo_mysql，pdo_sqlite
	Phar，posix，protobuf，redis，Reflection，session，SimpleXML，soap
	sockets，SPL，sqlite3，standard，swoole，tokenizer
	xdebug，xml，xmlreader，xmlwriter，zip，zlib
	
````
	# 先安装依赖包
	yum -y install libmcrypt-devel mhash-devel libxslt-devel \
	libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel \
	zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel \
	ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel \
	krb5 krb5-devel libidn libidn-devel openssl openssl-devel libmcrypt-devel.x86_64 openldap-devel
	
	# libcrypt
    # 下载mcrypt
    wget ftp://mcrypt.hellug.gr/pub/crypto/mcrypt/libmcrypt/libmcrypt-2.5.7.tar.gz
    tar zxvf libmcrypt-2.5.7.tar.gz
    cd libmcrypt-2.5.7
    ./configure --prefix=/usr/local/lib/mcrypt
    make && make install
	
	# 根据硬盘挂载创建软连接
	df -h
	ln -s /home/app/ /opt/
	
	# 下载php
    wget http://cn2.php.net/get/php-5.6.11.tar.gz/from/this/mirror
    tar zxvf php-5.6.10.tar.gz
    cd php-5.6.10
    
    
    # 某些mysql装在/usr/local/下
    --with-mysql=/usr/local \
    --with-mysqli=/usr/local/bin/mysql_config \
    --with-pdo-mysql=/usr/local \
    
    ./configure  \
    --prefix=/opt/app/php \
    --with-config-file-path=/opt/app/php/etc \
    --with-mysql=/opt/app/mysql \
    --with-mysqli=/opt/app/mysql/bin/mysql_config \
    --with-pdo-mysql=/opt/app/mysql \
    --with-iconv-dir \
    --with-freetype-dir \
    --with-jpeg-dir \
    --with-png-dir \
    --with-zlib=/usr \
    --with-libxml-dir \
    --disable-rpath \
    --enable-fpm \
    --enable-bcmath \
    --enable-shmop \
    --enable-sysvsem \
    --disable-opcache \
    --with-curl \
    --enable-mbstring \
    --enable-mbregex \
    --with-gd \
    --enable-gd-native-ttf \
    --with-openssl \
    --with-mhash \
    --enable-pcntl \
    --enable-sockets \
    --enable-cli \
    --with-xmlrpc \
    --enable-exif \
    --with-gettext \
    --with-mcrypt

    # make 需要
    mkdir /ext/phar/phar.phar -p

    # 安装
    make && make install

    # 进入目录
    cd /opt/app/php

    # 配置
    cp /opt/src/php-5.6.10/php.ini-production /opt/app/php/etc/php.ini
    cp ./etc/php-fpm.conf.default ./etc/php-fpm.conf

    # 配置用户组
    vim php-fpm.conf
    user = www
    group = www
    pid = /var/run/php-fpm.pid
        
    # 配置和启动项
    cp /opt/src/php-5.6.10/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
    chmod +x /etc/init.d/php-fpm
    
    # 把php客户端放到默认路径
    ln -s /opt/app/php/bin/* /usr/local/bin/php
    
    # 启动
    /etc/init.d/php-fpm start

    # 安装扩展举例
    # *安装redis扩展*
    wget https://github.com/nicolasff/phpredis/archive/2.2.7.tar.gz
    tar zxvf phpredis-2.2.7.tar.gz
    cd phpredis-2.2.7

    /usr/local/php/bin/phpize
    ./configure --with-php-config=/opt/app/php/bin/php-config

    make && make install

    vim /opt/app/php/etc/php.ini

    extension=redis.so


    # xcache
    # wget http://xcache.lighttpd.net/pub/Releases/3.2.0/xcache-3.2.0.tar.gz
    # tar -xvf xcache-3.2.0.tar.gz
    # cd xcache-3.2.0
    # phpize
    # ./configure –with-php-config=/usr/local/bin/php-config  –enable-xcache
    # make && make install

````

### 优化

	* 查看CPU : cat /proc/cpuinfo | grep processor -c
	
	* 查看内存 ：free -m
	
	
[启用php-fpm状态详解]http://www.ttlsa.com/php/use-php-fpm-status-page-detail/

[php-fpm的配置和优化](https://www.zybuluo.com/phper/note/89081)

[在高负载的情况下的PHP-FPM调优](http://www.qixing318.com/article/in-the-case-of-high-load-of-php-fpm-tuning.html)

[PHP安全相关的配置](http://anquan.163.com/module/pedia/article-00031.html)

### 错误

> configure: error: Cannot find ldap libraries in /usr/lib
 
````
    --with-libdir=lib64
````

## Redis 3.0

地址：[http://download.redis.io/redis-stable.tar.gz](http://download.redis.io/redis-stable.tar.gz)

步骤：

````
	tar zxvf redis-stable.tar.gz
	cd redis-stable
	make PREFIX=/opt/app/redis install
	mkdir -p /opt/app/redis/etc
	mkdir -p /opt/app/redis/var
	cd /opt/app/redis/etc
	vim redis.conf
	
    # 修改配置文件
    1. 一般需要把daemonize no 改为 daemonize yes其他的看需要修改.
    2. ip 127.0.0.1 或者第三步 ,注意,ip为自身网卡ip
    3. requirepass password
	
	# 启动
	/opt/app/redis/bin/redis-server /opt/app/redis/etc/redis.conf

	# 测试
	redis-cli -h 127.0.0.1 -p 6379
	
````

## Swoole

地址：[https://github.com/swoole/swoole-src/releases](https://github.com/swoole/swoole-src/releases)

步骤：

````
	wget https://github.com/swoole/swoole-src/archive/swoole-1.8.5-stable.tar.gz
	tar zxvf swoole-1.8.5-stable.tar.gz
	cd swoole-src-swoole-1.8.5-stable

	/usr/local/php/bin/phpize
	./configure --with-php-config=/opt/app/php/bin/php-config

	make && make install

	vim /opt/app/php/etc/php.ini
    extension=swoole.so
````

## Ftp

````
	yum install vsftpd
	vim /etc/vsftpd/vsftpd.conf
	chkconfig vsftpd on
	/sbin/iptables -A INPUT -p tcp -m tcp --dport 6903 -j ACCEPT
	/sbin/iptables -A INPUT -p tcp -m tcp --dport 50000:60000 -j ACCEPT
````

## Memcached

````
    yum install libevent libevent-devel -y
    wget http://memcached.org/latest
    tar -zxvf memcached-1.x.x.tar.gz
    cd memcached-1.x.x
    ./configure --prefix=/opt/app/memcached && make && make test && sudo make install

    管理工具
    memcached-tool 127.0.0.1:11211 stats
````

ps:Makefile有-Werror让警告也不通通过编译，修改Makefile把-Werror参数去掉就可以。-Werror的意思是警告即错误，即编译过程中有警告产生就无法编译通过。而memcached的源代码也许写得不够严谨，出警告了。

如果make test时出现下面Error

    prove ./t
    make: prove: Command not found
    make: *** [test] Error 127

可以安装perl-Test*

    sudo yum install perl-Test*


[http://blog.csdn.net/yybjroam05/article/details/8651789](http://blog.csdn.net/yybjroam05/article/details/8651789)