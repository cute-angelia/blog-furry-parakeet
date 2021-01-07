---
title: MAC 终端代理
date: 2016-5-5 10:38:45
tags: [mac]
---

1. Surge Mac

如果用的是 zsh 终端，在 ~/.zshrc 配置文件中添加下面一段，以后使用的时候输入 Proxy 打开代理模式，关闭代理时输入 noproxy 即可。

![](http://ww1.sinaimg.cn/large/7853084cgw1f86toymul4j21320t6wjw.jpg)

````
# where proxy
proxy () {
  export http_proxy="http://127.0.0.1:6152"
  export https_proxy="http://127.0.0.1:6152"
  echo "HTTP Proxy on"
}

# where noproxy
noproxy () {
  unset http_proxy
  unset https_proxy
  echo "HTTP Proxy off"
}
````

如果是用的是系统默认的终端，可以从 Surge Mac 菜单里选择「Copy Shell Export Command」，然后粘贴到终端里来打开代理。

命令行其实和上面在 zsh 中用到的是一样的。

2. shadowsocksX Mac


````
# windows
set http_proxy=127.0.0.1:6152
set https_proxy=127.0.0.1:6152

# mac
export http_proxy="http://127.0.0.1:6152"
export https_proxy="http://127.0.0.1:6152"

````

> 以上是基于`http`形式,但是 `Mac` 的`shadowsocksX`并不提供`http`方式,而是socket v5,导致无法使用...
另外还有个问题是mac SIP保护机制.


使用 `proxychains4` 将 `shadowsocksX` 转化 socket v5 为 http

> mac SIP保护机制,需要把命令`curl`,`wget`等移到外部文件夹

> 或者关闭SIP保护机制
重启时候 按住command+r 进去,打开终端输入 `csrutil disable` ,然后 `reboot`