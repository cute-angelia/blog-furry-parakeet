title: Swap 内存交换
date: 2016-11-17 10:38:45
tags: [swap,linux]
---

## 创建分区

* 增加一个SWAP文件

````
//(建立一个1024M的swap文件)
dd if=/dev/zero of=/swapfile bs=1M count=1024

````

* 标识为SWAP文件

````
cd /
mkswap swapfile
````

* 激活SWAP文件

````
swapon swapfile
````

* 修改/etc/fstab文件，增加以下内容：

````
/swapfile swap swap default 0 
````

* 查看状态

````
swapon -s 或
free -m 或
cat /proc/swaps
````

<!-- more -->

## 修改分区大小

增加新的交换分区 

````
dd if=/dev/zero of=/swapfile2 bs=1M count=2048

mkswap swapfile2

挂载交换分区：swapon swapfile2

删除旧分区文件
````

## 删除分区

* 关闭swap

````
swapoff /swapfile
````

修改/etc/fstab文件

````
去除 /swapfile swap swap default 0 0
````

查看swap使用比例

````
cat /proc/sys/vm/swappiness  //0不使用  100极力使用
````

临时修改使用比例

````
sysctl vm.swappiness=60
````

永久修改使用比例

````
vim /etc/sysctl.conf
在这个文档的最后加上这样一行
vm.swappiness=60

````

