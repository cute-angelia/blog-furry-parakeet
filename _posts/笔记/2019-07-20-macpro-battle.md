---
title: MacBook Pro休眠掉电、耗电量大问题解决方案
tags: [mac]
---


设备: 2015mbpMacBook Pro (Retina, 13-inch, early 2015)
系统: 10.14
现象: 关盖后掉电

### 电池使用记录

`pmset -g log`


### 系统偏好设置->节能->电池

要求 sleep >= displaysleep，可以在 “系统偏好设置->节能->电池” 中设置，把时间改成5分钟（反正要大于 2，默认为 2 分钟）


### 关闭 kcp 唤醒

`sudo pmset -b tcpkeepalive 0`

### 设置电池模式休眠模式为

`pmset -b hibernatemode 25`
