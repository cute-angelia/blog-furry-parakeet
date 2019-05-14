---
title: some stuff about golang
tags: [go]
---

### 遍历一个月的每一天

```
	inDay := "2019-05-03"
	m, _ := time.Parse("2006-1-2", inDay)

	// 如果传入的日子不是第一天,需求从第一天开始, 做一个处理
	if m.Day() > 0 {
		m = m.AddDate(0, 0, -m.Day()+1)
	}

	for d := m; d.Month() == m.Month(); d = d.AddDate(0, 0, 1) {
		log.Println(d.Day())
	}
	
   // 2019/05/14 16:32:02 1
   // 2019/05/14 16:32:02 2
   // 2019/05/14 16:32:02 ...
   // 2019/05/14 16:32:02 4
```

###  golang map 并发读写问题

[blog.golang.org](https://blog.golang.org/go-maps-in-action)

```
package main

import "sync"

type SafeMap struct {
    sync.RWMutex
    Map map[int]int
}

func main() {
    safeMap := newSafeMap(10)

    for i := 0; i < 100000; i++ {
        go safeMap.writeMap(i, i)
        go safeMap.readMap(i)
    }

}

func newSafeMap(size int) *SafeMap {
    sm := new(SafeMap)
    sm.Map = make(map[int]int)
    return sm

}

func (sm *SafeMap) readMap(key int) int {
    sm.RLock()
    value := sm.Map[key]
    sm.RUnlock()
    return value
}

func (sm *SafeMap) writeMap(key int, value int) {
    sm.Lock()
    sm.Map[key] = value
    sm.Unlock()
}
```

