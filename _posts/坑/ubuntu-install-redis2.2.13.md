title: Ubuntu 安装启动redis2.2.13
date: 2013-01-30 10:13:45
tags: [redis]
---

## 1、下载安装
    cd /tmp
    wget http://redis.googlecode.com/files/redis-2.2.13.tar.gz
    tar -zxf redis-2.2.13.tar.gz
    cd redis-2.2.13
    make
    sudo make install

这时Redis 的可执行文件被放到了/usr/local/bin

<!-- more -->

## 2、下载配置文件和init启动脚本：

    wget https://github.com/ijonas/dotfiles/raw/master/etc/init.d/redis-server
    wget https://github.com/ijonas/dotfiles/raw/master/etc/redis.conf
    sudo mv redis-server /etc/init.d/redis-server
    sudo chmod +x /etc/init.d/redis-server
    sudo mv redis.conf /etc/redis.conf

## 3、初始化用户和日志路径

第一次启动Redis前，建议为Redis单独建立一个用户，并新建data和日志文件夹

    sudo useradd redis
    sudo mkdir -p /var/lib/redis
    sudo mkdir -p /var/log/redis
    sudo chown redis.redis /var/lib/redis
    sudo chown redis.redis /var/log/redis

## 4、设置开机自动启动，关机自动关闭

    sudo update-rc.d redis-server defaults

## 5、启动Redis：

    sudo /etc/init.d/redis-server start

## 6、启动client客户端连接:

    $ redis-cli
    redis> set bendan wen
    OK
    redis> get bendan
    "wen"

转载[ubuntu安装启动redis](http://www.cnblogs.com/viaivi/archive/2011/12/08/2281319.html)