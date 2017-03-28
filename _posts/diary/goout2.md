---
title: 公司翻墙环境搭建
date: 2016-09-21 16:13:21
tags: [ss]
---

## 说明

因业务需要,经常访问国外一些网站,需要搭建一套翻墙环境,仅供学习参考

![one](http://ww4.sinaimg.cn/large/7853084cgw1f815z29smaj21kw0pqwhm.jpg)

![two](http://ww3.sinaimg.cn/large/7853084cgw1f815xu4j0yj21kw0vjwik.jpg)

<!-- more -->

### 环境搭建

基于 `centos6`

### 前端

利用开源 `ss-spanel` 搭建

### 后端LNMP

*  **数据库**

> 注意数据库编码, 查看 `show variables like 'character_set_%'`
  如果不是`utf8`, 修改配置文件 `/etc/my.conf`

按照 `ss-spanel` 提供的数据库导入

创建用户

````
grant all privileges  on *.* to admin@'%' identified by "123456";
flush privileges;
````

* nginx

* php

#### shadowsocks manyuser branch

[shadowsocks manyuser](https://github.com/mengskysama/shadowsocks/tree/manyuser)


````
yum install -y python-setuptools && easy_install pip
pip install cymysql

git clone -b manyuser https://github.com/mengskysama/shadowsocks.git
yum install m2crypto -y
or apt-get install python-m2crypto
````

配置

````
cd shadowsocks
vim Config.py

#Config
MYSQL_HOST = '练db,开放授权'
MYSQL_PORT = 3306
MYSQL_USER = 'ss'
MYSQL_PASS = 'ss'
MYSQL_DB = 'shadowsocks'

MANAGE_PASS = 'ss233333333'
#if you want manage in other server you should set this value to global ip
MANAGE_BIND_IP = '127.0.0.1'
#make sure this port is idle
MANAGE_PORT = 23333
````

守护启动

1. pm2
2. supervisord

个人倾向 `pm2`

````
vim ss.sh

#!/bin/bash
python /opt/src/shadowsocks/shadowsocks/server.py -c /opt/src/shadowsocks/shadowsocks/config.json

pm2 start ss.sh

````

下面是 `supervisord`

安装 `supervisord`

````
pip install pyopenssl ndg-httpsclient pyasn1
pip install supervisord
````

配置

````
vim /etc/super.conf

[supervisord]
nodaemon=false

[program:code]
command=python /opt/src/shadowsocks/shadowsocks/server.py
````

开机启动

````
vim /etc/rc.d/rc.local
supervisord -c /etc/super.conf
````