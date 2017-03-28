---
title: mongodb
date: 2014-03-20 13:25:21
tags: [mongo]
---

## mongo 笔记

````
    show dbs
    use mydb
    # db.dropDatabase()
````

### mongodump备份数据库

1. 常用命令格

````
    mongodump -h IP --port 端口 -u 用户名 -p 密码 -d 数据库 -o 文件存在路径
````

> 如果没有用户谁，可以去掉-u和-p。
  如果导出本机的数据库，可以去掉-h。
  如果是默认端口，可以去掉--port。
  如果想导出所有数据库，可以去掉-d。

2. 导出所有数据库

````
    mongodump -h 127.0.0.1 -o /tmp/mongodb/
````

3. 导出指定数据库

````
    mongodump -h 192.168.1.108 -d tank -o /tmp/mongodb/
````

### mongorestore还原数据库

````
    mongorestore -h IP --port 端口 -u 用户名 -p 密码 -d 数据库 --drop 文件存在路径
````

> --drop的意思是，先删除所有的记录，然后恢复。

恢复所有数据库到mongodb中

````
    mongorestore /tmp/mongodb/   #这里的路径是所有库的备份路径
````

还原指定的数据库

````
    mongorestore -d tank /tmp/mongodb/tank/    #tank这个数据库的备份路径
    mongorestore -d tank_new  /tmp/mongodb/tank/    #将tank还有tank_new数据库中
````

> 这二个命令，可以实现数据库的备份与还原，文件格式是json和bson的。无法指写到表备份或者还原。

### mongoexport导出表，或者表中部分字段

````
    mongoexport -h IP --port 端口 -u 用户名 -p 密码 -d 数据库 -c 表名 -f 字段 -q 条件导出 --csv -o 文件名
````

> -f 导出指字段，以字号分割，-f name,email,age导出name,email,age这三个字段
  -q 可以根查询条件导出，-q '{ "uid" : "100" }' 导出uid为100的数据
  --csv 表示导出的文件格式为csv的，这个比较有用，因为大部分的关系型数据库都是支持csv，在这里有共同点

导出整张表

````
    mongoexport -d tank -c users -o /tmp/mongodb/tank/users.dat
````

导出表中部分字段

````
    mongoexport -d tank -c users --csv -f uid,name,sex -o tank/users.csv
````

根据条件导出数据

````
    mongoexport -d tank -c users -q '{uid:{$gt:1}}' -o tank/users.json
````

### mongoimport导入表，或者表中部分字段

还原整表导出的非csv文件

````
    mongoimport -h IP --port 端口 -u 用户名 -p 密码 -d 数据库 -c 表名 --upsert --drop 文件名
````

> 重点说一下--upsert，其他参数上面的命令已有提到，--upsert 插入或者更新现有数据

还原部分字段的导出文件

````
    mongoimport -h IP --port 端口 -u 用户名 -p 密码 -d 数据库 -c 表名 --upsertFields 字段 --drop 文件名
````

> --upsertFields根--upsert一样

还原导出的csv文件

````
    mongoimport -h IP --port 端口 -u 用户名 -p 密码 -d 数据库 -c 表名 --type 类型 --headerline --upsert --drop 文件名

````

还原导出的表数据

````
    mongoimport -d tank -c users --upsert tank/users.dat
````

部分字段的表数据导入

````
    mongoimport -d tank -c users  --upsertFields uid,name,sex  tank/users.dat
````

还原csv文件

````
    mongoimport -d tank -c users --type csv --headerline --file tank/users.csv
````



<abbr title="End of file">EOF</abbr>


