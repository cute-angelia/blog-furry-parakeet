---
title: 放弃 hexo
date: 2017-3-25 10:38:45
tags: [hexo]
---

一直用 hexo 搭建博客, 但是经常莫名其妙出错, 稳定性实在是吐槽也吐槽不过来了.
 
决定弃用.

使用失败的同学,给你们一个绝招

````
cp _config.yml _config.yml.bak
rm package.json -f
hexo init
npm install
npm install hexo-deployer-git --save
cp _config.yml.bak _config.yml -f
rm source/_posts/hello-world.md -f
````

Update： 2021年01月07日

为什么弃用：

1. 多台电脑写文章，极易冲突，而且很难解决
2. 每次需要额外执行命令


切换到 Jekyll

1. 直接写 md 就行， 发布就是 git 提交，太方便了