---
title: 在CentOS搭建go
date: 2015-07-08 04:02:17
update: 2015-11-05 04:02:17
tags: [go]
---

## install

[download](https://golang.org/dl/)


````
wget https://storage.googleapis.com/golang/go1.6.2.linux-amd64.tar.gz

tar -C /usr/local -xzf go1.6.2.linux-amd64.tar.gz

vim ~/.profile

export GOROOT=$HOME/go
export GOPATH=$HOME/go/path
export PATH=$PATH:$GOROOT/bin

source ~/.profile

````
