title: CentOS 相关服务
date: 2015-06-25 22:44:50
tags: [centos, ftp, firewall]
---

## 使用ulimit设置文件最大打开数

ulimit –a命令来查看系统的一些资源限制

`vim /etc/security/limits.conf`

````
* soft  nofile = 51200
* hard  nofile = 65536
````

`vim /etc/profile`

````
ulimit -n 51200
````

`source /etc/profile`


## centos firewall

* 基本操作

````
    systemctl start firewalld
    firewall-cmd --state
    systemctl stop firewalld
````

* 开启端口

````
    firewall-cmd --zone=public --add-port=80/tcp --permanent
````

> 命令含义：
> --zone #作用域
> --add-port=80/tcp #添加端口，格式为：端口/通讯协议
> --permanent #永久生效，没有此参数重启后失效

* 重启防火墙

````
    firewall-cmd --reload
````

* 查看状态

````
    firewall-cmd --list-all
    firewall-cmd --query-service ftp
````

* 查看服务

````
    firewall-cmd --get-service
````


### 例子ftp服务

* 暂时开放 ftp 服务

````
    firewall-cmd --add-service=ftp
````

* 永久开放 ftp 服务

````
    firewall-cmd --add-service=ftp --permanent
````

* 永久关闭

````
    firewall-cmd --remove-service=ftp --permanent
````



## centos vsftpd添加新用户


1. 添加用户`demo`,用户目录指定为/var/www/,且此用户不能登陆系统.

    `useradd  demo –s /sbin/nologin –d /var/www/`
	
	注：`-s /sbin/nologin`是让其不能登陆系统，`-d` 是指定用户目录为`/var/www/`

2. 设置用户密码

    `passwd demo`  设置`demo`的密码

3. 授权文件夹权限

    `chown –R demo:demo /var/www/` 注:将用户目录及其子目录的所有和所属的组设置为`demo`，或者
    
    `chown –R demo /var/www/` 注:将用户目录及其子目录的所有设置为`demo`

4. 配置用户路径 

    `cd /etc/vsftpd/vsftpd_user_conf`

5. 重启

    `service vsftpd restart`

<!-- more -->

## 补充知识

### 查看用户列表

````
	cat /etc/passwd 可以查看所有用户的列表

	w 可以查看当前活跃的用户列表

	cat /etc/group 查看用户组

````

简明的命令

````
	cat /etc/passwd|grep -v nologin|grep -v halt|grep -v shutdown|awk -F":" '{ print $1"|"$3"|"$4 }'|more
````

### 查看进程运行的命令

通过`ps`及`top`命令查看`进程信息`时，只能查到相对路径，查不到的进程的详细信息，如绝对路径等。

这时，我们需要通过以下的方法来查看进程的详细信息：

`Linux`在启动一个进程时，系统会在`/proc`下创建一个以`PID`命名的`文件夹`，
在该文件夹下会有我们的进程的信息，其中包括一个名为`exe`的文件即记录了绝对路径，通过`ll`或`ls –l`命令即可查看。

````
ll /proc/PID

cwd符号链接的是进程运行目录；

exe符号连接就是执行程序的绝对路径；

cmdline就是程序运行时输入的命令行命令；

environ记录了进程运行时的环境变量；

fd目录下是进程打开或使用的文件的符号连接。
````

