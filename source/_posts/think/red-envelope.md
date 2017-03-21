title: 抢红包
date: 2016-08-17 18:00:41
tags: [红包, think]
---

## 抢红包需求

红包在我看来，作用在提升用户粘性，增加双方互动，提升用户存在感

用户添加红包（金额，个数），要求最低金额为1元，最小单位为元，取消其他单位（角，分）


## 微信红包算法

> 红包里的金额怎么算？为什么出现各个红包金额相差很大？
> 答：随机，额度在0.01和剩余平均值*2之间。

> 例如：发100块钱，总共10个红包，那么平均值是10块钱一个，那么发出来的红包的额度在0.01元～20元之间波动。
当前面3个红包总共被领了40块钱时，剩下60块钱，总共7个红包，那么这7个红包的额度在：0.01～（60/7*2）=17.14之间。
注意：这里的算法是每被抢一个后，剩下的会再次执行上面的这样的算法

> 这样算下去，会超过最开始的全部金额，因此到了最后面如果不够这么算，那么会采取如下算法：保证剩余用户能拿到最低1分钱即可。

> 如果前面的人手气不好，那么后面的余额越多，红包额度也就越多，因此实际概率一样的。

````
不知道哪里流出的

public static double getRandomMoney(RedPackage _redPackage) {
    // remainSize 剩余的红包数量
    // remainMoney 剩余的钱
    if (_redPackage.remainSize == 1) {
        _redPackage.remainSize--;
        return (double) Math.round(_redPackage.remainMoney * 100) / 100;
    }
    Random r     = new Random();
    double min   = 0.01; //
    double max   = _redPackage.remainMoney / _redPackage.remainSize * 2;
    double money = r.nextDouble() * max;
    money = money <= min ? 0.01: money;
    money = Math.floor(money * 100) / 100;
    _redPackage.remainSize--;
    _redPackage.remainMoney -= money;
    return money;
}

````

> 微信的金额什么时候算？

> 答：微信金额是拆的时候实时算出来，不是预先分配的，采用的是纯内存计算，不需要预算空间存储。
> 采取实时计算金额的考虑：预算需要占存储，实时效率很高，预算才效率低。

<!-- more -->

## 按需求红包设计

1. 随机，额度在1和剩余平均值*2之间（随机值如果是边界值，排除重新计算或者预留1）
2. 这里不采用微信机制实时计算，红包先预先算法算好生成


````

  +-------------+      +-------------+
  |             |      |             |
  |    Ios      |      |   Android   |
  |             |      |             |
  +-------------+---+--+-------------+
                    |
                    |
       +------------+-------------+
       |                          |
+------v--------+        +--------v---------+
|               |        |                  |
|  RedEnvelope  |        |     GateWay      |
|               |        |                  |
+---------------+        +---------+--------+
                                   |
                         +---------v--------+
                         |                  |
                         |     Logic        |
                         |                  |
                         +------------------+

 ````



用户创建红包，向 `GateWay` 发送请求，并转发到 ｀Logic｀

用户抢红包，向 `RedEnvelope` 发送请求，并告知抢红包结果

## 表设计

id, title, size, monkey,

## 参考

[参考1](http://coderroc.com/)

<abbr title="End of file">EOF</abbr>
