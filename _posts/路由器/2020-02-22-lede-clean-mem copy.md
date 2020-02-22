---
title: LEDE / OPENWRT 自动清理内存
tags: [lede, openwrt]
---

OPENWRT 自动清理内存,lede 自动清理内存

使用 OPENWRT/LEDE 做`aria2`下载，然后就是使用`samba`, `dlna`，共享文件给电视，看电影，也就是做一个家庭媒体中心，不过有些路由器系统中`SAMBA`共享看电影的时候，内存不断的下降，虽然本质是 LINUX 系统的路由，内存管理方式和 WIN 不一样，但是经过观察，确实不会恢复内存，而且低于 100 后，系统会变慢，登录路由反应都很慢。所以还是有必要自动清理内存。方法如下：

1. 建立 SH 脚本文件填入如下命令：

`$free -le 1846000` 这个数字，个人建议是总量的一半

脚本第一个 log > 为覆盖， 防止日志爆炸

```
#!/bin/sh

used=`free -m | awk 'NR==2' | awk '{print $3}'`
free=`free -m | awk 'NR==2' | awk '{print $4}'`

echo "===========================" > /var/log/mem.log
date >> /var/log/mem.log
echo "Memory usage | [Use：${used}KB][Free：${free}KB]" >> /var/log/mem.log

if [ $free -le 1846000 ] ; then
sync && echo 1 > /proc/sys/vm/drop_caches
sync && echo 2 > /proc/sys/vm/drop_caches
sync && echo 3 > /proc/sys/vm/drop_caches
echo "OK" >> /var/log/mem.log
else
echo "Not required" >> /var/log/mem.log
fi
```

保存后，放在路由器上，例如保存为以下路径：/root/memclean.sh

2. 加入任务

修改 /etc/crontabs/root 文件，添加一行, 表示 50 分钟检测一次内存余量，低于 1.8G 就清理！！

```
*/50 * * * * /root/memclean.sh
```
