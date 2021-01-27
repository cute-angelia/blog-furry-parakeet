---
title: etcd setup
tags: [etcd]
---

## install

> etcd-install.sh

```
ETCD_VER=v3.4.14

# choose either URL
GOOGLE_URL=https://storage.googleapis.com/etcd
GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
DOWNLOAD_URL=${GITHUB_URL}

rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
rm -rf /tmp/etcd-download-test && mkdir -p /tmp/etcd-download-test

curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download-test --strip-components=1
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz

/tmp/etcd-download-test/etcd --version
/tmp/etcd-download-test/etcdctl version

mv /tmp/etcd-download-test/etcd /usr/local/bin/
mv /tmp/etcd-download-test/etcdctl /usr/local/bin/

```

## Configure the etcd on all nodes

### create etcd.service

> 环境配置

```
INT_NAME="eth0"

# ETCD_NAME=$(hostname -s)

ETCD_NAME="etcd-main"

ETCD_HOST_IP=$(ip addr show $INT_NAME | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)


# 节点IP配置， 需要在 `/etc/hosts` 配置 `etcd1` `etcd2` `etcd3` 的 `ip` 地址
# 如：
17.0.0.1 etcd1
17.0.0.2 etcd2
17.0.0.3 etcd3


```

> 创建新用户，可选

```
sudo groupadd --system etcd
sudo useradd -s /sbin/nologin --system -g etcd etcd

sudo mkdir -p /var/lib/etcd/
sudo mkdir /etc/etcd
sudo chown -R etcd:etcd /var/lib/etcd/
```

> 创建启动服务

```
ETCD_HOST_IP_OUT=47.99.136.83

cat <<EOF | sudo tee /etc/systemd/system/etcd.service
[Unit]
Description=etcd service
Documentation=https://github.com/etcd-io/etcd

[Service]
Type=notify
User=root
ExecStart=/usr/local/bin/etcd \\
  --name ${ETCD_NAME} \\
  --data-dir=/var/lib/etcd \\
  --initial-advertise-peer-urls http://${ETCD_HOST_IP}:2380 \\
  --listen-peer-urls http://0.0.0.0:2380 \\
  --listen-client-urls http://0.0.0.0:2379 \\
  --advertise-client-urls http://${ETCD_HOST_IP}:2379,http://${ETCD_HOST_IP_OUT}:2380 \\
  --initial-cluster-token etcd-cluster-0 \\
  --initial-cluster ${ETCD_NAME}=http://${ETCD_NAME}:2380,etcd-bwg=http://etcd-bwg:2380 \\
  --initial-cluster-state new \

[Install]
WantedBy=multi-user.target
EOF


sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl start etcd
sudo systemctl status etcd
```

> 或者手动启动

```
./etcd --name etcd0 --initial-advertise-peer-urls http://10.0.64.100:2380 \
  --listen-peer-urls http://0.0.0.0:2380 \
  --listen-client-urls http://0.0.0.0:2379  \
  --advertise-client-urls http://10.0.64.100:2379,http://125.94.39.48:2380 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster etcd0=http://10.0.64.100:2380,etcd1=http://10.0.64.101:2380,etcd2=http://10.0.64.102:2380 \
  --initial-cluster-state new >> etcd.log 2>&1 &

```

注意事项：

1. 启动服务中用户，User=etcd 或者 root
2. 配置中： --name 属性 和 --initial-cluster 的 ${ETCD_NAME} 要对应的上
3. 内外网：advertise-client-urls 内网 ip 和外网 ip 网卡不一致需要把 2 个都带上， 如：–advertise-client-urls http://10.0.64.100:2379,http://125.94.39.48:2380

> 其他：安全设置和防火墙开关

```
# For CentOS / RHEL Linux distributions, set SELinux mode to permissive.

sudo setenforce 0
sudo sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config

# RHEL / CentOS / Fedora firewalld
sudo firewall-cmd --add-port={2379,2380}/tcp --permanent
sudo firewall-cmd --reload

# Ubuntu/Debian
sudo ufw allow proto tcp from any to any port 2379,2380

```

## 测试节点 Test Etcd Cluster installation

```
# cli
etcdctl member list --write-out=table
etcdctl endpoint health

# cmd
etcdctl set /message "Hello World"
etcdctl get /message

# api
export ETCDCTL_API=3
#内网访问
etcdctl  --endpoints=http://10.0.64.100:2379,http://10.0.64.101:2379,http://10.0.64.102:2379 member list
#公网访问
etcdctl  --endpoints=http://125.94.39.48:2379,http://125.94.39.105:2379,http://59.37.136.50:2379 member list
curl http://125.94.39.48:2379/v2/keys/message

```

## 增加新节点

1. 在现有集群接点添加新节点
2. 新节点启动 etcd

现有集群:

1. 配置 hosts 如： sht-sgmhadoopdn-04
2. etcdctl member add sht-sgmhadoopdn-04 --peer-urls="http://sht-sgmhadoopdn-04:2380"

新节点启动：

1. 带上所有 ETCD_INITIAL_CLUSTER 进行启动

将各节点 etcd.conf 配置文件的变量 ETCD_INITIAL_CLUSTER 添加新节点信息，然后依次重启。

## 参考

[etcd doc](https://etcd.io/docs/v3.4.0/demo/)

[手把手教你 Etcd 的云端部署 2019 年 10 月 16 日](https://www.infoq.cn/article/tdcvy4jsvtwzgcnojl0r)

[etcd 集群添加节点](https://www.cnblogs.com/ilifeilong/p/11625151.html)

[Tutorial: Set up a Secure and Highly Available etcd Cluster](https://thenewstack.io/tutorial-set-up-a-secure-and-highly-available-etcd-cluster/)