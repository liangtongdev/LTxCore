## LTxCore

组件化管理(构建)移动应用


### 使用例子

#### 程序主体颜色等配置

根据需要配置，如果不需要，则忽略即可

```Objective-C
    //程序主色调。导航栏颜色等
    [LTxCoreConfig sharedInstance].skinColor = [UIColor brownColor];
    [[LTxCoreConfig sharedInstance] appSetup];

    //文件系统，数据库初始化 - 如果用到断点下载等功能，需要配置
    [LTxCoreFileManager fileManagerInit];
    [LTxCoreDatabase tablesInit];
```

#### 容器

```Objective-C
@interface MainTableViewController : LTxCoreBaseTableViewController
@end


[self addPullDownRefresh:^{
        //下拉刷新
    } andPullUpRefresh:^{
        //上拉加载更多
    }];

```


#### 文件预览

```Objective-C
        LTxCoreFilePreviewViewController* previewVC = [[LTxCoreFilePreviewViewController alloc] init];
        previewVC.fileURL = [NSURL URLWithString:@"https://developer.apple.com/ibeacon/Getting-Started-with-iBeacon.pdf"];
        previewVC.shareWithOtherApp = YES;
        previewVC.needToDownload = YES;
        previewVC.preferCache = YES;
        [self.navigationController pushViewController:previewVC animated:YES];
```



#### 配置文件<部分摘取>

```Info.plist
	<key>type</key>
	<string>debug</string>
	<key>appId</key>
	<string>ebe2ea6b-5974-46d8-b3e2-5e9808889aad</string>
	<key>pushId</key>
	<string>726566836973cbcd74c5ed54</string>
	<key>pageSize</key>
	<integer>20</integer>
```



### 其他

#### 为什么要对项目进行组件化维护？

随着负责的项目数量增加，通用的代码升级(适配)成了问题。

前期虽然对代码做了封装，可不同工程通过代码copy的形式进行维护很容易遗漏甚至出现冲突。



#### 为什么分开维护组件？

+ 保证更新/验证能够快速进行。
+ 目标清晰，快速编译等。




#### 定制化组件？

Master中主要针对共通部分开发，定制化内容在branch中进行，通过建立不同的tag供使用


#### Release Log

+  0.5.2 (2018/08/28)  - 添加ShareHost相关配置

+  0.5.0 (2018/07/25)  - Cocoapods-related file bug-fix


+  0.0.2 (2018/07/17)  - 文件预览
     + 文件预览
     +  后台下载


+  0.0.1 (2018/07/14)  - 初版发布
     + 基类、工具、程序配置

#### Contacts

liangtongdev@163.com
