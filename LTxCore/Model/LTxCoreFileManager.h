//
//  LTxCoreFileManager.h
//  LTxCore
//
//  Created by liangtong on 2018/7/16.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 沙盒文件管理Model
 * （1）预览下载的文件存放在沙盒的Library/Caches目录下，文件命名：文件名+URL的hash编码+后缀
 *
 **/


//预览文件所处目录
#define LTX_CORE_FILE_PREVIEW_CACHE_RELATIVE_PATH @"Library/Caches/LTxCoreFilePreview"
#define LTX_CORE_FILE_PREVIEW_CACHE_PATH ([NSHomeDirectory() stringByAppendingPathComponent:LTX_CORE_FILE_PREVIEW_CACHE_RELATIVE_PATH])

@interface LTxCoreFileManager : NSObject

+(void)fileManagerInit;

#pragma mark - 文件预览缓存
+(NSString*)cacheFilePathWithName:(NSString*)fileName;
+(void)clearCacheFolder;



#pragma mark - 工具类

+(BOOL)fileExistsAtPath:(NSString*)filePath;
+(BOOL)removeItemAtPath:(NSString*)filePath;
//单个文件的大小
+(long long) fileSizeAtPath:(NSString*)filePath;
//遍历文件夹获得文件夹大小，返回多少M
+(float)folderSizeAtPath:(NSString*)folderPath;
@end
