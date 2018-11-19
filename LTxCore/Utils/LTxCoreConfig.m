//
//  LTxCoreConfig.m
//  LTxCore
//
//  Created by liangtong on 2018/7/13.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import "LTxCoreConfig.h"

@interface LTxCoreConfig()
@property (nonatomic, readwrite) BOOL isDebug;
@property (nonatomic, readwrite) BOOL signature;//是否开启签名验证
@property (nonatomic, strong, readwrite) NSString* signatureToken;//签名验证时的Token

@property (nonatomic, assign, readwrite) BOOL enableBackgroundDownload;//后台下载
@property (nonatomic, assign, readwrite) NSInteger maxDownloadingCount;//最大下载数量
@end
@implementation LTxCoreConfig
/**
 * 单例模式
 **/
static LTxCoreConfig *_instance;
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LTxCoreConfig alloc] init];
        [_instance setupInitConfigValues];
    });
    
    return _instance;
}

/**
 * 系统初始化
 **/
- (void)appSetup{
    //NavigationBar 字体颜色
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    [[UINavigationBar appearance] setBarTintColor:_skinColor];
}

/*默认设置*/
-(void)setupInitConfigValues{
    /*颜色*/
    _skinColor = [UIColor colorWithRed:59/255.0 green:145/255.0 blue:233/255.0 alpha:1];
    _hintColor = [UIColor colorWithRed:240/255.0 green:173/255.0 blue:78/255.0 alpha:1];
    _activityViewBackgroundColor = [UIColor lightGrayColor];
    _viewBackgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    _cellContentViewColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
    _cellContentViewShadowColor = [UIColor lightGrayColor].CGColor;
    
    /*配置参数*/
    NSURL* configFileURL = [[NSBundle mainBundle] URLForResource:@"LTxCoreConfig" withExtension:@"plist"];
    if (configFileURL) {
        NSDictionary* configDic = [NSDictionary dictionaryWithContentsOfURL:configFileURL];
        NSString* type = [configDic objectForKey:@"type"];
        
        
        //版本信息
        _isDebug = [type isEqualToString:@"debug"];
        
        //签名验证
        _signatureToken = [configDic objectForKey:@"signature"];
        _signature = _signatureToken != nil;
        _appId = [configDic objectForKey:@"appId"];
        _pushId = [configDic objectForKey:@"pushId"];
        _pageSize = [[configDic objectForKey:@"pageSize"] integerValue];
        
        _instalTip = [configDic objectForKey:@"instalTip"];
        _aboutTip = [configDic objectForKey:@"aboutTip"];
        _loginTip = [configDic objectForKey:@"loginTip"];
        _cameraAlbumCustom = [[configDic objectForKey:@"cameraAlbumCustom"] boolValue];
        
        NSDictionary* downloadConfig = [configDic objectForKey:@"download"];
        _enableBackgroundDownload = [[downloadConfig objectForKey:@"backgroundDownload"] boolValue];
        _maxDownloadingCount = [[downloadConfig objectForKey:@"maxDownloadingCount"] integerValue];
        
        //HOST
        NSDictionary* typeDic = [configDic objectForKey:type];
        _instalUrl = [typeDic objectForKey:@"instalUrl"];
        _host = [typeDic objectForKey:@"host"];
        
        //缓存中读取 - 防止由于host获取失败导致无法继续更新的问题
    }else{//默认配置
        /*HOST*/
        _messageHost = @"http://125.46.29.147:8852/eepj_push";
        _eepmHost = @"http://125.46.29.147:8851/eepm";
        
        /*系统配置*/
        _appId = @"4f424ed4-b0f1-4af7-9567-aef6cd23d01a";
        _pageSize = 20;
        
        /*其他*/
        _instalUrl = @"http://192.168.1.75:8801/eepm";
        _instalTip = @"在苹果设备上安装的重要提示：\
        \n1.扫码后,确保“切换到苹果自带的Safari浏览器打开网页”，方能成功安装！\
        \n2.针对iOS9及以上版本的用户，打开本应用时你可能会收到“未受信任的企业级开发者”的提示。此时，你需按照以下步骤手工完成设置（苹果官方最新安全要求）：进入[设置]>[通用]>[描述文件]>[企业级应用]>[Sippr Enginnering Group Co., LTD.]，点击“信任...”或进入[设置]>[通用]>[设备管理]>[Sippr Enginnering Group Co., LTD.]，点击“信任...”。";
        _aboutTip = @"本应用包含极光推送，版权所有(c) 2012, 深圳市和讯华谷信息技术有限公司。";
        _cameraAlbumCustom = YES;
        
        _enableBackgroundDownload = NO;
        _maxDownloadingCount = 1;
    }
    
    
}
@end
