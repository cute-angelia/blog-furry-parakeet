---
title: 本地文件管理工具
tags: [tool]
---

## 需求

存储设备（移动硬盘、NAS、PC）存着大量文件，如何进行统一管理是个工程问题

需求可能有：

1. 公司内网局域网分享需求
2. 家庭内网分享需求

### 工具

1. chfs

[地址](http://iscute.cn/chfs)

官网提供了各个版本，可以安装到各个系统（pc，软路由 和 nas）

CuteHttpFileServer/chfs是一个免费的、HTTP协议的文件共享服务器，使用浏览器可以快速访问。

它具有以下特点：

  * 单个文件，核心功能无需其他文件
  * 跨平台运行，支持主流平台：Windows，Linux和Mac
  * 界面简洁，简单易用
  * 支持扫码下载和手机端访问，手机与电脑之间共享文件非常方便
  * 支持账户权限控制和地址过滤
  * 支持快速分享文字片段
  * 支持webdav协议
  * 支持一部分视频，图片预览

2. miniserve

[地址](https://github.com/svenstaro/miniserve)

miniserve is a small, self-contained cross-platform CLI tool that allows you to just grab the binary and serve some file(s) via HTTP. Sometimes this is just a more practical and quick way than doing things properly.

3. minio

[地址](https://github.com/minio/minio/)

这个已经是完整的工程项目了，类似 oss

非常适合自建


### 应用场景

1. 我的软路由挂载了多个移动硬盘，外网或者内网想直接访问里面视频和图片（chfs，miniserve）
2. 我想自建图床（minio）