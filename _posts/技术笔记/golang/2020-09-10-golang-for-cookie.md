---
title: golang cookie [转]
tags: [go]
---

在做爬虫时有时候会遇到需要带已登录的 cookie 请求，这个时候最简单的方法是在浏览器登录后，在开发者面板找到 cookie 字符串，然后拷贝粘贴。这就面临一个问题需要把 cookie 字符串解析成 Go 语言 cookie 结构体。

可以通过 net/http 库转换，有两种方式可以较好实现：

### 方式一

使用 ReadRequest

```
package main

import (
    "bufio"
    "fmt"
    "net/http"
    "strings"
)

func main() {
    rawCookies := "cookie1=value1;cookie2=value2"
    rawRequest := fmt.Sprintf("GET / HTTP/1.0\r\nCookie: %s\r\n\r\n", rawCookies)

    req, err := http.ReadRequest(bufio.NewReader(strings.NewReader(rawRequest)))

    if err == nil {
        cookies := req.Cookies()
        fmt.Println(cookies)
    }
}
```

### 方式二

使用 header

```
package main

import (
    "fmt"
    "net/http"
)

func main() {
    rawCookies := "cookie1=value1;cookie2=value2"

    header := http.Header{}
    header.Add("Cookie", rawCookies)
    request := http.Request{Header: header}

    fmt.Println(request.Cookies()) // [cookie1=value1 cookie2=value2]
}
```

[转](https://golangnote.com/topic/271.html)
