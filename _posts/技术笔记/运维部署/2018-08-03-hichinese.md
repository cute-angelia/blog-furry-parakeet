---
title: HiChinese部署笔记
tags: [linux]
---

## 搭建环境

* CentOS
* Openresty
* PHP：5.6

### ulimit

`vim /etc/profile`

```
ulimit -u 1000000
ulimit -n 1000000
ulimit -d unlimited
ulimit -m unlimited
ulimit -s unlimited
ulimit -t unlimited
ulimit -v unlimited
```

`source /etc/profile`

### timezone

安装ntp服务

```
yum install ntp -y 
systemctl enable ntpd
systemctl start ntpd
timedatectl set-timezone Asia/Shanghai
timedatectl set-ntp yes
ntpq -p
```

### env setting

```
## Fedora 和 RedHat 用户
yum update
yum group install "Development Tools" -y

## Debian 和 Ubuntu 用户
sudo apt-get -y install build-essential
```

```
   mkdir -p \
    /app/local/php/ \
    /app/local/nginx/ \
    /app/data /app/log \
    /app/src /app/log/php-fpm/ \
    /var/run/php-fpm/
```

### install openresty

```
yum install -y pcre-devel openssl-devel gcc curl
yum install -y yum-utils

## 安装
wget https://openresty.org/download/openresty-1.13.6.2.tar.gz
tar -xvf openresty-1.13.6.2.tar.gz
./configure  --with-http_stub_status_module --with-http_ssl_module --prefix=/app/local/openresty -j2
make -j2
sudo make install

ln -s /app/local/openresty/nginx/sbin/nginx /usr/local/bin/
ln -s /app/local/openresty/bin/* /usr/local/bin/
```

### orange

```
## install lor
git clone https://github.com/sumory/lor
cd lor
make install

## install orange
git clone https://github.com/sumory/orange.git
make install

vim orange.conf // 修改账密登陆
vim nginx.conf  // 修改系统

orange start
```

### php 5.6

```
yum install -y pcre-devel openssl openssl-devel libpng-devel libjpeg-devel libcurl-devel gmp-devel openssl-devel libmcrypt-devel mhash-devel mysql-devel bzip2-devel libmcrypt.x86_64 libmcrypt-devel.x86_64 libxml2-devel

useradd gouser
    
wget -O php56.tar.gz http://t.cn/RYhCskQ
tar -zxvf php56.tar.gz

cd php-5.6.31/
    
./configure \
    --prefix=/app/local/php/ \
    --with-config-file-path=/etc/ \
    --with-config-file-scan-dir=/etc/php.d/ \
    --with-pdo-mysql \
    --with-mysql \
    --with-mysqli \
    --with-bz2 \
    --with-curl \
    --with-gd \
    --with-gettext \
    --with-gmp \
    --with-mhash \
    --with-mcrypt \
    --with-iconv \
    --with-openssl \
    --with-png-dir \
    --with-jpeg-dir \
    --enable-fpm \
	 --enable-bcmath \
	 --enable-exif \
	 --enable-mbstring \
    --enable-soap \
    --enable-sockets \
    --enable-calendar \
    --disable-fileinfo 
    
    ## 设置软连接
    ln -s /app/local/php/bin/* /usr/local/bin/
    touch /var/run/php-fpm/php-fpm.pid
    
    pecl install pdo
    
    cd /etc
    wget -O phpconfig.zip http://attachment.shouyintv.cn/Z1EtMPO
    
    unzip phpconfig.zip
    cd /etc/php.d/
    mv *.ini disable/
```

### composer

```
cd /app/local/php/
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
    
ln -s /app/local/php/composer.phar /usr/local/bin/composer

composer config -g repo.packagist composer https://packagist.phpcomposer.com
```


