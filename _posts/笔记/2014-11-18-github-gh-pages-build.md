---
title: GitHub gh-page 配置
date: 2014-11-18 15:13:21
tags: [github]
---

`GitHub` 更新了域名指向，之前 `username.github.com` 都要改成 `username.github.io`

在公告日期之内，如果没有更改会造成发布错误的情况。


目前流行的解决方法：
1. 创建 `CNAME` 文件在你的项目，内容为：`yourdomain.com`
2. 进入域名托管商后台 `DNS MANAGE` 增加2条（@ 和 www） `CNAME` 指向 `username.github.io`
   如果不支持`CNAME`方式的请用`A`记录,指向 `192.30.252.153` and `192.30.252.154`
3. 测试下是否成功 
````
dig yourdomain.com +nostats +nocomments +nocmd
````
<!-- more -->

[官方公告地址](https://github.com/blog/1917-github-pages-legacy-ip-deprecation)


引用几段公告内容

> Starting the week of November 10th, pushing to a misconfigured site will result in a build error and you will receive an email stating that your site's DNS is misconfigured. Your site will remain available to the public, but changes to your site will not be published until the DNS misconfiguration is resolved.

> For the week of November 17th, there will be a week-long brownout for improperly configured GitHub Pages sites. If your site is pointed to a legacy IP address, you will receive a warning message that week, in place of your site's content. Normal operation will resume at the conclusion of the brownout.

> Starting December 1st, custom domains pointed to the deprecated IP addresses will no longer be served via GitHub Pages. No repository or Git data will be affected by the change.

