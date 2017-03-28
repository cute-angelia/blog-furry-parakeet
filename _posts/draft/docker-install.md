---
title: CentOS7 安装 Docker
date: 2015-11-04 22:44:31
tags: [docker, build]
---

[官方文档](https://docs.docker.com/engine/installation/linux/centos/)

`CentOS6` 当然可以，主要是内核要升级到 `3.1`

为了方便，我直接安装了 `CentOS7`. 安装 `Docker` 过程如下： 检测系统内核版本是否符合要求

````
uname -r
````

## 安装

可以使用 `yum` 或 `curl`, 这儿主要说 `yum` 的方式，`curl` 的请看官方教程。


````
sudo yum update
````

### 添加 yum 源

````
sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
````

### 安装 Docker 引擎

````
sudo yum install docker-engine
````

### 启动 Docker

````
sudo service docker start
````

### 设为开机启动

````
systemctl enable docker.service
````