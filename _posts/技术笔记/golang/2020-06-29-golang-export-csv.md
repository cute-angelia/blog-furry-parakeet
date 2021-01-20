---
title: golang 导出 csv
tags: [go]
---

为什么写这个， 因为遇到坑了

按 [HTTP Header 规范](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Content-Disposition)

指定头部信息， 就可以下载了

```
	fileName := time.Now().Format("鸡蛋订单20060102150405") + ".csv"
	w.Header().Add("Content-Disposition", fmt.Sprintf(`attachment; filename="%s"`, fileName))
	w.Header().Add("Content-Description", "File Transfer")
	w.Header().Add("Content-Type", "application/octet-stream; charset=utf-8")
	w.Write(b)
```

但是， 如果你前端用的是 axios 的话， 得费一番折腾了, 有几种方式， 第一种是服务端发送 blob 形式，js 接受
第二种是发送文本转 blob ， 下面代码是第二种， 服务端发送了 {content: "xxsxxx", fileName: "xxx.csv"}

```
const url = window.URL.createObjectURL(
  new Blob([new Uint8Array([0xef, 0xbb, 0xbf]), data.content], {
    type: "text/plain;charset=utf-8"
  })
);
const link = document.createElement("a");
link.href = url;
link.setAttribute("download", data.fileName);
document.body.appendChild(link);
link.click();

```

### ps

[golang csv 库推荐](https://github.com/jszwec/csvutil)

[Download files with AJAX (axios)](https://gist.github.com/javilobo8/097c30a233786be52070986d8cdb1743)
