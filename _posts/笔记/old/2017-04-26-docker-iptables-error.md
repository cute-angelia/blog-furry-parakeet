---
title: Docker IPTables and the No-Chain Error
date: 2017-04-26 11:11:43
tags: [docker]
---

 > errors such as “failed programming external connectivity … iptables: No chain/target/match by that name”
 
 查看下 `iptables -L`
 
 发现并没有 `Chain DOCKER` 相关配置 ....
 
 简单解决办法:
 
 重启 docker 服务, `iptables` 会自动重建规则
