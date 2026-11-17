# HarmonyOS 面试知识点清单

> 本清单基于 QuestionBankApplication 项目涉及的技术点整理

---

## 一、ArkTS 语言特性

### 1. @Component / @ComponentV2
- struct + @Component 定义组件
- @ComponentV2 是 V2 版本装饰器
- build() 方法是组件的唯一入口
- 文件名即组件名的约定

### 2. 状态管理装饰器
**常用：**
- `@State` — 组件内部状态，变化时自动触发 UI 刷新
- `@Prop` — 父→子单向数据传递
- `@StorageProp('key')` — 绑定 AppStorage 全局状态
- `@Watch('fn')` — 监听状态变量变化
- `@Link` — 父→子双向同步

**V2 版（@ComponentV2）：**
- `@Local` 替代 @State
- `@Param @Require` 替代 @Prop
- `@Monitor('x')` 装饰在方法上替代 @Watch

**面试常问：**
- @State 和 @Prop 的区别
- 数据更新时 UI 如何刷新
- 父子组件通信方式有哪些
- @StorageProp 和 @LocalStorageProp 区别

### 3. 类型限制
- 禁止 any、unknown
- 禁止 object → 基本类型强制转换（如 `obj as number`）
- catch 只能写 `catch(err)`，不能指定类型
- 不能 throw 任意类型（只建议 throw Error 子类）
- 内联对象字面量必须有接口/类声明

---

## 二、UI 布局

### 1. 基础组件
- `Column` / `Row` / `Stack` — 三大布局容器
- `Blank()` — 弹性占位空间
- `Divider` — 分割线
- `Text` / `TextInput` / `Image` / `Button`

### 2. 滚动与列表
- `Scroll` — 可滚动区域
- `List` + `ListItem` — 长列表（支持复用）
- `ForEach` — 循环渲染
- `Swiper` — 轮播图

### 3. 布局属性
- `.width()` / `.height()` — 尺寸设置
- `.layoutWeight(1)` — 弹性权重，占满剩余空间
- `.margin()` / `.padding()` — 外边距/内边距
- `.borderRadius()` — 圆角（可分别设置四个角）
- `.clip(true)` — 裁剪溢出内容
- `.justifyContent()` / `.alignItems()` / `.alignContent()` — 对齐方式

### 4. 多重嵌套 Column/Row 的作用
- 限制子组件尺寸
- 用固定高度 + Blank() 稳定布局
- 防止溢出导致手势冲突

**面试常问：**
- layoutWeight 和 height('100%') 的区别
- 布局溢出如何解决
- List 滑动冲突怎么处理

---

## 三、Navigation 路由

### 1. NavPathStack 导航
- `NavPathStack` — 导航栈控制器
- `pushPath()` / `pushPathByName()` — 压栈导航
- `pop()` — 返回上一页
- `clear()` — 清空导航栈

### 2. 系统路由表
- `route_map.json` — 注册页面路由
- `buildFunction` — @Builder 构建函数入口
- `data` — 自定义配置（如 needLogin）

### 3. NavDestination
- 页面容器组件
- `.hideTitleBar(true)` — 隐藏标题栏
- `.onReady()` — 页面就绪回调，接收路由参数
- `.hideToolBar(true)` — 隐藏工具栏

### 4. 拦截器
- `setInterception()` — 监听页面切换
- `willShow` 回调 — 页面显示前触发
- 可用于登录权限校验（needLogin）

### 5. 参数传递
- `getParamByName('pageName')` — 返回 `unknown[]`
- `context.pathInfo.param` — .onReady 回调中获取

**面试常问：**
- 页面间如何传参
- 路由拦截器有什么用
- NavDestination 和 Navigation 的关系

---

## 四、网络请求

### 1. @ohos/axios
- 鸿蒙适配版的 axios
- 支持 Promise、拦截器、泛型
- 需配置 `ohos.permission.INTERNET`

### 2. 拦截器机制
- **请求拦截器**：自动注入 token、统一设置请求头
- **响应拦截器**：统一剥壳、统一错误处理（如 401 跳登录）
- 拦截器执行顺序：请求拦截器 → 请求 → 响应拦截器 → .then/.catch

### 3. 请求配置
- `baseURL` — 基础地址
- `timeout` — 超时时间
- `headers` — 请求头
- `params` — URL 查询参数
- `data` — 请求体

### 4. 错误处理
- `AxiosError` — 错误类型
- `.code` — 错误码（如 ERR_BAD_REQUEST）
- `.message` — 错误描述
- `.response?.status` — HTTP 状态码
- 业务码校验（如 code: 10000 表示成功）

---

## 五、AppStorage 全局状态

