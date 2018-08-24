//
//  LTxCoreDownloadTaskService.m
//  LTxCore
//
//  Created by liangtong on 2018/7/16.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import "LTxCoreDownloadTaskService.h"
#import "LTxCoreConfig.h"
#import "LTxCoreDatabase.h"
#import "LTxCoreFileManager.h"
#import <SSZipArchive/SSZipArchive.h>

@interface LTxCoreDownloadTaskService()<NSURLSessionDelegate>
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSMutableArray* taskArray;//下载数组
@property (nonatomic, strong) NSURLSession* session;//下载用

@property (nonatomic, strong) dispatch_semaphore_t semaphore;//信号量，用于限制最大上传个数
@property (nonatomic, strong) dispatch_queue_t queue;//信号队列
@end
@implementation LTxCoreDownloadTaskService

/**
 * 单例模式
 **/
static LTxCoreDownloadTaskService *_instance;
+ (instancetype)sharedInstance{
    static dispatch_once_t onceTokenBIMDownloadTaskService;
    dispatch_once(&onceTokenBIMDownloadTaskService, ^{
        _instance = [[LTxCoreDownloadTaskService alloc] init];
        [_instance setupDownloadTaskService];
    });
    
    return _instance;
}

/**
 * 初始化设置服务
 **/
-(void)setupDownloadTaskService{
    _taskArray = [[NSMutableArray alloc] init];
    NSInteger maxCount = [LTxCoreConfig sharedInstance].maxDownloadingCount;
    _semaphore = dispatch_semaphore_create(maxCount);
    _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"ltx_core_download_task_service_identifier"];
    _operationQueue = [[NSOperationQueue alloc] init];
    _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:_operationQueue];
    
    [_session getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
        for (NSURLSessionDownloadTask* task in downloadTasks) {//断点续下载
            NSString* taskDescription = task.taskDescription;
            NSLog(@"taskDescription - : %@ %td",taskDescription,task.state);
            
            //断点续传需要对task的resumeData进行操作，暂时重新下载即可
            NSString* url = task.taskDescription;
            if (url) {
                NSURL* fileURL = [NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                NSURLSessionDownloadTask* downloadTask = [self.session downloadTaskWithURL:fileURL];
                downloadTask.taskDescription = url;
                [self startDownloadServiceWithTask:downloadTask];
            }
            [task cancel];
        }
    }];
}


