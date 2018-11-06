# 如何不用 redis 设计一个排行榜

在通用排行榜采用 redis 的 `sorted set` 作为解决方案已经是通用方案了

但业务需求并不是单一需求, 比如玩家最近一关的破解时间来排定, 既鼓励准确率, 又鼓励速度. 换句话说, coin(金币)为第一排序因素, time(破解时间)为第二排序因素.

而 redis 的 `sorted set` 是单一维度, 只有一个 `score` 如何解决两个维度的数据排行呢?

很多常规思路是把多维转成一维, 然后将数据存入 `score`

另外一种思路是将两个因素并入一个因素, 很幸运 coin + time 可以并成一个 score 从而免除一些逻辑计算

当然这篇文章并不是介绍 redis 的

# buntdb

BuntDB is an embeddable, in-memory key/value database for Go with custom indexing and geospatial support

直接上代码, 看下BuntDB解决方案, 天生支持多维索引, 厉害了

```
db, _ := buntdb.Open(":memory:")
db.CreateIndex("last_name_age", "*", buntdb.IndexJSON("name.last"), buntdb.IndexJSON("age"))
db.Update(func(tx *buntdb.Tx) error {
	tx.Set("1", `{"name":{"first":"Tom","last":"Johnson"},"age":38}`, nil)
	tx.Set("2", `{"name":{"first":"Janet","last":"Prichard"},"age":47}`, nil)
	tx.Set("3", `{"name":{"first":"Carol","last":"Anderson"},"age":52}`, nil)
	tx.Set("4", `{"name":{"first":"Alan","last":"Cooper"},"age":28}`, nil)
	tx.Set("5", `{"name":{"first":"Sam","last":"Anderson"},"age":51}`, nil)
	tx.Set("6", `{"name":{"first":"Melinda","last":"Prichard"},"age":44}`, nil)
	return nil
})
db.View(func(tx *buntdb.Tx) error {
	tx.Ascend("last_name_age", func(key, value string) bool {
		fmt.Printf("%s: %s\n", key, value)
		return true
	})
	return nil
})

// Output:
// 5: {"name":{"first":"Sam","last":"Anderson"},"age":51}
// 3: {"name":{"first":"Carol","last":"Anderson"},"age":52}
// 4: {"name":{"first":"Alan","last":"Cooper"},"age":28}
// 1: {"name":{"first":"Tom","last":"Johnson"},"age":38}
// 6: {"name":{"first":"Melinda","last":"Prichard"},"age":44}
// 2: {"name":{"first":"Janet","last":"Prichard"},"age":47}

```

排行榜数据多, 几个维度都没有问题, 值得注意的是排序字段, 如果是数字型, json 里面必须也是数字型, 字符型的数字排序会有问题

