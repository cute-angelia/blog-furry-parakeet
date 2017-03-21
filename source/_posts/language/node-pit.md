title: Node的坑
date: 2016-02-03 15:33:17
tags: [坑, node, pit, note]
---

天坑，如果你实在是找不到问题了，先升级版本吧。

## 更新最新稳定版

````
npm cache clean
npm install n
n install stable
````

## Error: Command failed: /usr/bin/env: node: No such file or directory

神奇的问题，在`crontab`执行`node`发现的,网上各种瞎BB，解决办法

````
ln -s /usr/local/bin/node /usr/bin/node
````

