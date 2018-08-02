---
title: Cassandra
tags: [nosql,cassandra]
---

# Cassandra

Cassandra 的数据模型是基于列族（Column Family）的四维或五维模型。

多维的概念是可以相互嵌套, 如: 三维可以包含多个二维, 简单来说就是迭代

Cassandra 写入数据流程:

    1. 记录日志 CommitLog
    2. 写入内存 Memtable
    3. 写入磁盘 SSTable
    
### 安装

go to  http://cassandra.apache.org/

建议 docker 安装:

`docker pull cassandra`




