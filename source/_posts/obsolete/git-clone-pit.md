title: git_clone_problem
date: 2014-12-23 21:37:19
tags: [github, 坑, pit]
---

### git clone problem

````
Warning: Permanently added 'git.oschina.net,124.202.141.153' (ECDSA) to the list of known hosts.
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@         WARNING: UNPROTECTED PRIVATE KEY FILE!          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Permissions 0750 for '/home/chenyunwen/.ssh/id_rsa' are too open.
It is required that your private key files are NOT accessible by others.
This private key will be ignored.
````

奇葩啊。。。

解决办法：

修改密钥文件权限为700。
````
chmod 700 id_rsa
````

