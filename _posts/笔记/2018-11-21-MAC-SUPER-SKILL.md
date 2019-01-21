---
title: MAC终端命令笔记
tags: [mac]
---

## 需求

在 mac 机器上, 终端用的比较频繁

如: 命令行下用sublime、vscode、atom打开文件或目录
如: 当前文件夹打开命令行

### 当前文件夹打开命令行

正常操作是在文件的右键-服务-打开iterm, 步骤比较多

可以安装一个 Go2shell 的工具

安装过程有一点, 需要在 `application` 文件夹,按 `command` 键拖动 `Go2shell` 到 `Finder` bar 上面...

激活码 `DONATE_BY_FOLLOW`

### 命令行下用sublime、vscode、atom打开文件或目录

如何找路径, 右键查看包内容, 找到执行文件

```
alias atom='/Applications/Atom.app/Contents/MacOS/Atom'
alias subl='/Applications/SublimeText.app/Contents/SharedSupport/bin/subl'
alias code='/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code'
```


vscode 额外:

对于Mac用户，我们需要通过设置使您能够从终端内启动VS Code.首选运行VS code并打开命令面板（ ⇧⌘P ），然后输入 shell command 找到: Install ‘code' command in PATH 。

```
# 有时你想打开或者创建一个文件。如果指定文件不存在，VS Code将会为你创建此文件。
# 你可以通过空格键来分隔许多文件名
code index.html style.css readme.md
```

```
code 
-h code使用说明
-v 版本
-n new
-g 跳转行
-d 对比,打开一个不同的编辑器。需要两个文件路径作为参数。例如：code -d file file


```


