---
title: ubuntu_chmod
date: 2014-12-17 21:39:01
tags: [ubunut, chmod]
---

## Ubuntu Chomd

`Linux`下,每个文件，文件夹都有其：所属用户，所属用户组

其权限也是分为三段

`ls -l` 可以查看,` rwx` 分别表示：`读写执行`

比如 : `ls -l`  得到`KKK`目录：  

````
rwr-xr--x  kkk  kkk
````

那么表示KKK目录对于文件所有者KKK是读写执行都允许，对于文件所属用户组kkk里面得用户，是不可写

对于其他用户时只能执行，不能读写


那么现在有`guest`用户，到`kkk`目录下，是不能修改文件的，如果需要修改


1. 将kkk目录递归设置其他权限为7 即：rwx，但是这样，是一个不安全的做法

````
chmod -c -R 777 kkk
````

改变`KKK`目录，递归，所有文件，文件夹改为`777` 即：`rwxrwxrwx`


2. 将`kkk`的所有者改到`guest`用户

````
sudo chown -R guest /home/kkk
````

这个表示 `change owner  -R`(递归) `guest`(目标用户)   `/home/kkk`(需要改变`Owner`的路径)

这样`KKK`得所有者就变成了`guest`，`su`到`guest` 用户，登录到`kkk`目录，可以随意写入了


同理，使用`chgrp` 可以改变文件所属得组

`change group`

通过这些设置，用户，用户组，对应文件权限就可以理解了




附常用指令：

1. groupadd mysql
2. mkdir /home/mysql
3. useradd -g mysql -d /home/mysql mysql
4. copy mysql-5.0.45-linux-i686-icc-glibc23.tar.gz到/usr/local目录
5. 解压：tar zxvf mysql-5.0.45-linux-i686-icc-glibc23.tar.gz
6. ln -s mysql-5.0.45-linux-i686-icc-glibc23 mysql
7. cd /usr/local/mysql
8. chown -R mysql .
9. chgrp -R mysql .


[引用](http://blog.csdn.net/lawmansoft/article/details/7203297)

