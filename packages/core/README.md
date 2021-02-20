# core

Core Module
提供最基本的依赖注入，路由管理
TODO 错误处理


## Setup
https://github.com/Baseflow/flutter-permission-handler

## Dependency Injection:
唯一推荐的注入方法：
为Class设置无参构造函数，然后在`Module`文件 `configureServices` 中使用`get_it`注入`new`instance，如果需要依赖其他的Class, mixin `ServiceGetter`然后使用属性获取，
因为绝大部分类都会被注入成单例，如果不是Lazy的类，后面会Module替换掉的话会不起作用




