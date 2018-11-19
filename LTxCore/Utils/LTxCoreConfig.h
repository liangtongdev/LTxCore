//
//  LTxCoreConfig.h
//  LTxCore
//
//  Created by liangtong on 2018/7/13.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LTxCoreMacroDef.h"
#import <LTxCategories/LTxCategories.h>
/**
 * 配置文件
 * 默认从工程Bundle中读取LTxCoreConfig.plist文件
 **/
@interface LTxCoreConfig : NSObject

/**
 * 单例模式
 **/
+ (instancetype)sharedInstance;

/**
 * 系统初始化
 **/
- (void)appSetup;

#pragma mark - 颜色
@property (nonatomic, strong) UIColor* skinColor;
@property (nonatomic, strong) UIColor* hintColor;
@property (nonatomic, strong) UIColor* activityViewBackgroundColor;
@property (nonatomic, strong) UIColor* viewBackgroundColor;
@property (nonatomic, strong) UIColor* cellContentViewColor;
@property (nonatomic, assign) CGColorRef cellContentViewShadowColor;

#pragma mark

@property (nonatomic, readonly) BOOL isDebug;

#pragma mark - 签名验证
@property (nonatomic, readonly) BOOL signature;//是否开启签名验证
@property (nonatomic, readonly) NSString* signatureToken;//签名验证时的Token

#pragma mark - host
@property (nonatomic, strong) NSString* host;
@property (nonatomic, strong) NSString* messageHost;
@property (nonatomic, strong) NSString* eepmHost;
@property (nonatomic, strong) NSString* serviceHost;
@property (nonatomic, strong) NSString* shareHost;

#pragma mark - 系统配置
@property (nonatomic, strong) NSString* appId;
@property (nonatomic, strong) NSString* pushId;
@property (nonatomic, strong) NSNumber* userId;
@property (nonatomic, strong) NSString* userNumber;
@property (nonatomic, assign) NSInteger pageSize;

#pragma mark - 其他
@property (nonatomic, strong) NSString* instalUrl;
@property (nonatomic, strong) NSString* instalTip;
@property (nonatomic, strong) NSString* aboutTip;
@property (nonatomic, strong) NSString* loginTip;
@property (nonatomic, assign) BOOL cameraAlbumCustom;// 保存相片/视频时，是否使用自定义相册

#pragma mark - 下载
//是否后台下载
@property (nonatomic, readonly) BOOL enableBackgroundDownload;
//某个时间点上最大的下载个数(大于0)，默认为2
@property (nonatomic, readonly) NSInteger maxDownloadingCount;

@end
