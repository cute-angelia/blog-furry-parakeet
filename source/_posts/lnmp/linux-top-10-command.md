title: Linux 打印你最常用的命令
date: 2014-09-16 09:50:30
tags: [linux]
---
  
哈，非常简单，输入下面命名将打印你最常用的命令

    history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n10


     1	249  24.9%  ls
     2	204  20.4%  cd
     3	122  12.2%  vim
     4	76   7.6%   hexo
     5	46   4.6%   git
     6	34   3.4%   ps
     7	30   3%     cat
     8	14   1.4%   sh
     9	13   1.3%   rm
    10	13   1.3%   php


