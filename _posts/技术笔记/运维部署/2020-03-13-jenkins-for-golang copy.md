---
title: Jenkins for golang
tags: [go]
---

### docker install

```
docker push atchen1988/jenkins
```

我的 `docker` 已经配置好了 `GO` 环境

或者用官方的 [docker](https://hub.docker.com/_/jenkins)

### 一些说明

如果想用 `root` 用户进去配置东西，执行

```
docker exec -u 0 -it ea8ba5bc923b bash
```

如果想用官方版，配置笔记如下

```
# 换源
cat /etc/issue

apt-get install -y vim
apt-get install -y make

# install
  go get -u github.com/cute-angelia/protobuf/protoc-gen-go
# install protoc
	http://google.github.io/proto-lens/installing-protoc.html
	PROTOC_ZIP=protoc-3.7.1-linux-x86_64.zip
	curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v3.7.1/$PROTOC_ZIP
	unzip -o $PROTOC_ZIP -d /usr/local bin/protoc
	unzip -o $PROTOC_ZIP -d /usr/local 'include/*'
	rm -f $PROTOC_ZIP
# install protoc-gen-micro
	https://github.com/micro/protoc-gen-micro
  go get github.com/micro/protoc-gen-micro

vim ~/.profile  or  ~/.bashrc
export PATH=$PATH:/usr/local/go/bin:/root/go/bin
export GOPATH=/root/go
export GOROOT=/usr/local/go
export GOPROXY=https://goproxy.cn
export GO111MODULE=on

export LS_OPTIONS='--color=auto'
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'

```

### shell

项目把 `proto` 和 `服务` 包括进去了, 不像某些项目，微服务都是独立一个特项目，所以，我这边会根据提交的 `comment` 进行匹配

仅供参考

```
#!/bin/bash

pwd

group="qiming"
project_name=$(echo $GIT_URL | awk -F/ '{print $NF}' | sed 's/.git//g')

export GOPROXY=https://goproxy.io
export GOROOT=/usr/local/go
export GOPATH=/var/jenkins_home/$group/gopath
mkdir -p $GOPATH $GOPATH/src

# 初次
rm -rf $GOPATH/src/$project_name
ln -f -s $WORKSPACE $GOPATH/src/$project_name

cd $GOPATH/src/$project_name && make proto

cd $GOPATH/src/$project_name

comment=$(git log -1 --pretty=%B)
branch=${GIT_BRANCH#*origin/}

echo "========== 处理分支：${branch}， 项目：${comment} =========="

if [ "${comment}" == "svr-monitor" ]; then

    # 本地服务根路径
    rootpath="$GOPATH/src/$project_name/svr/${comment}"

    cd ${rootpath} && go mod vendor && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build

    chmod +x ${rootpath}/${comment}

	dest="/app/data/qiming-service/${comment}/${comment}/"

    echo '{
    "apps": [{
    "name": "qm-'${comment}'",
    "script": "'${comment}'",
    "cwd": "${dest}",
    "args": ["--registry=consul"],
    "env": {},
    "node_args": [],
    "log_date_format": "YYYY-MM-DD HH:mm Z",
    "exec_interpreter": "none",
    "exec_mode": "fork",
    "max_memory_restart": "300M"
    }]
    }' > ${rootpath}/pm2_${branch}.json


    if [ "${branch}" == "prerelease" ] || [ "${branch}" == "master" ]; then
      if [ "${branch}" == "prerelease" ]; then
        ansible mali-test -u gouser -a "mkdir -p ${dest}"
        ansible mali-test -u gouser -m copy -a "src=${rootpath}/pm2_${branch}.json dest=${dest}"
        ansible mali-test -u gouser -m copy -a "src=${rootpath}/${comment} dest=${dest}"
        ansible mali-test -u gouser -a "/app/pkg/node-v12.0.0-linux-x64/bin/node /app/pkg/node-v12.0.0-linux-x64/bin/pm2 startOrReload ${dest}/pm2_${branch}.json"
        echo "${branch} publish ok:${comment}"
      else
        echo "${branch}该分支还未发布到线上， 目前是测试环境，请用 prerelease 分支"
      fi
    else
      echo "${branch}该分支不自动发布"
    fi
fi
```