//使用taskDescription来区分不同的url
-(void)addDownloadTaskWithURL:(NSString*)url pathInSandbox:(NSString*)path saveName:(NSString*)saveName unzip:(NSNumber*)unZip{
    //开始下载
    NSURL* fileURL = [NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    if (!fileURL) {
        return;
    }
    NSURLSessionDownloadTask* downloadTask = [self.session downloadTaskWithURL:fileURL];
    downloadTask.taskDescription = url;
    [LTxCoreDatabase addDownloadTaskWithURL:url pathInSandbox:path name:saveName unzip:unZip];//缓存起来
    [self startDownloadServiceWithTask:downloadTask];
}
-(LTxCoreTaskState)statusWithURL:(NSString*)url{
    LTxCoreTaskState retState = LTxCoreTaskStateNone;
    NSURLSessionDownloadTask* downloadTask;
    for (NSURLSessionDownloadTask* task in _taskArray) {
        if ([task.taskDescription isEqualToString:url]) {
            downloadTask = task;
            break;
        }
    }
    //根据task的状态判断
    if (downloadTask) {
        if (downloadTask.state == NSURLSessionTaskStateRunning) {
            retState = LTxCoreTaskStateDownloading;
        }else if (downloadTask.state == NSURLSessionTaskStateSuspended) {
            if (downloadTask.countOfBytesReceived > 0) {
                retState = LTxCoreTaskStatePause;
            }else{
                retState = LTxCoreTaskStateWaiting;
            }
        }else if (downloadTask.state == NSURLSessionTaskStateCanceling) {
            retState = LTxCoreTaskStateFailed;
        }else if (downloadTask.state == NSURLSessionTaskStateCompleted)  {
            retState = LTxCoreTaskStateCompleted;
        }
    }
    return retState;
}

-(CGFloat)progressWithURL:(NSString*)url{
    CGFloat progress = 0.f;
    NSURLSessionDownloadTask* downloadTask;
    for (NSURLSessionDownloadTask* task in _taskArray) {
        if ([task.taskDescription isEqualToString:url]) {
            downloadTask = task;
            break;
        }
    }
    //根据task的状态判断
    if (downloadTask.state == NSURLSessionTaskStateRunning || downloadTask.state == NSURLSessionTaskStateSuspended) {
        progress = downloadTask.countOfBytesReceived / downloadTask.countOfBytesExpectedToReceive;
    }
    return progress;
}
-(void)pauseTaskWithURL:(NSString*)url{
    NSURLSessionDownloadTask* downloadTask;
    for (NSURLSessionDownloadTask* task in _taskArray) {
        if ([task.taskDescription isEqualToString:url]) {
            downloadTask = task;
            break;
        }
    }
    [self pauseDownloadServiceWithTask:downloadTask];
    
}
-(void)resumeTaskWithURL:(NSString*)url{
    NSURLSessionDownloadTask* downloadTask;
    for (NSURLSessionDownloadTask* task in _taskArray) {
        if ([task.taskDescription isEqualToString:url]) {
            downloadTask = task;
            break;
        }
    }
    [self startDownloadServiceWithTask:downloadTask];
}


/**
 * 开始下载任务
 **/
-(void)startDownloadServiceWithTask:(NSURLSessionDownloadTask*)downloadTask{
    
    if (!downloadTask) {
        return;
    }
    [self.taskArray addObject:downloadTask];
    dispatch_async(_queue, ^{
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        [downloadTask resume];
        NSLog(@"-----> 开始下载");
    });
}

/**
 * 暂停下载任务
 **/
-(void)pauseDownloadServiceWithTask:(NSURLSessionDownloadTask*)downloadTask{
    if (!downloadTask) {
        return;
    }
    [downloadTask suspend];
    dispatch_async(_queue, ^{
        dispatch_semaphore_signal(self.semaphore);
    });
}

#pragma mark - 工具
//文件处于下载队列中
-(BOOL)fileExistInTaskArray:(NSString*)fileURL{
    BOOL existInTaskArray = NO;
    if (fileURL) {
        for (NSURLSessionDownloadTask* task in _taskArray) {
            if ([task.taskDescription isEqualToString:fileURL]) {
                existInTaskArray = YES;
                break;
            }
        }
    }
    return existInTaskArray;
}
//文件已经被下载
-(BOOL)fileHasBeenDownloaded:(NSString*)fileURL{
    BOOL finished = NO;
    if (fileURL) {
        for (NSURLSessionDownloadTask* task in _taskArray) {
            if ([task.taskDescription isEqualToString:fileURL]) {
                return task.state == NSURLSessionTaskStateCompleted;
            }
        }
    }
    return finished;
}

-(void)postTaskUpdateNotificationWithKey:(NSString*)key object:(NSDictionary*)obj{//发生通知
    NSNotification *notification = [NSNotification notificationWithName:key object:obj];
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    dispatch_async(dispatch_get_main_queue(), ^{
        [notificationCenter performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES];
    });
}


#pragma mark - NSURLSessionDelegate
/*
 1.当接收到下载数据的时候调用,可以在该方法中监听文件下载的进度
 该方法会被调用多次
 totalBytesWritten:已经写入到文件中的数据大小
 totalBytesExpectedToWrite:目前文件的总大小
 bytesWritten:本次下载的文件数据大小
 */
-(void)URLSession:(nonnull NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    CGFloat progress = 1.0 * totalBytesWritten/totalBytesExpectedToWrite;
    NSLog(@"--> %.2f",progress);
    NSDictionary* obj = @{@"url":downloadTask.taskDescription,@"value":[NSNumber numberWithFloat:progress],@"size":[NSNumber numberWithLongLong:totalBytesExpectedToWrite]};
    [self postTaskUpdateNotificationWithKey:LTX_CORE_DOWNLOAD_TASK_PROGRESS_UPDATE_KEY object:obj];
}
/*
 2.恢复下载的时候调用该方法
 fileOffset:恢复之后，要从文件的什么地方开发下载
 expectedTotalBytes：该文件数据的总大小
 */
-(void)URLSession:(nonnull NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
    
}
/*
 3.下载完成之后调用该方法
 */
-(void)URLSession:(nonnull NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location{
    NSLog(@"文件下载成功：%@",location.path);
    //下载成功后移动文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError* error;
    
    NSString* cacheFilePath = [LTxCoreFileManager cacheFilePathWithName:location.path.lastPathComponent];
    
    [fileManager moveItemAtPath:location.path toPath:cacheFilePath error:&error];
    if (!error) {
        NSLog(@"文件移动成功:%@",cacheFilePath);
    }else{
        NSLog(@"文件移动失败：%@",error.description);
    }
    
    //从数据库中读取文件，判断是否需要移动或者解压
    NSDictionary* taskItem = [LTxCoreDatabase downloadTaskWithURL:downloadTask.taskDescription];
    if (taskItem) {
        NSString* destComponentInDoc = [taskItem objectForKey:@"path"];
        NSString* destFolderPath = [NSHomeDirectory() stringByAppendingPathComponent:destComponentInDoc];
        NSInteger unZip = [[taskItem objectForKey:@"unzip"] integerValue];
        if (unZip == 1) {//需要解压
            BOOL unZip = [SSZipArchive unzipFileAtPath:cacheFilePath toDestination:destFolderPath];
            if (unZip) {
                [fileManager removeItemAtPath:cacheFilePath error:&error];
            }
        }else{//直接移动
            NSString* saveName = [taskItem objectForKey:@"name"];
            NSString* fileAbsolutePath = [destFolderPath stringByAppendingPathComponent:saveName];
            NSError* error;
            [fileManager moveItemAtPath:cacheFilePath toPath:fileAbsolutePath error:&error];
            if (!error) {
                NSLog(@"文件移动成功:%@",fileAbsolutePath);
            }else{
                NSLog(@"文件移动失败：%@",error.description);
            }
        }
        [LTxCoreDatabase finishDownloadTaskWithURL:downloadTask.taskDescription];
    }
    
    NSDictionary* obj = @{@"url":downloadTask.taskDescription};
    [self postTaskUpdateNotificationWithKey:LTX_CORE_DOWNLOAD_TASK_STATE_UPDATE_KEY object:obj];
    
}
/*
 4.请求完成之后调用
 如果请求失败，那么error有值
 */
-(void)URLSession:(nonnull NSURLSession *)session task:(nonnull NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error{
    if (task && [_taskArray containsObject:task]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_semaphore_signal(self.semaphore);
            NSLog(@"-----> 完成下载");
        });
    }
}
@end
