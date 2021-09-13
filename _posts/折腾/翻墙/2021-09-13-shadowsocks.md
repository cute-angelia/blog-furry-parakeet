---
title: shadowsocks-libev 搭建
date: 2021-09-13 22:27:22
tags: [ss, BBR]
---

> 日期：2017-02-24
>
> 更新：2021-09-13
>
> 平台：Centos 7

## 最新安装

请务必使用UFW防火墙添加客户端使用的IP和SS服务的端口,如果是阿里云机器务必卸载安骑士

一键安装

```
wget --no-check-certificate https://raw.githubusercontent.com/lanlandezei/shadowsocks-libev/main/install.sh && chmod +x install.sh && bash install.sh
```

使用 `snap` 安装

```bash
# install snap

# Adding EPEL to CentOS 8
dnf install epel-release
dnf upgrade

# Adding EPEL to CentOS 7
yum install epel-release

# install
yum install snapd -y
systemctl enable --now snapd.socket

# install shadowsocks
snap install shadowsocks-libev --edge

vim /var/snap/shadowsocks-libev/common/etc/shadowsocks-libev/config.json

# 修改配置端口
# 使用下面推荐配置

# 启动
systemctl start snap.shadowsocks-libev.ss-server-daemon.service
systemctl restart snap.shadowsocks-libev.ss-server-daemon.service && systemctl status snap.shadowsocks-libev.ss-server-daemon.service

# 查看状态
systemctl status snap.shadowsocks-libev.ss-server-daemon.service

# 开机启动
systemctl enable snap.shadowsocks-libev.ss-server-daemon.service

# 排查错误
journalctl -u snap.shadowsocks-libev.ss-server-daemon.service

# alias
snap alias shadowsocks-libev.ss-server ss-server
```

推荐的Shadowsocks-libev服务器配置

```
{
    "server":["::0","0.0.0.0"],
    "server_port":4433,
    "encryption_method":"chacha20-ietf-poly1305",
    "password":"55hrNuBSPjnm9r0R0tHgSw==",
    "mode":"tcp_only",
    "fast_open":false
}
```

[snap install shadowsocks]: https://gfw.report/blog/ss_tutorial/zh/	"如何部署一台抗封锁的Shadowsocks-libev服务器"

------

### 旧版2017安装

两行代码快速安装, 注意系统装 `centos 7`

```bash
wget --no-check-certificate -O shadowsocks-libev.sh https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-libev.sh

chmod +x shadowsocks-libev.sh && ./shadowsocks-libev.sh

# 卸载
./shadowsocks-libev.sh uninstall

# 使用命令
启动：/etc/init.d/shadowsocks start
停止：/etc/init.d/shadowsocks stop
重启：/etc/init.d/shadowsocks restart
查看状态：/etc/init.d/shadowsocks status

```



其他

