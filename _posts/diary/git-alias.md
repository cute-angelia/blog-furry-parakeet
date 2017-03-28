title: Git Alias
date: 2015-12-4 17:51:38
tags: [git, note]
---

Git Alias提升懒力值

目前有这么个情况：

开发在`test`完成后，需要合并到`beta`再测试，再合并到`online`，那么问题来了，我需要打这么长

````
git checkout beta
git pull origin beta
git merge test
git push origin beta

git checkout online
git pull origin online
git merge beta
git push origin online
````

真心够了，键盘都敲坏了。祭出`ONE PUNCH MAN`

<!-- more -->

![琦玉](http://img1.wikia.nocookie.net/__cb20140324041430/p__/protagonist/images/d/dd/Saitama_OK.jpg)

## git alias

[官方建议](http://git-scm.com/book/en/v1/Git-Basics-Tips-and-Tricks)
[stackoverflow](http://stackoverflow.com/questions/2553786/how-do-i-alias-commands-in-git)

* 放入git配置文件 `~/.gitconfig`

````
[alias]
	lg = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cn %cr)%Creset' --abbrev-commit --date=relative
	beta = !git checkout beta && git pull origin beta && git merge test && git push origin beta && git checkout test
	online = !git checkout online && git pull origin online && git merge beta && git push origin online && git checkout test
	co = checkout
	br = branch
	ci = commit
	st = status
	unstage = reset HEAD --
	last = log -1 HEAD
    chs = !git checkout $1 && git status && git echo x >/dev/null
````

另外种方式，放入Linux系统配置文件`~/.bashrc`

````
alias gst='git status'
alias gl='git pull'
alias gp='git push'
alias gd='git diff | mate'
alias gau='git add --update'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gb='git branch'
alias gba='git branch -a'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcot='git checkout -t'
alias gcotb='git checkout --track -b'
alias glog='git log'
alias glogp='git log --pretty=format:"%h %s" --graph'
````




