---
title: github-webhooks-自动发布网站
date: 2014-10-08 02:30:32
tags: git
---

## 原理

利用`github`自带的`webhooks`，对相关命令进行事件监控，一旦发生某项命令，执行对应的脚本。


## 方法一

[delploy](https://gist.github.com/rose1988c/66b4746c0a75dee5743c)

> 脚本执行者必须有`github`的命令权限，最好以脚本身份执行一次命令。

````
    su xxx
    chmod +x file
````

## 方法二(2016-09-13)

[go-webhook](https://github.com/adnanh/webhook)

`apps.json`

````
[
  {
    "name": "webhook",
    "script": "webhook",
    "args": [
      "--port=2987",
      "--hooks=/etc/hooks.json",
      "--verbose"
    ],
    "cwd": "/etc/",
    "one_launch_only": "true"
  }
]
````

`hook.json`

````
[
  {
    "id": "chenyunwen",
    "execute-command": "/opt/www/rose1988c.github.io/update.sh",
    "command-working-directory": "/opt/www/rose1988c.github.io"
  }
]
````

`pm2 start apps.json`

设置 webhook url = local:2987/webhook/chenyunwen