## LTxCore

组件化管理(构建)移动应用



#### 为什么要对项目进行组件化维护？

随着负责的项目数量增加，通用的代码升级(适配)成了问题。

前期虽然对代码做了封装，可不同工程通过代码copy的形式进行维护很容易遗漏甚至出现冲突。



#### 为什么分开维护组件？

+ 保证更新/验证能够快速进行。
+ 目标清晰，快速编译等。




#### 定制化组件？

Master中主要针对共通部分开发，定制化内容在branch中进行，通过建立不同的tag供使用