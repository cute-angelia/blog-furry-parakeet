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