> [锐速](https://www.91yun.org/serverspeeder91yun) > [BBR TCP 网络优化](/2018/03/28/BBR.html)

### 优化

1. 主要通过第一次 TCP 握手后服务器产生 Cookie 作为后续 TCP 连接的认证信息，客户端通过 TCP 再次连接到服务器时，可以在 SYN 报文携带数据(RFC793)，降低了握手频率，可避免恶意攻击并大幅降低网络延迟(参考)

```
echo "net.ipv4.tcp_fastopen = 3" >> /etc/sysctl.conf
sysctl -e -p
```

2. 改善 TCP 拥塞算法

HTTP 协议在传输层使用 TCP 协议，TCP 丢包重传机制算法的不同会大幅影响科学上网速度；

```
vim /etc/sysctl.conf
net.ipv4.tcp_congestion_control = bbr 这一行(若没有请手动添加)
net.core.default_qdisc = fq
#将网络拥塞队列算法设置为性能和延迟最佳的fq_codel

sysctl -e -p

其后接的算法主要有 cubic,hybla,bbr 等
cubic  #由bic算法衍化而来，适用于低丢包率网络
hybla  #卫星链路使用的算法，适用于高延迟，高丢包率的网络
bbr    #由Google开源的算法，适用于低延迟，较低丢包率的网络(需要手动配置*)
```

3. 内核优化

```
vim sysctl.conf

fs.file-max = 1024000
#系统所有进程一共可以打开的句柄数(bytes)
kernel.msgmnb = 65536
#进程通讯消息队列的最大字节数(bytes)
kernel.msgmax = 65536
#进程通讯消息队列单条数据最大的长度(bytes)
kernel.shmmax = 68719476736
#内核允许的最大共享内存大小(bytes)
kernel.shmall = 4294967296
#任意时间内系统可以使用的共享内存总量(bytes)

```

编辑和写入如下代码，限制用户档案的体积大小，提高系统稳定性，完成后保存

```
vim /etc/security/limits.conf

*                soft    nofile           512000
#用户档案警告体积大小(bytes)
*                hard    nofile          1024000
#用户档案最大体积大小(bytes)

```

4. TCP 的各种优化

```
vim sysctl.conf

net.core.rmem_max = 12582912
#设置内核接收Socket的最大长度(bytes)
net.core.wmem_max = 12582912
#设置内核发送Socket的最大长度(bytes)
net.ipv4.tcp_rmem = 10240 87380 12582912
#设置TCP Socket接收长度的最小值，预留值，最大值(bytes)
net.ipv4.tcp_rmem = 10240 87380 12582912
#设置TCP Socket发送长度的最小值，预留值，最大值(bytes)
net.ipv4.ip_forward = 1
#开启所有网络设备的IPv4流量转发，用于支持IPv4的正常访问
net.ipv4.tcp_syncookies = 1
#开启SYN Cookie，用于防范SYN队列溢出后可能收到的攻击
net.ipv4.tcp_tw_reuse = 1
#允许将等待中的Socket重新用于新的TCP连接，提高TCP性能
net.ipv4.tcp_tw_recycle = 0
#禁止将等待中的Socket快速回收，提高TCP的稳定性
net.ipv4.tcp_fin_timeout = 30
#设置客户端断开Sockets连接后TCP在FIN等待状态的实际(s)，保证性能
net.ipv4.tcp_keepalive_time = 1200
#设置TCP发送keepalive数据包的频率，影响TCP链接保留时间(s)，保证性能
net.ipv4.tcp_mtu_probing = 1
#开启TCP层的MTU主动探测，提高网络速度
net.ipv4.conf.all.accept_source_route = 1
net.ipv4.conf.default.accept_source_route = 1
#允许接收IPv4环境下带有路由信息的数据包，保证安全性
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
#拒绝接收来自IPv4的ICMP重定向消息，保证安全性
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.lo.send_redirects = 0
#禁止发送在IPv4下的ICMP重定向消息，保证安全性
net.ipv4.conf.all.rp_filter = 0
net.ipv4.conf.default.rp_filter = 0
net.ipv4.conf.lo.rp_filter = 0
#关闭反向路径回溯进行源地址验证(RFC1812)，提高性能
net.ipv4.icmp_echo_ignore_broadcasts = 1
#忽略所有ICMP ECHO请求的广播，保证安全性
net.ipv4.icmp_ignore_bogus_error_responses = 1
#忽略违背RFC1122标准的伪造广播帧，保证安全性
net.ipv6.conf.all.accept_source_route = 1
net.ipv6.conf.default.accept_source_route = 1
#允许接收IPv6环境下带有路由信息的数据包，保证安全性
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
#禁止接收来自IPv6下的ICMPv6重定向消息，保证安全性
net.ipv6.conf.all.autoconf = 1
#开启自动设定本地连接地址，用于支持IPv6地址的正常分配
net.ipv6.conf.all.forwarding = 1
#开启所有网络设备的IPv6流量转发，用于支持IPv6的正常访问
```
