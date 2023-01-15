RegExpo 项目的表现

下面来看一下 RegExpo 在不同平台的表现，如下是 Macos 桌面端的视图表现。最主要的功能是输入正则表达式时，主内容区域的文字根据匹配效果，进行高亮显示：

![2022年12月23日13-49-34.gif](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f7212ac4de7e4646997e2b8766e116fb~tplv-k3u1fbpfcp-watermark.image?)


应用支持暗黑模式和亮色模式的切换：

![2022年12月23日14-40-06.gif](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/af5f5cea6e1943c28def73c5704f2a75~tplv-k3u1fbpfcp-watermark.image?)

---

另外，也会介绍 MacOS 、Windows 中的系统托盘的使用：


![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3f207aaf028f4771bc9b9e0a125776e1~tplv-k3u1fbpfcp-watermark.image?)

---

在 `Web` 在也有相同的界面展示效果和交互功能：


![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c51920aaa8bc4f96981d45b158f7caf6~tplv-k3u1fbpfcp-watermark.image?)

---

同时在视图界面上也适配了移动端，如下以 Android 移动端为例，iOS 中界面表现一致：

| 移动端 - 亮  | 移动端 - 暗 |
| --- | --- |
| ![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/68842e4d1954433a8be3f470457bc4c4~tplv-k3u1fbpfcp-watermark.image?) | ![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a37f658d68ea4a45b9b2cfad8147297f~tplv-k3u1fbpfcp-watermark.image?) |

----

除此之外，还有 `记录` 和  `关联正则` 两大需求。这两者对应的数据存放在 `sqlite` 数据库中，所以支持对数据的 `增删改查` 操作：

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/7f2979946f6341d9908cb208f5aed174~tplv-k3u1fbpfcp-watermark.image?)


如下所示，记录面板选择记录后，会更新中间内容文字信息；另外每个`记录`对应着若干个 `关联正则`，在记录切换时，会影响关联正则面板的数据；关联面板中选中对于的正则表达式，又会影响输入框文字，进而通过更新正则影响中间内容的高亮。

![2022年12月23日14-09-46.gif](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/055dfdb8599949dfbfc3e14343c8758e~tplv-k3u1fbpfcp-watermark.image?)
