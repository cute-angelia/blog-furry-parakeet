title: 配置Sublime Text使用Markdown，语法高亮,生成HTML
tags : [markdown, sublime]
date: 2013-01-10 17:41:48
---


在知道jekyll是支持Markdown的时候，我就去学习了。
Markdown语法清晰，简介。很适合学习


**了解Sublime Text和Markdown**

Sublimne Text是最近一个非常火的编辑器，代码编辑器，速度非常快，功能非常强大。非常好用，而且跨Windows，Mac，Linux平台，有用Python API的插件，主题也支持，但是主题不是特别多。
Markdown是一种比较简单的标记语言，让你写文档的时候可以有结构，用纯文本编辑，可以纯文本阅读，也可以转换成HTML，让它有富文本的特性，如粗体，斜体，添加引用，图片链接。现在我主要都是用Markdown来写写笔记。


**安装Sublime Text,Python,Python Markdown**

[下载Sublime Text] (http://www.sublimetext.com/)
Sublime Text下载后是exe程序，下一步下一步安装就好了。

**安装Markdown插件**

写到这里，我推荐你了解一下
 [Sublime Text2基本使用方法] (http://lucifr.com/2011/08/31/sublime-text-2-tricks-and-tips/)
有了上面的知识，我们可以安装Sublime Text的插件了。用Package Control安装Markdown Build和Markdown Preview。安装好了后按Ctrl + Shift + P，输入Markdown就可以看到一些Markdown有关的操作了。我也写了一个关于Markdown的Sublime Text 2的扩展。 Copy to Clipboard，你也可以安装试下。

**配置Markdown语法高亮**

区别Sublime Text的theme和color-scheme,theme是指主题，包括一些编辑器的元素，而color-scheme是指语法高亮的颜色配置。
在了解这个之后，我再次推荐你安装Sublime Text的Sublime Text 2 入门及技巧文中推荐的那个Soda主题，然后在推荐这个Made of Code这个color scheme。由于它的官网<http://madeofcode.com/posts/29>在国内不好访问，可以在这[下载] (https://github.com/kumarnitin/made-of-code-tmbundle)。
color scheme的安装方法，把这个文件放到主题文件夹或者直接放到Package文件夹也可以，在菜单点Preference > Browse Packages,放到那个目录也可以。然后在Preference > Color Scheme里面选择那个对应的就可以了。这个时候还没有高亮，按Ctrl + Shift + P，选择”Set Syntax:Markdown”

<!-- more -->

**修改Sublime Text新建和保存文件时的默认格式**

参考 [这篇文章] (http://imwuyu.me/blog/sublime-assign-default-file-type-and-ext.html/)

**生成HTML**

直接在菜单的Tools - Build就可以生成HTML，快捷键Ctrl+B，生成后会用默认的浏览器打开。如果你按Ctrl + Shift + P用Markdown Preview这个扩展生成也可以，但是代码没有Markdown的代码好。

**其他**

快捷键快速跳转文件的部分 Ctrl + R

可以把文件直接保存到Dropbox里面备份，或者有服务直接把Dropbox里面的Markdown文件转换成博客文章。

### Links
[1]: http://wowubuntu.com/markdown Markdown 语法说明(简体中文版)
[2]: http://timewilltell.me/node/15 配置Sublime Text使用Markdown，语法高亮,生成HTML

* [Markdown 语法说明][1]
* [配置Sublime Text2使用Markdown，语法高亮,生成HTML][2]

