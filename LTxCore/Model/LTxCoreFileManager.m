//
//  LTxCoreFileManager.m
//  LTxCore
//
//  Created by liangtong on 2018/7/16.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import "LTxCoreFileManager.h"

@implementation LTxCoreFileManager
+(void)fileManagerInit{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:LTX_CORE_FILE_PREVIEW_CACHE_PATH];
    if (!fileExists) {
        [fileManager createDirectoryAtPath:LTX_CORE_FILE_PREVIEW_CACHE_PATH withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+(NSString*)cacheFilePathWithName:(NSString*)fileName{
    NSString* filePath = [LTX_CORE_FILE_PREVIEW_CACHE_PATH stringByAppendingPathComponent:fileName];
    return filePath;
}

+(void)clearCacheFolder{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray* folderList = [fileManager contentsOfDirectoryAtPath:LTX_CORE_FILE_PREVIEW_CACHE_PATH error:nil];
    for (NSString* folderName  in folderList) {
        NSString* folderPath = [LTX_CORE_FILE_PREVIEW_CACHE_PATH stringByAppendingPathComponent:folderName];
        BOOL fileExists = [fileManager fileExistsAtPath:folderPath];
        if (fileExists) {
            [fileManager removeItemAtPath:folderPath error:nil];
        }
    }
}

#pragma mark - 工具类

+(BOOL)fileExistsAtPath:(NSString*)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:filePath];
    return fileExists;
}

+(BOOL)removeItemAtPath:(NSString*)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:filePath];
    NSError* error;
    if (fileExists) {
        [fileManager removeItemAtPath:filePath error:&error];
    }
    return error == nil;
}
//单个文件的大小
+(long long) fileSizeAtPath:(NSString*)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
+(float)folderSizeAtPath:(NSString*)folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

@end
