---
title: vue dialog 组件问题
tags: [vue]
---

为什么写这个， 因为遇到坑了

组件需要传递 props [show] :visible.sync="show"

弹窗关闭引起报错，并且不调起第二次弹框

### 解决办法

报错： 使用内部变量解决

不调起第二次弹框： 绑定 `close` 事件，修改父级传入的 props 【show】

组件

```
<el-dialog title="鸡蛋详情" :visible.sync="show" @close="updateShowDialog" width="80%">


export default {
  props: {
    showDialog: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      show: this.showDialog,



  methods: {
    updateShowDialog() {
      this.$emit("updateDialogEggDetailShow", false);
    },



```

父级

```
    <!-- 鸡蛋详情 -->
    <EggDetail
      v-if="dialogEggDetailShow"
      @updateDialogEggDetailShow="updateDialogEggDetailShow"
      :show-dialog.sync="dialogEggDetailShow"
    ></EggDetail>


```
