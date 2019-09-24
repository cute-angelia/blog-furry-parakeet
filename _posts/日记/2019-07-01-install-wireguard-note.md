![logo](https://cdn.jsdelivr.net/gh/WithdewHua/static@withdewhua-hugo/img/post/wireguard.png)

### Install

[官方文档](https://www.wireguard.com/install/)

Red Hat Enterprise Linux / CentOS

```
yum update -y
reboot # unless there were no updates

curl -Lo /etc/yum.repos.d/wireguard.repo https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo

yum install -y epel-release

yum install -y wireguard-dkms wireguard-tools

```

### 服务端 config

```
# 开启ipv4流量转发
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p

# 创建并进入WireGuard文件夹
mkdir -p /etc/wireguard && chmod 0777 /etc/wireguard
cd /etc/wireguard
umask 077

# 生成服务器和客户端密钥对
wg genkey | tee server_privatekey | wg pubkey > server_publickey
wg genkey | tee client_privatekey | wg pubkey > client_publickey

```

创建并进入了 WireGuard 后，开始配置服务端文件，输入`ifconfig`查看主网卡名称，可能结果如下：

记住以上标记处名字，若不是`eth0`，可以将其复制了待会需要用到。

生成服务器配置文件`/etc/wireguard/wg0.conf`:

```
# 重要！如果名字不是eth0, 以下PostUp和PostDown处里面的eth0替换成自己服务器显示的名字
  # ListenPort为端口号，可以自己设置想使用的数字
  # 以下内容一次性粘贴执行，不要分行执行
  echo "
  [Interface]
    PrivateKey = $(cat server_privatekey)
    Address = 10.0.0.1/24
    PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
    ListenPort = 50814
    DNS = 8.8.8.8
    MTU = 1420

  [Peer]
    PublicKey = $(cat client_publickey)
    AllowedIPs = 10.0.0.2/32 " > wg0.conf
```

设置开机自启：

```
systemctl enable wg-quick@wg0
```

启动

```
# 启动WireGuard
wg-quick up wg0

# 停止WireGuard
wg-quick down wg0

# 查看WireGuard运行状态
wg

```

### 客户端

```
# Endpoint是自己服务器ip和服务端配置文件中设置的端口号，自己在本地编辑好再粘贴到SSH里
# 以下内容一次性粘贴执行，不要分行执行
echo "
[Interface]
  PrivateKey = $(cat client_privatekey)
  Address = 10.0.0.2/24
  DNS = 8.8.8.8
  MTU = 1420

[Peer]
  PublicKey = $(cat server_publickey)
  Endpoint = 1.2.3.4:50814
  AllowedIPs = 0.0.0.0/0, ::0/0
  PersistentKeepalive = 25 " > client.conf
```

### 配置说明

```
#客户端
[Interface]
# 本机的密钥
PrivateKey = gIIBl0OHb3wZjYGqZtgzRml3wec0e5vqXtSvCTfa42w=
# 设置UDP监听端口可以让其他客户端向本机发起连接
# ListenPort = 51820
# VPN连接成功后使用的DNS服务器
# DNS = 8.8.8.8
# 拦截所有DNS请求并强制所有DNS都通过VPN
# BlockDNS = true
# 虚拟网络设备的内网IP地址
Address = 192.168.2.2/24
# 流量拦截功能，是否拦截所有未通过tunsafe的网络请求:
#  route - 使用黑洞路由阻止所有流量(直接丢弃数据包)
#  firewall - 通过Windows防火墙阻止除tunsafe外的所有流量
#  on - 使用默认拦截机制
#  off - 关闭流量拦截
# BlockInternet = route, firewall
# MTU
# MTU = 1420
#服务器配置
[Peer]
# 服务器公钥
PublicKey = hIA3ikjlSOAo0qqrI+rXaS3ZH04Yx7Q2YQ4m2Syz+XE=
# 预共享密钥
PresharedKey  =  SNz4BYc61amtDhzxNCxgYgdV9rPU+WiC8woX47Xf/2Y=
# 需要转发流量的IP范围，如果你要把流量全部转发到服务器就填0.0.0.0/0
AllowedIPs = 192.168.2.0/24
# 服务器IP
Endpoint = 192.168.1.4:8040
# 保持连接参数
PersistentKeepalive = 25
# 当服务器作为默认网关时，是否通过隧道转发多播和广播数据包
# AllowMulticast = false
```

### 多用户配置

```
# 停止WireGuard
wg-quick down wg0

# 生成新的客户端密钥对
wg genkey | tee client0_privatekey | wg pubkey > client0_publickey


# 在服务端配置文件中加入新的客户端公钥
# AllowedIPs重新定义一段
# 一次性复制粘贴，不要分行执行
echo "
[Peer]
  PublicKey = $(cat client0_publickey)
  AllowedIPs = 10.0.0.3/32" >> wg0.conf


# 新建一个客户端文件，使用新客户端密钥的私钥
# Address与上面的AllowedIPs保持一致
# Endpoint和之前的一样，为服务器ip和设置好的ListenPort
# 一次性复制粘贴，不要分行执行
echo "
[Interface]
  PrivateKey = $(cat client0_privatekey)
  Address = 10.0.0.3/24
  DNS = 8.8.8.8
  MTU = 1420

[Peer]
  PublicKey = $(cat server_publickey)
  Endpoint = 1.2.3.4:50814
  AllowedIPs = 0.0.0.0/0, ::0/0
  PersistentKeepalive = 25 " > client0.conf


# 已经成功创建后，启动WireGuard
wg-quick up wg0

```

### 二维码

```
yum install -y qrencode

# 导出客户端配置文件方式依旧可以采用上面介绍的两种方法，例如此客户端文件生成二维码就应该为
qrencode -t ansiutf8 < /etc/wireguard/client0.conf
```

### ps

```
不支持 OVZ，建议使用 KVM 架构的 VPS，且推荐高版本系统；
```

### 分流相关

脚本 [脚本](https://github.com/fivesheep/chnroutes/blob/master/chnroutes.py)

文章 [文章](https://blog.mozcp.com/wireguard-usage/)
