---
title: Git subtree 要不要使用 –squash 参数
tags: [git]
---

Git

[source](http://www.fwolf.com/blog/post/246)

Git submodule 的繁琐似乎是世人皆知了， 所以我用 subtree 来解决上面的包含关系。即： 在 Gregarius 中以 subtree 的方式管理 MagpieRSS， 然后在 MagpieRSS 中以 subtree 的方式管理 Snoopy。

问题的产生

subtree 处理多层包含是没有问题的，因为包含进项目之后， 别人根本看不出这是一个 subtree， 所以它本质上还只是管理本地 repo 的一种方法。

使用 Git subtree 新建或更新子项目的时候，可以选用 --squash 参数， 它的作用就是把 subtree 子项目的更新记录进行合并，再合并到主项目中。

所以，在使用 --squash 参数的情况下， subtree add 或者 pull 操作的结果对应两个 commit， 一个是 Squash 了子项目的历史记录， 一个是 Merge 到主项目中。

这种做法下，主项目的历史记录看起来还是比较整齐的。 但在子项目有更新，需要 subtree pull 的时候，却经常需要处理冲突。 严重的，在每次 subtree pull 的时候都需要重复处理同样的冲突，非常烦人。

如果不使用 --squash 参数，子项目更新的时候，subtree pull 很顺利， 能够自动处理已解决过的冲突，缺点就是子项目的更新记录“污染”了主项目的。

原因分析

简单说，subtree add/pull 操作中，需要用到 merge，而 merge 顺利进行的前提， 是要有相同的 parent commit。对照上面的情况：

使用 --squash 参数，原子项目历史记录被合并后就消失了，相当于一个“新”的提交。 下次再进行 add/pull 时，新添加的内容找不到“上一次的修改”， 于是在更新 subtree 内文件的时候，就会提示冲突，需要手工解决。

不使用 --squash 参数，原子项目的历史复制到了父项目中， 下次再进行 add/pull 时，新增的 commit 能够找到“上一次的修改”， 那么他会像在子项目中逐个 am patch 那样更新 subtree 下的内容， 不会提示冲突。

注：我使用的 Git subtree 是 PPA 上的一个 旧版本 ， 或许新版已经解决了上面的问题。

解决问题

就像 这篇文章 结尾说的那样，是否使用 squash 都是可以的， 但需要在开始阶段作出选择，并 一直坚持下去 。 如果一会儿用一会儿不用，得到的不是两者的优点，而是两者的缺点之和。

出于个人偏好，我既希望能够比较顺利的更新子项目， 又不希望子项目的历史记录直接合并在主项目中。StackOverflow 上有人提到了 一种做法 ， 就是另外建立一个分支进行 –no-squash 的 subtree 更新， 这样就保留了子项目的历史记录，没有烦人的反复冲突问题； 然后在合并到主分支（比如 master）时合并提交（ git merge --squash ）， 这样主项目的主分支上只会体现一个 commit， 比直接 git subtree add/pull --squash 还要简洁。

这种做法也有缺点，但在能够接受的范围内：

新开分支的历史记录比较乱，无视吧
新开分支与 master 分支不同步，记着每次在新开分支上做 subtree 操作之前 要 merge master
在新开分支上进行 subtree split 操作是没有问题的。 merge master 以后，subtree push 操作也没有大问题， 也许刚开始会出现 push 被 reject 的状况。

在这种情况下，可以先在本地 split 一份，比如 git subtree split -P extlib/magpierss -b test --rejoin ， 然后切换到这个 test 分支，可以看到之所以被 reject ， 是因为主项目的那个合并提交也被 split 出来了。 这里会麻烦一些，需要通过 rebase 操作，把这些合并的提交删掉， 换成合并内容包含的每个提交（用 pick HASH）。 成功之后，可以在这个分支直接 push 到 子项目： git push remote_of_subtree branch_on_local:branch_on_remote ， 注意后面是指定将本地的哪个分支 push 进 remote 的哪个分支。 这次 push 会很顺利。 接下来再作一次正常的 subtree pull 就可以了， 下次再进行 subtree split 操作时， split 出来的临时分支和 remote 是一致的。

通过上面 push 的例子可以看出，为了 split 和 push 顺利， 即使用了 subtree 分支， 如果能在 master 分支中保存子项目历史记录还是有好处的。 同时，我们还可以参考这个来决定 subtree 使用策略：

subtree 里面放外围项目，只接收更新，不发送更新， 那么无论是用 squash 还是用 subtree 分支都不麻烦。
将一个大项目拆分成若干小项目， 那么最好不要用 squash，并且活用 subtree， 最好是所有提交都在主项目中作， 然后 subtree split 出子项目来发布， 子项目原则上不直接修改，即和上一条相反， 只向子项目发送更新，不从子项目接收更新。 Symfony2 使用的就是这种做法。
总体上都有些麻烦，subtree 分支算不上是完美解决方法，但看起来好歹清爽了很多。

@link https://github.com/fwolf/magpierss

@link https://github.com/fwolf/gregarius