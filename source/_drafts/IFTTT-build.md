title: IFTTT之初步构建笔记（试用）
date: 2016-03-11 17:07:17
tags: [ifttt,etcd]
---

本文构建包括ETCD,Recipes服务2块。

<!-- more -->

## Etcd

> A highly-available key value store for shared configuration and service discovery.

> 简单：基于HTTP+JSON的API让你用curl就可以轻松使用。
> 安全：可选SSL客户认证机制。
> 快速：每个实例每秒支持一千次写操作。
> 可信：使用Raft算法充分实现了分布式。

在etcd系统中，我们可以存储两种类型的东西：keys和directors。
keys存储的是单个字符值，directors存储的是一组keys或者存储其他directors。

### 1.安装

[coreos/etcd](https://github.com/coreos/etcd)

* 启动

````
    ./bin/etcd -data-dir /tmp/etcd/ -name Test01
````

### 基本命令

````
    # 整个系统的key
    curl -s http://127.0.0.1:2379/v2/keys/?recursive=true

    # 插入一条K/V
    curl -s http://127.0.0.1:2379/v2/keys/message1 -XPUT -d value='hello world' | jq .

    # 获取一条K/V
    curl -s http://127.0.0.1:2379/v2/keys/message1 | jq .

    # 用ctl获得K/V
    etcdctl get message1

    # 删除一条K/V
    curl -s http://127.0.0.1:2379/v2/keys/message1 -XDELETE

    # 插入一条K/V并设置过期时间为5秒
    curl -s http://127.0.0.1:2379/v2/keys/message2 -XPUT -d value='hello etcd' -d ttl=5 | jq .

    # 监视key的变更
    # 窗口1
    curl -s http://127.0.0.1:2379/v2/keys/message2 -XPUT -d value='hello etcd 1' | jq .
    curl -s http://127.0.0.1:2379/v2/keys/message2?wait=true | jq .
    # 窗口2
    curl -s http://127.0.0.1:2379/v2/keys/message2 -XPUT -d value='hello etcd 2' | jq .

    # sorted key排序
    curl -s http://127.0.0.1:2379/v2/keys/message3 -XPOST -d value='hello etcd 1'
    curl -s http://127.0.0.1:2379/v2/keys/message4 -XPUT -d value='hello etcd 1'
    curl -s http://127.0.0.1:2379/v2/keys/message5 -XPUT -d value='hello etcd 1'
    curl -s http://127.0.0.1:2379/v2/keys/message3 -XPOST -d value='hello etcd 2' | jq .
    ---
    curl -s 'http://127.0.0.1:2379/v2/keys/message3?recursive=true&sorted=true'

    # 创建目录
    curl -s http://127.0.0.1:2379/v2/keys/message7 -XPUT -d dir=true

    # 删除目录
    curl -s 'http://127.0.0.1:2379/v2/keys/message7?dir=true' -XDELETE
    如果director里面已经包含keys了，则必须增加recursive=true参数
    curl -s 'http://127.0.0.1:2379/v2/keys/message7?recursive=true' -XDELETE

    # 在目录中创建key
    curl -s http://127.0.0.1:2379/v2/keys/message7/message_key -XPUT -d value='this is a key in directory'

    # 创建一个隐藏的节点(隐藏key/隐藏directory)，我们创建一个隐藏key时使用'_'作为key的前缀即可，当你发送HTTP GET请求时，隐藏key并不会被显示出来
    curl -s http://127.0.0.1:2379/v2/keys/_message -XPUT -d value='a hidden key'

    # 存储一些小的配置文件、json文档、xml文档
    curl -s http://127.0.0.1:2379/v2/keys/file -XPUT --data-urlencode value@upfile
````

### 状态监控

````
    # etcd会跟踪一些集群使用的统计信息，比如带宽、启动时间之类的。
    Leader Statistics：leader有查看整个etcd集群视图的能力，而且会跟踪两个有趣的统计信息：到集群中同等机器的延迟和rafr rpc请求失败和成功的数量。
    curl -s http://127.0.0.1:2379/v2/stats/leader

    # Self Statistics：每个节点内部的统计信息
    curl -s http://127.0.0.1:2379/v2/stats/self

    # Store Statistics：存储统计信息包含了在该节点上的所有操作信息
    curl -s http://127.0.0.1:2379/v2/stats/store

    # 查询集群的配置
    curl -s http://0.0.0.0:2380/v2/admin/config

    # 整个集群中有多少成员
    curl -s http://0.0.0.0:2380/v2/admin/machines

    #在集群中删除TEST2节点
    curl -s http://0.0.0.0:2380/v2/admin/machines/TEST2 -XDELETE

````

### etcd节点的配置文件设置：

* 命令行
* 环境变量
* 配置文件

配置文件方式，etcd默认从/etc/etcd/etcd.conf读取配置

````
addr = "127.0.0.1:2379"
bind_addr = "127.0.0.1:2379"
ca_file = ""
cert_file = ""
cors = []
cpu_profile_file = ""
data_dir = "."
discovery = "http://etcd.local:2379/v2/keys/_etcd/registry/examplecluster"
http_read_timeout = 10.0
http_write_timeout = 10.0
key_file = ""
peers = []
peers_file = ""
max_cluster_size = 9
max_result_buffer = 1024
max_retry_attempts = 3
name = "default-name"
snapshot = true
verbose = false
very_verbose = false

[peer]
addr = "127.0.0.1:2380"
bind_addr = "127.0.0.1:2380"
ca_file = ""
cert_file = ""
key_file = ""

[cluster]
active_size = 9
remove_delay = 1800.0
sync_interval = 5.0
````

命令行优先级最高，环境变量的又高于配置文件。

* 命令参数

````
Options:
  --version         显示版本号
  -f -force         强制使用新的配置文件
  -config=<path>    指定配置文件的路径
  -name=<name>      该节点在etcd集群中显示的名称
  -data-dir=<path>  etcd数据的存储路径
  -cors=<origins>   Comma-separated list of CORS origins.
  -v                开启verbose logging.
  -vv               开启very verbose logging.

Cluster Configuration Options:
  -discovery=<url>                Discovery service used to find a peer list.
  -peers-file=<path>              包含节点信息的文件列表
  -peers=<host:port>,<host:port>  逗号分割的节点列表，这些节点应该匹配节点的-peer-addr标记指定的信息

Client Communication Options:
  -addr=<host:port>         客户端进行通讯的公共地址端口
  -bind-addr=<host[:port]>  监听的地址端口，用来进行客户端通讯
  -ca-file=<path>           客户端CA文件路径
  -cert-file=<path>         客户端cert文件路径
  -key-file=<path>          客户端key文件路径

Peer Communication Options:
  -peer-addr=<host:port>  节点间进行通讯的地址端口
  -peer-bind-addr=<host[:port]>  监听的地址端口，节点间来进行通讯
  -peer-ca-file=<path>    节点CA文件路径
  -peer-cert-file=<path>  节点cert文件路径
  -peer-key-file=<path>   节点key文件路径
  -peer-heartbeat-interval=<time> 心跳检测的时间间隔，单位是毫秒
  -peer-election-timeout=<time> 节点选举的超时时间，单位是毫秒

Other Options:
  -max-result-buffer   结果缓冲区的最大值
  -max-retry-attempts  节点尝试重新加入集群的次数
  -retry-interval      Seconds to wait between cluster join retry attempts.
  -snapshot=false      禁止log快照
  -snapshot-count      发布快照前执行的事物次数
  -cluster-active-size 集群中的活跃节点数
  -cluster-remove-delay 多少秒之后再删除集群中的节点
  -cluster-sync-interval 在备模式下，两次同步之间的时间差
````

### 集群搭建

[1](https://github.com/coreos/etcd/blob/master/Documentation/clustering.md)
[2](http://www.tuicool.com/articles/jAVnI3f)

唉，木有三台机器啊。。只能自身开多个端口来搞了。

````

## cluster

etcd --name infra0 --initial-advertise-peer-urls http://0.0.0.0:2380 \
  --listen-peer-urls http://0.0.0.0:2380 \
  --listen-client-urls http://0.0.0.0:2379 \
  --advertise-client-urls http://0.0.0.0:2379 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster infra0=http://0.0.0.0:2380,infra1=http://0.0.0.0:2480,infra2=http://0.0.0.0:2580 \
  --initial-cluster-state new

## peer

  etcd --name infra1 --initial-advertise-peer-urls http://0.0.0.0:2480 \
  --listen-peer-urls http://0.0.0.0:2480 \
  --listen-client-urls http://0.0.0.0:2479 \
  --advertise-client-urls http://0.0.0.0:2479 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster infra0=http://0.0.0.0:2380,infra1=http://0.0.0.0:2480,infra2=http://0.0.0.0:2580 \
  --initial-cluster-state new

## peer

  etcd --name infra2 --initial-advertise-peer-urls http://0.0.0.0:2580 \
  --listen-peer-urls http://0.0.0.0:2580 \
  --listen-client-urls http://0.0.0.0:2579 \
  --advertise-client-urls http://0.0.0.0:2579 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster infra0=http://0.0.0.0:2380,infra1=http://0.0.0.0:2480,infra2=http://0.0.0.0:2580 \
  --initial-cluster-state new


````
