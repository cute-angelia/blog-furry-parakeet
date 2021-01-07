---
title: Docker Study Note
date: 2015-11-05 22:44:31
tags: [docker]
---

## Docker

Docker 就是捕鱼~

<!-- more -->

##　基本搭建

[官网](https://www.docker.com/)

[HUB](https://hub.docker.com/)

[安装](http://docs.docker.com/linux/step_one/)

## 基本知识

[Docker —— 从入门到实践](http://dockerpool.com/static/books/docker_practice/index.html)

略。。。

## 摘记

### 文件卷

存放文件，共享给其他容器

* 创建文件卷,指定路径为`/opt/www`并命名为`workspace`

````
    docker pull busybox
    docker run -it --name workspace -h workspace -v /opt/www:/opt/www busybox /bin/bash
    ## 查看映射关系
    docker inspect -f {{.Volumes}} workspace
````

### 搭建静态博客hexo blog

这里使用基于[hexo](hexo.io)博客

docker镜像推荐用[https://hub.docker.com/r/tommylau/hexo/~/dockerfile/](https://hub.docker.com/r/tommylau/hexo/~/dockerfile/)

````
    docker pull tommylau/hexo
    docker run -h="hexo" --name hexo -i -t -p 4000:4000 --volumes-from workspace tommylau/hexo /bin/bash

    ## 之后是一些ssh配置
    hexo g -d
    hexo s &
    exit
````

### php base

````
    docker pull php

    docker run -h="php" --name php -i -t -p 9000:9000 --volumes-from workspace -d php
````

### php fpm

````
    docker pull mouyigang/laravel-phpfpm
    docker run -h="fpm" --name fpm -i -t -p 9000:9000 --volumes-from workspace -d mouyigang/laravel-phpfpm
```

### nginx

代理上面的4000端口

````
    // 不加载证书
    docker run -h="nginx" --name nginx --link hexo:hexo -i -t -p 80:80 --volumes-from workspace -d nginx

    // 加载证书
    docker run -h="nginx" --name nginx --link hexo:hexo -i -t -p 80:80 -p 443:443 --volumes-from workspace -v /etc/letsencrypt:/etc/letsencrypt -d nginx

    docker exec -it nginx /bin/bash

    // 链接数据卷配置
    // 唉，`www` 取名是个坑
    rm /etc/nginx/conf.d -r
    ln -s /opt/www/nginx/conf.d /etc/nginx/conf.d

    # 代理hexo 4000端口
    server {
        listen       80;
        server_name  ju57.com www.ju57.com;

        access_log  /var/log/nginx/ju57.access.log  main;
        error_log  /var/log/nginx/ju57.access.log  error;

        location / {
            proxy_pass http://hexo:4000/;
        }
    }

    // ok

    // 竟然不标配vim....安装后打包一个镜像
    // 打包nginx为镜像
    docker commit -a "rose1988c" -m "nginx with vim" nginx rose1988c/vanilla-nginx:v0.0.1

    // 上传 hub.docker.io
    docker pull rose1988c/vanilla-nginx
    or
    docker push rose1988c/vanilla-nginx:v0.0.1

    // 之后可以用这个镜像跑起来
    docker run -h="nginx" --name nginx --link hexo:hexo -i -t -p 80:80 -p 443:443 --volumes-from workspace -v /etc/letsencrypt:/etc/letsencrypt -d rose1988c/vanilla-nginx:v0.0.1

    // 加载PHP-FPM - update 2015-11-26 19:18:12
    docker run -h="nginx" --name nginx --link hexo:hexo --link fpm:fpm -i -t -p 80:80 -p 443:443 --volumes-from workspace -v /etc/letsencrypt:/etc/letsencrypt -d rose1988c/vanilla-nginx:v0.0.1

````

参考：

    [深入 Docker：容器和镜像](http://segmentfault.com/a/1190000002766882)


### node 环境

* 数据为`文件卷`数据
* 搭建node镜像

````
[root@localhost ~]# docker run -h="node" --name node -i -d -t --volumes-from workspace node

## 启动（加了-d）
[root@localhost ~]# docker start node

## 查看
[root@localhost ~]# docker ps
CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS              PORTS                         NAMES
8a9509d755e1        node                "node"                 12 seconds ago      Up 11 seconds                                     node

## 删除
[root@localhost ~]# docker stop node && docker rm node

## 进入容器
[root@localhost ~]# docker exec -it 8 /bin/bash
[root@localhost ~]# docker exec -it node /bin/bash

````

需要特别解释下的是：

`-h="hostname"` 命名主机名字，好处就是进入容易里面不会犯迷糊
`--name` 容器名字  用了这个我们可以用主机名字进入容易，方便，不用输入容器id了。另外容器id不用打全

P_P 太不统一了， `--`,`-`


> 本笔记粗浅，见笑了

