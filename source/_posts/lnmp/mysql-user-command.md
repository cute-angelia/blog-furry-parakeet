title: mysql-user-command
date: 2014-10-11 01:33:06
tags: [mysql, study]
---

## 创建用户

    insert into mysql.user(Host,User,Password) values("localhost","username",password("passworld"));

## 授权用户username拥有DemoDb数据库的所有权限。

    grant all privileges on DemoDB.* to username@localhost identified by 'passworld';

## 授权一部分权限

    grant select,update on DemoDb.* to username@localhost identified by 'passworld';


## 删除用户

    DELETE FROM user WHERE User="username" and Host="localhost";

## 更新密码

    update mysql.user set password=password('新密码') where User="username" and Host="localhost";

## 以上操作都需要刷新权限

    flush privileges;



