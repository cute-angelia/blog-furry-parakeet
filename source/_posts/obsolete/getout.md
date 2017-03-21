---
title: Digital Ocean账号 SSH + myentunnel 翻墙
date: 2014-11-18 16:13:21
tags: [ss]
---

update: 2016-09-13

[ss](http://n.aacc.in/ss)

<!--more-->

## SSH翻墙

### 说明

首先用`ssh`工具连接账号,此时是socks数据,需要第三方软件转化


#### SSH登录工具

* [MyEntunnel](http://www.colafile.com/file/2563134)
* [Tunnelier](http://www.colafile.com/file/2563126)


#### socks转化http工具

* [Privoxy for IE](http://www.colafile.com/file/2563123)
* Proxy SwitchSharp for Chrome
* Autoproxy For Firefox

<!-- more -->

### Privoxy
> Privoxy是一款带过滤功能的代理服务器，针对HTTP、HTTPS协议，经常跟Tor组合使用。通过Privoxy的超级过滤功能，用户从而可以保护隐私、对网页内容进行过滤、管理cookies，以及拦阻各种广告等。Privoxy可以用作单机，也可以应用到多用户的网络。

> 在这里我们仅使用它的 socks 转换功能，将 socks 转换为 IE 可用的 http 方式。运行 Privoxy 后，点击 Options > Edit Main Configurationg 打开配置文件，找到 5.2. forward-socks4, forward-socks4a and forward-socks5 下的语句（大概在1257行）：

将
````
# forward-socks5 / 127.0.0.1:9050 .
````
修改为

````
forward-socks5 / 127.0.0.1:7070 .
````

注意：去掉 # 符号，修改 9050 为你需要的端口，如 7070

这样，我们就配置好了 Privoxy，可以用了：127.0.0.1:8118

### SSH
> SSH为Secure Shell的缩写，由IETF的网络工作小组（Network Working Group）所制定；SSH为创建在应用层和传输层基础上的安全协议。SSH是目前较可靠，专为远程登录会话和其他网络服务提供安全性的协议。利用SSH协议可以有效防止远程管理过程中的信息泄露问题。通过SSH可以对所有传输的数据进行加密，也能够防止DNS欺骗和IP欺骗。

### 修改 hosts 访问 google

[GoGo tester测试有用googleip](http://www.colafile.com/file/2563125)

