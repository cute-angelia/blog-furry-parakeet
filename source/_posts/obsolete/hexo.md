title: Hexo 静态博客系统
date: 2013-01-10 17:41:48
tags: [blog, hexo]
updated: 2015-11-19 23:04:04
---
[homepage]:http://zespia.tw/hexo/
[install]:http://zespia.tw/hexo/docs/
[jekyll]:http://jekyllrb.com/
[octopress]:http://octopress.org/
[ruby]:http://www.ruby-lang.org/en/
[nodejs]:http://nodejs.org/

What's Hexo ?
> A fast, simple & powerful blog framework, powered by Node.js.

***

## Hexo主页

去[Hexo][homepage]主页


## Hexo安装

Hexo安装[Install][install]说明


### 在安装发布的问题 github

---

## 1. fatal: 'furtee.github.com' does not appear to be a git repository

解决方法:

    _config.yml
    deploy:
      type: github
      repository: git@github.com:rose1988c/rose1988c.github.com.git
      branch: master

## 2. nothing to commit, working directory clean

解决方法:

    rm -rf .deploy
    hexo generate
    hexo deploy

<del>hexo setup_deploy</del>
    
## 3. GitHub Page http://rose1988c.github.com 404

解决方法:
    
    username.github.com的username必須與使用者名稱相同
    只有在repository為username.github.com時才有效，
    其他repository皆為username.github.com/repository

## 4.  Archives | Tags | Categorys 显示标题设置

解决方法:
    
    _config.yml
    # Archives
    ## 2: Enable pagination
    ## 1: Disable pagination
    ## 0: Fully Disable
    archive: 1
    category: 1
    tag: 1

## 5. 删除线的使用

解决方法:
    
    <del>hexo setup_deploy</del>


## 6. 多台电脑共同发布问题

 家里发布，公司发布，不同电脑的发布。我建了了新的一个<code>GitHub</code><code>Repositories</code>

 就可以同步了，不过因为2个电脑配置不一样问题也产生了。

 有时候无法 <code>hexo generate</code>, 这可能是 <code>.deploy</code>文件夹的配置问题，可以删除它

    rm -rf .deploy

可能有时候还需要删除 

    rm -rf .cache

如果还是不能<code>hexo generate</code>，需要备份，<code>_config.yml</code>,进行<code>hexo init</code>

当然如果你修改过，<code>themes</code> 下的 <code>_config.yml</code>，也请备份下。


## 7. 不显示分类

    categories: Node.js

分类是 <code>categories</code>,不是<code>category</code>,这样就有了。

## 8. 没有index.html or theme not support

````
需要执行 npm install
````

## 相关链接


* [Jekyll][jekyll]
* [Octopress][octopress] 
* [Hexo][homepage]

* [Ruby][ruby]
* [Node.js][nodejs]


## 高可用

参考：
[静态博客高可用部署实践](http://blog.jamespan.me/2015/10/26/ha-deployment-for-blog/)

目前：chenyunwen.cn 部署方案

vps2台分布式(linode/bandwagonhost)

nginx 配置如下：
````
server {
  server_name www.chenyunwen.cn chenyunwen.cn;
  return 301 https://chenyunwen.cn$request_uri;
}

server {
    listen 4001;
    port_in_redirect off;
    location / {
        proxy_pass http://rose1988c.github.io/;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}

server {
    listen 4002;
    port_in_redirect off;
    location / {
        proxy_pass http://hexo:4000/;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}


upstream backend_blog_me {
    server 127.0.0.1:4001;
    server 127.0.0.1:4002;
}

server {
    listen      443 ssl;
    server_name  chenyunwen.cn;

    ssl_certificate /etc/letsencrypt/live/chenyunwen.cn/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/chenyunwen.cn/privkey.pem;

    location / {
        proxy_next_upstream http_502 http_503 http_504 http_404 error timeout invalid_header;
        proxy_pass http://backend_blog_me;
        proxy_redirect off;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
    }
    error_page 497  https://$host$uri?$args;
}
````

