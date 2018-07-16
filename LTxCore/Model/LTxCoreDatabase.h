//
//  LTxCoreDatabase.h
//  LTxCore
//
//  Created by liangtong on 2018/7/16.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

@interface FMDatabase (Helper)

@end

/**
 * 本地数据库
 **/
@interface LTxCoreDatabase : NSObject
///#begin
/**
 *    @brief    获取实例化对象
 *
 */
///#end
+(LTxCoreDatabase*)sharedInstance;

///#begin
/**
 *    @brief    初始化数据表
 *
 */
///#end
+(void)tablesInit;

///#begin
/**
 *    @brief    用户登出
 */
///#end
+(void)userLogout;

///#begin
/**
 *    @brief    清理数据表
 *
 */
///#end
+(void)clearTables;

#pragma mark - 断点下载
/**
 * 增加断点下载任务
 * 源地址，下载后移动的地址，保存的文件名称，是否需要解压
 **/
+(void)addDownloadTaskWithURL:(NSString*)url pathInSandbox:(NSString*)path name:(NSString*)name unzip:(NSNumber*)unZip;
/**
 * 完成断点下载任务
 **/
+(void)finishDownloadTaskWithURL:(NSString*)url;
/**
 * 断点下载任务
 **/
+(NSDictionary*)downloadTaskWithURL:(NSString*)url;
/**
 * 未完成的断点下载任务
 **/
+(NSMutableArray*)unFinishedDownloadTasks;
@end
