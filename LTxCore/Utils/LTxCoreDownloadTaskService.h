//
//  LTxCoreDownloadTaskService.h
//  LTxCore
//
//  Created by liangtong on 2018/7/16.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, LTxCoreTaskState) {
    LTxCoreTaskStateNone,         // 不在队列中
    LTxCoreTaskStateWaiting,      // 等待下载
    LTxCoreTaskStateDownloading,  // 下载中
    LTxCoreTaskStatePause,        // 已经暂停
    LTxCoreTaskStateCompleted,    //已完成
    LTxCoreTaskStateFailed,       //下载失败
};

typedef NS_ENUM(NSUInteger, LTxCoreTaskAddQueryState) {
    LTxCoreTaskAddQueryStateNone,       // 不在队列中
    LTxCoreTaskAddQueryStateExists,     // 存在于下载队列中
};

typedef BOOL (^LTxCoreTaskAddQueryCallbackBlock)(LTxCoreTaskAddQueryState);

#define LTX_CORE_DOWNLOAD_TASK_STATE_UPDATE_KEY @"LTX_CORE_DOWNLOAD_TASK_STATE_UPDATE_KEY"//文件下载变更通知
#define LTX_CORE_DOWNLOAD_TASK_PROGRESS_UPDATE_KEY @"LTX_CORE_DOWNLOAD_TASK_PROGRESS_UPDATE_KEY"//文件进度变更通知




/**
 * 文件下载服务
 **/
@interface LTxCoreDownloadTaskService : NSObject

//单例
+ (instancetype)sharedInstance;
/**
 * 初始化设置服务
 **/
-(void)setupDownloadTaskService;

-(void)addDownloadTaskWithURL:(NSString*)url pathInSandbox:(NSString*)path saveName:(NSString*)saveName unzip:(NSNumber*)unZip;
-(LTxCoreTaskState)statusWithURL:(NSString*)url;
-(CGFloat)progressWithURL:(NSString*)url;
-(void)pauseTaskWithURL:(NSString*)url;
-(void)resumeTaskWithURL:(NSString*)url;
@end
