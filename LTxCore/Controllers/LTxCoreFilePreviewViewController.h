//
//  LTxCoreFilePreviewViewController.h
//  LTxCore
//
//  Created by liangtong on 2018/7/16.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import "LTxCoreBaseViewController.h"
#import "LTxCoreFile.h"

/**
 * 文件预览页面，支持（使用）第三方应用打开链接
 * 支持的文件包括以下格式
 * （1）图片
 * （2）音/视频
 * （3）文档
 * （4）网页
 * 其他(用网页控件打开)
 **/
@interface LTxCoreFilePreviewViewController : LTxCoreBaseViewController

//是否支持其他应用打开
@property (nonatomic, assign) BOOL shareWithOtherApp;

#pragma mark - 本地文件
//文件地址
@property (nonatomic, strong) NSURL* filePath;

#pragma mark - 在线文件
//是否需要下载
@property (nonatomic, assign) BOOL needToDownload;
//是否优先使用缓存
@property (nonatomic, assign) BOOL preferCache;
//文件地址
@property (nonatomic, strong) NSURL* fileURL;

@end
