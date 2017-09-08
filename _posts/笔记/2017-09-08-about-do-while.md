---
title: do{...}while(0)的意义和用法
tags: [笔记]
---

在特定的`某些复杂场景`中, 我们会使用goto对程序流进行统一的控制

但是滥用 goto, 往往对项目造成重伤,以至于我们直接把 goto 给关禁闭了

这个时候就可以用do{}while(0)来替代 goto

```
int foo()
{
 
    somestruct* ptr = malloc(...);
 
    do{
        dosomething...;
        if(error)
        {
            break;
        }
 
        dosomething...;
        if(error)
        {
            break;
        }
        dosomething...;
    }while(0);
 
    free(ptr);
    return 0;
 
}
```

这里将函数主体使用do()while(0)包含起来，使用break来代替goto，后续的处理工作在while之后，就能够达到同样的效果。

