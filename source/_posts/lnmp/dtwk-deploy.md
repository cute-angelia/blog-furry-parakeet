title: DTWK部署笔记
date: 2015-02-11 04:03:30
tags: [dtwk, note]
---

## 搭建环境

* Ubuntu 12.04.5 LTS
* Apache：2
* Mysql：5.6
* Redis：2.8.19
* Zmq：4.0.4
* PHP：5.6
* Git：--

<!-- more -->

## Apache2

````
    sudo apt-get install apache2
    sudo a2enmod rewrite

````

## Mysql

````
    sudo apt-get install mysql-server
    sudo netstat -tap | grep mysql
    sudo service mysql start

````

## Redis

````
    wget http://download.redis.io/releases/redis-2.8.19.tar.gz
    tar -zxvf redis-2.8.19.tar.gz 
    cd redis-2.8.19
    make
    make test
    make install
    cp redis.conf /etc
    vim /etc/redis.conf 
    #编辑 bindip 和 后台守护
    redis-service /etc/redis.conf
````

## Zmq

[下载地址](http://zeromq.org/area:download)

````
    tar -xvf zeromq-4.0.4.tar
    cd zeromq-4.0.4
    ./configure
    make
    sudo make install
    
    sudo apt-get install php5-dev php-pear
    sudo pecl install zmq-beta
    
    sudo vim /etc/php5/apache2/php.ini  
    or 
    sudo vim /etc/php5/conf.d/20-zmq.ini and put "extension=zmq.so"
    
    sudo service apache2 reload
````


## Php5.6

````
    sudo add-apt-repository ppa:ondrej/php5-5.6
    
    sudo apt-get update
    sudo apt-get install python-software-properties
    
    sudo apt-get update
    
    sudo apt-get install php5
    
    
    sudo apt-get install curl libcurl3 libcurl3-dev php5-curl
    sudo apt-get install php5-mcrypt
    sudo apt-get install libapache2-mod-php5 php5-gd php5-mysql php5-redis
````

## Git

````
    sudo apt-get install git
    
    #ssh-keygen -t rsa -C "rose1988.c@gmail.com"
    #cat ~/.ssh/id_rsa.pub
    
    chown -R www-data xxx
    su www-data
    git clone -b test git@..git
````


## Other

````
    vipw  查看用户  
    usermod -s /bin/bash username  修改用户可登陆 比如 www-data
    netstat -atunp 查看端口号
    lsof -i:1521 根据端口号来查看进程号
    chown -R www-data xxx 修改用户组
````

