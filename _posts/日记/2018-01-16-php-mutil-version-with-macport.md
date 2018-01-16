---
title: MacPort PHP 多版本切换正确姿势
tags: [php]
---

如果使用 macport 管理 php 版本的同学, 我们不应该用软链接管理 `/usr/bin`

应该用:

```
port select --set php php71
```

切换版本.


```
→ which php
/opt/local/bin/php

→ ll /opt/local/bin/php
lrwxr-xr-x  1 vanilla  admin    20B  1 16 15:36 /opt/local/bin/php -> /opt/local/bin/php71
```





