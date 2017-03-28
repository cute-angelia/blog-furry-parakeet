---
title: PHP中 HTTP_HOST 和 SERVER_NAME 的区别
date: 2013-03-18 16:25:02
tags: [php]
---

相同点：

    当满足以下三个条件时，两者会输出相同信息。
    
    1.服务器为80端口
    2.apache的conf中ServerName设置正确
    3.HTTP/1.1协议规范

不同点：

1. 通常情况：
    _SERVER["HTTP_HOST"] 在HTTP/1.1协议规范下，会根据客户端的HTTP请求输出信息。
    _SERVER["SERVER_NAME"] 默认情况下直接输出`apache` `nginx`的配置文件中的ServerName值。

2. 当服务器为非80端口时：
    _SERVER["HTTP_HOST"] 会输出端口号，例如：localhost:8080
    _SERVER["SERVER_NAME"] 会直接输出`ServerName`值
    因此在这种情况下，可以理解为：HTTP_HOST = SERVER_NAME : SERVER_PORT

3. 当配置文件中的ServerName与HTTP/1.0请求的域名不一致时：

    httpd.conf配置如下：

    ````
    <virtualhost *>
        ServerName abc.cn bcd.cn
        ServerAlias www.abc.cn
    </virtualhost>
    ````
    客户端访问域名
    _SERVER["HTTP_HOST"] 输出真实的 abc.cn 或者  bcd.cn
    _SERVER["SERVER_NAME"] 输出第一个 abc.cn

所以，在实际程序中，应尽量使用_SERVER["HTTP_HOST"] ，比较保险和可靠。