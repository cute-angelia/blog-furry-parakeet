---
title: 图片瀑布流性能优化
tags: [vue, masonry]
---

瀑布流页面，滚动加载更多图片，图片加载到 80-100 张时候， 浏览器明显卡顿

## 优化

不在可视区域的图片直接替换成空 div，用户滚回来的时候再替换回来，like tumblr archive page

```
<template>
  <div>
    <div v-for="(item,key) in imgs" ref="cards" :key="key" :data-index="key" :class="item.isOptimized == false ? 'placeholders' : 'placeholdersno'" >
      <img v-if="item.isOptimized" style="width:150px;" :src="item.src" alt="">
    </div>
  </div>
</template>
<script>
import throttle from 'raf-throttle'

export default {
  data() {
    return {
      imgs: [
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        }
      ]
    }
  },
  mounted() {
    this.addOptimizeScrollListener();
  },
  beforeDestroy() {
    document.removeEventListener('scroll', this._optimizeListener, false);
  },
  methods: {
    addOptimizeScrollListener() {
      const windowHeight = window.innerHeight;
      const TOLERANCE_HEIGHT = 300;

      var that = this;

      this._optimizeListener = throttle(() => {
        if (this.$refs.cards) {
          const windowScrollY = window.scrollY;
          this.$refs.cards.forEach(card => {

            var postion = that.getPosition(card)
            var index = card.getAttribute("data-index");

            if (postion.y > windowScrollY + (windowHeight + TOLERANCE_HEIGHT) || postion.y < windowScrollY - (windowHeight + TOLERANCE_HEIGHT)) {
              that.imgs[index].isOptimized = false;
            } else {
              that.imgs[index].isOptimized = true;
            }
            // console.log(card.getAttribute("data-index"), postion.y, windowScrollY + (windowHeight + TOLERANCE_HEIGHT),postion.y > windowScrollY + (windowHeight + TOLERANCE_HEIGHT),postion.y > windowScrollY - (windowHeight + TOLERANCE_HEIGHT) )
          });
        }
      });
      document.addEventListener('scroll', this._optimizeListener, false);
    },
    getPosition(el) {
      var x = 0; var y = 0;
      while (el != null && (el.tagName || '').toLowerCase() != 'html') {
        x += el.offsetLeft || 0;
        y += el.offsetTop || 0;
        el = el.parentElement;
      }
      return { x: parseInt(x, 10), y: parseInt(y, 10) };
    }
  }
}
</script>

<style scoped>
.placeholders {
  height: 150px;
  width: 150px;
  background: linear-gradient(to left bottom, #27e3f8,#c8f4f7);
}

.placeholdersno {
  height: 150px;
  width: 150px;
}
</style>

```

图片父级的高度和宽度，可以在判断 isOptimized 的时候赋值给 img 当一个属性

参考

1. [图片视频瀑布流长列表性能优化实践](https://www.jianshu.com/p/8b6cc4e49d50)

### Demo1 滚动条方式

```
<template>
  <div>
    <div v-for="(item,key) in imgs" ref="cards" :key="key" :data-index="key" :class="item.isOptimized == false ? 'placeholders' : 'placeholdersno'" >
      <img v-if="item.isOptimized" style="width:150px;" :src="item.src" alt="">
    </div>
  </div>
</template>
<script>
import throttle from 'raf-throttle'

export default {
  data() {
    return {
      imgs: [
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        }
      ]
    }
  },
  mounted() {
    this.addOptimizeScrollListener();
  },
  beforeDestroy() {
    document.removeEventListener('scroll', this._optimizeListener, false);
  },
  methods: {
    addOptimizeScrollListener() {
      const windowHeight = window.innerHeight;
      const TOLERANCE_HEIGHT = 300;

      var that = this;

      this._optimizeListener = throttle(() => {
        if (this.$refs.cards) {
          const windowScrollY = window.scrollY;
          this.$refs.cards.forEach(card => {

            var postion = that.getPosition(card)
            var index = card.getAttribute("data-index");

            if (postion.y > windowScrollY + (windowHeight + TOLERANCE_HEIGHT) || postion.y < windowScrollY - (windowHeight + TOLERANCE_HEIGHT)) {
              that.imgs[index].isOptimized = false;
            } else {
              that.imgs[index].isOptimized = true;
            }
            // console.log(card.getAttribute("data-index"), postion.y, windowScrollY + (windowHeight + TOLERANCE_HEIGHT),postion.y > windowScrollY + (windowHeight + TOLERANCE_HEIGHT),postion.y > windowScrollY - (windowHeight + TOLERANCE_HEIGHT) )
          });
        }
      });
      document.addEventListener('scroll', this._optimizeListener, false);
    },
    getPosition(el) {
      var x = 0; var y = 0;
      while (el != null && (el.tagName || '').toLowerCase() != 'html') {
        x += el.offsetLeft || 0;
        y += el.offsetTop || 0;
        el = el.parentElement;
      }
      return { x: parseInt(x, 10), y: parseInt(y, 10) };
    }
  }
}
</script>

<style scoped>
.placeholders {
  height: 150px;
  width: 150px;
  background: linear-gradient(to left bottom, #27e3f8,#c8f4f7);
}

.placeholdersno {
  height: 150px;
  width: 150px;
}
</style>

```

### Demo2 交叉观察者

```
<template>
  <div>
    <div v-for="(item,key) in imgs" ref="cards" :key="key" :data-index="key" :class="item.isOptimized == false ? 'placeholders' : 'placeholdersno'" >
      <img v-if="item.isOptimized" style="width:150px;" :src="item.src" alt="">
    </div>
  </div>
</template>
<script>

export default {
  data() {
    return {
      observer: null,
      imgs: [
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        },
        {
          src: 'https://image.suning.cn/uimg/ZR/share_order/159194414707857929.jpg',
          isOptimized: false
        }
      ]
    }
  },
  mounted() {
    var that = this;
    this.makeObserver().then((observer) => {
      if (that.$refs.cards) {
        that.$refs.cards.forEach(card => {
          observer.observe(card)
        })
      }
    })
  },
  methods: {
    // 观察对象
    makeObserver() {
      var that = this;
      that.observer = new IntersectionObserver(
        function(changes) {
          changes.forEach(function(change) {
            var container = change.target;
            // show
            var index = container.getAttribute("data-index");
            if (change.isIntersecting) {
              that.imgs[index].isOptimized = true;
            } else {
              that.imgs[index].isOptimized = false;
            }
          });
        }
      );
      return new Promise(resolve => {
        resolve(that.observer)
      })
    }
  }
}
</script>

<style scoped>
.placeholders {
  height: 150px;
  width: 150px;
  background: linear-gradient(to left bottom, #27e3f8,#c8f4f7);
}

.placeholdersno {
  height: 150px;
  width: 150px;
}
</style>

```
