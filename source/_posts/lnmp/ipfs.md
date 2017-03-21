title: IPFS
date: 2016-02-22 15:33:17
tags: [ipfs, go, build]
---

> IPFS 是分布式文件系统，寻求连接所有计算机设备的相同文件系统。在某些方面，这很类似于原始的 Web 目标，但是 IPFS 最终会更像单个比特流群交换的 git 对象。

> IPFS ＝ InterPlanetary File System

> IPFS 云成为一个新的，重要的网络子系统，如果构建得当，那么可以完善或者替换 HTTP，或者说可以完善或者替代更多，听起来很疯狂，但是确实很疯狂！

> IPFS 结合了 Git，BitTorrent，Kademlia，SFS 和 Web 的优势，提供跟 HTTP web 一样简单的接口。


IPFS 分为 3 个代码库：

[IPFS 规范](//github.com/ipfs/ipfs)
[Go 实现](//github.com/ipfs/go-ipfs)
[Web 工作台](//github.com/protocol/ipfs-webui)

<!-- more -->

````
USAGE:

    ipfs - global p2p merkle-dag filesystem

    ipfs [<flags>] <command> [<arg>] ...

    BASIC COMMANDS

        init          Initialize ipfs local configuration
        add <path>    Add an object to ipfs
        cat <ref>     Show ipfs object data
        get <ref>     Download ipfs objects
        ls <ref>      List links from an object
        refs <ref>    List hashes of links from an object

    DATA STRUCTURE COMMANDS

        block         Interact with raw blocks in the datastore
        object        Interact with raw dag nodes
        file          Interact with Unix filesystem objects

    ADVANCED COMMANDS

        daemon        Start a long-running daemon process
        mount         Mount an ipfs read-only mountpoint
        resolve       Resolve any type of name
        name          Publish or resolve IPNS names
        dns           Resolve DNS links
        pin           Pin objects to local storage
        repo gc       Garbage collect unpinned objects

    NETWORK COMMANDS

        id            Show info about ipfs peers
        bootstrap     Add or remove bootstrap peers
        swarm         Manage connections to the p2p network
        dht           Query the dht for values or peers
        ping          Measure the latency of a connection
        diag          Print diagnostics

    TOOL COMMANDS

        config        Manage configuration
        version       Show ipfs version information
        update        Download and apply go-ipfs updates
        commands      List all available commands

    Use 'ipfs <command> --help' to learn more about each command.

````

### 安装

[https://github.com/ipfs/install-go-ipfs](https://github.com/ipfs/install-go-ipfs)

具体使用方式：

[https://ipfs.io/docs/examples/](https://ipfs.io/docs/examples/)

### (⊙﹏⊙)b

用了[pics](https://github.com/ipfspics)搭完了图床，结果因为P2P流量太厉害停了~

需要图床的还是用这套吧[v3.6.8](http://pan.baidu.com/s/1pKrkz8Z)