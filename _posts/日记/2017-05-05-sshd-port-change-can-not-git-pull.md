---
title: sshd 默认端口修改后,无法拉去 git 代码
date: 2017-05-05 18:00:41
tags: [git]
---

sshd 默认端口修改后, 如:`10022`, git pull 的端口还是走了`22`端口

简单处理方法:

`vim .git/config`


````
url = git@git.xxx.com:appdir/appname.git
````

修改后

````
url = ssh://git@git.xxx.com:10022/appdir/appname
````