### 1. 基本用法
- `AppStorage.setOrCreate('key', value)` — 设置全局状态
- `AppStorage.get<T>('key')` — 读取全局状态
- `@StorageProp('key')` — 组件中绑定 AppStorage

### 2. 应用场景
- 登录状态（isLogin）
- 用户信息（user token）
- 跨 Tab 数据同步

**面试常问：**
- AppStorage 和 @State 的区别
- 如何实现跨组件数据共享
- 登录状态变化如何通知所有组件

---

## 六、生命周期

### 1. 组件生命周期
- `aboutToAppear()` — 组件创建后、build 前执行
- `aboutToDisappear()` — 组件销毁前执行
- `build()` — 渲染 UI

### 2. NavDestination 生命周期
- `.onReady()` — 页面就绪
- `.onShown()` — 页面显示
- `.onHidden()` — 页面隐藏
- `.onWillShow()` / `.onWillHide()`

### 3. Tabs 下的生命周期
- TabContent 在 TabsPage 创建时一次性初始化
- aboutToAppear 只执行一次，**Tab 切换不会再次触发**
- 需要监听 AppStorage 状态变化来刷新数据

**面试常问：**
- aboutToAppear 在 Tab 切换时会不会重新执行
- 如何实现从登录页返回后自动刷新数据
- onReady 和 aboutToAppear 的执行顺序

---

## 七、@Builder 构建函数

### 1. 路由入口
```typescript
@Builder
export function PageBuilder() {
  Page()
}
```
- 用于 route_map 的 buildFunction 引用
- 必须导出、且是顶层函数

### 2. 组件内 @Builder
- 抽离重复 UI 片段
- 支持参数传递
- 可在 build 方法中多次调用

**面试常问：**
- @Builder 和自定义组件 @Component 的区别
- 什么时候该用 @Builder，什么时候该抽成 @Component
- @Builder 能否被外部调用

---

## 八、响应式与数据驱动

### 1. 状态驱动 UI
- @State 变量变化 → UI 自动重新渲染
- @StorageProp 变化 → 所有绑定的组件自动更新
- @Watch 监听变化触发副作用

### 2. 条件渲染
- `if / else` — 在 build() 中控制组件显示
- 切换 clickIndex 时切换数据源

### 3. 数据流模式
- 父组件 @State → 子组件 @Prop（单向）
- 全局状态 AppStorage → 任何组件 @StorageProp
- 回调函数（如 close 回调）实现子→父通信

---

## 九、网络请求封装架构

```
api/HttpRequtsts.ets          ← 业务层 API 函数
comments/utils/HttpClient.ets ← 底层 HTTP 封装（拦截器、axios 实例）
                               ├── 请求拦截器：注入 token
                               └── 响应拦截器：剥壳、错误处理
```

**这个架构体现了：**
- 关注点分离
- 单一职责
- 可替换性（底层库可替换而不影响业务代码）
- DRY 原则（不重复写 token 注入逻辑）

---

## 十、常见踩坑总结

| 问题 | 原因 | 解决 |
|------|------|------|
| aboutToAppear 只执行一次，登录后不刷新 | TabContent 一次性初始化 | @StorageProp + @Watch 监听登录状态 |
| 内联对象传参报错 | ArkTS 禁止未类型化的对象字面量 | 先声明类型变量 |
| 路由拦截器崩溃 | getConfigInRouteMap 在运行时不存在 | try-catch 包裹 |
| 圆角不生效 | Stack 的 clip 不裁剪自身背景色 | 把背景色和 borderRadius 移到 Column |
| 文本变长撑开布局 | space 固定值 + fixed height | 去掉 space，用 Blank() 弹性调节 |
| List 弹回顶部 | 父容器 .height('100%') 溢出 | 子组件用 layoutWeight(1) |

---

## 面试官可能会追问的问题

1. **"这个项目你遇到最大的坑是什么"**
   → 可以说 NavDestination 嵌套问题、getConfigInRouteMap 崩溃、Tab 刷新的生命周期问题

2. **"为什么不用 any？ArkTS 有什么限制"**
   → 可以从类型安全角度回答，同时展示你对 ArkTS 规则的了解

3. **"你怎么设计网络请求层"**
   → 分层架构 + 拦截器 + 统一错误处理

4. **"怎么处理登录态过期"**
   → 响应拦截器检测 401 → 清空用户 → 跳转登录页

5. **"V1 和 V2 装饰器有什么区别"**
   → @State→@Local, @Prop→@Param, @Watch→@Monitor

6. **"怎么保证多个 Tab 页数据同步"**
   → AppStorage + @StorageProp + @Watch
