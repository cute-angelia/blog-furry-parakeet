---
title: php-codeigniter-with-404
date: 2014-11-13 22:50:17
tags: [ci]
---

## Codeigniter 404 error page, routing issue

Codeigniter 有个很烦恼我的问题，有时候部署会出现`404 Page not found` 

* 移除 `index.php` 保持美观
    
    ```` .htaccess
    RewriteEngine on
    RewriteBase /
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule ^(.*)$ index.php?/$1 [L]
    ````
    and Edit config.php

    ````config.php
    $config['base_url'] = "";
    $config['index_page'] = '';
    $config['uri_protocol'] = 'AUTO';
    ````
    
* 保留 `index.php`
    
    默认只要 clean up `.htaccess` 就可以了。

    不过有些奇葩的设置，比如：

    假如设置了 `$config['base_url']` 修改以下配置
    
    ````config.php
    $config['uri_protocol']	= 'PATH_INFO';
    ````
    

按理说，配置都应交给`.htaccess`去配置，`Codeigniter`用 `config.php`配置显得，你管的太多了。
