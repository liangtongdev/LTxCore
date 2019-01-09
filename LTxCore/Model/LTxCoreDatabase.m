//
//  LTxCoreDatabase.m
//  LTxCore
//
//  Created by liangtong on 2018/7/16.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import "LTxCoreDatabase.h"
#import <FMDBExtension/FMDatabase+Extension.h>

@interface LTxCoreDatabase()
@property (strong, nonatomic) NSString* dbPath;
@end

@implementation LTxCoreDatabase

/**
 * 创建数据库连接
 **/
+(FMDatabase*)dbmsConnection{
    return [FMDatabase databaseWithPath:[LTxCoreDatabase sharedInstance].dbPath] ;
}
+(FMDatabaseQueue*)dbQueue{
    return [FMDatabaseQueue databaseQueueWithPath:[LTxCoreDatabase sharedInstance].dbPath];
}

///#begin
/**
 *    @brief    获取实例化对象
 *
 */
///#end
static LTxCoreDatabase *_instance;
+ (instancetype)sharedInstance{
    static dispatch_once_t onceTokenBIMDatabase;
    dispatch_once(&onceTokenBIMDatabase, ^{
        _instance = [[LTxCoreDatabase alloc] init];
        _instance.dbPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"ltxcore.db"];
    });
    
    return _instance;
}

///#begin
/**
 *    @brief    初始化数据表
 *
 */
///#end
+(void)tablesInit{
    FMDatabase* _dbms = [LTxCoreDatabase dbmsConnection];
    if([_dbms open]){
        /**
         * 断点下载
         **/
        NSString* downloadSql = @"create table if not exists download_cache_v1(url text, path text, name text, unzip INTEGER default 0, finish INTEGER default 0 )";
        if([_dbms executeUpdate:downloadSql]){
            NSLog(@"断点下载表初始化成功！");
        }else{
            NSLog(@"断点下载表初始化失败！");
        }
    }
    [_dbms close];
    
}

///#begin
/**
 *    @brief    用户登出
 */
///#end
+(void)userLogout{
    //删除用户项目数据
    //标段
    [LTxCoreDatabase clearTables];
}

///#begin
/**
 *    @brief    清理数据表
 *
 */
///#end
+(void)clearTables{
    FMDatabase* dbConnection = [LTxCoreDatabase dbmsConnection];
    if([dbConnection open]){
        [dbConnection close];
    }
}


#pragma mark - 断点下载
/**
 * 增加断点下载任务
 * 源地址，下载后移动的地址，是否需要解压
 **/
+(void)addDownloadTaskWithURL:(NSString*)url pathInSandbox:(NSString*)path name:(NSString*)name unzip:(NSNumber*)unZip{
    FMDatabase* dbConnection = [LTxCoreDatabase dbmsConnection];
    if([dbConnection open]){
        [dbConnection executeUpdate:@"insert into download_cache_v1 (url, path, name, unzip) values (?, ?, ?, ?)",url, path, name, unZip];
        [dbConnection close];
    }
}
/**
 * 完成断点下载任务
 **/
+(void)finishDownloadTaskWithURL:(NSString*)url{
    FMDatabase* dbConnection = [LTxCoreDatabase dbmsConnection];
    if([dbConnection open]){
        [dbConnection executeUpdate:@"update download_cache_v1 set finish = 1 where url = ? ",url];
        [dbConnection close];
    }
}
/**
 * 断点下载任务
 **/
+(NSDictionary*)downloadTaskWithURL:(NSString*)url{
    FMDatabase* dbConnection = [LTxCoreDatabase dbmsConnection];
    NSDictionary* retItem;
    if([dbConnection open]){
        NSString* sql = [NSString stringWithFormat:@"select * from download_cache_v1 where url = '%@' ",url];
        NSMutableArray* downloadArray = [dbConnection queryWithSQL:sql];
        if ([downloadArray count] > 0) {
            retItem = [downloadArray firstObject];
        }
        [dbConnection close];
    }
    return retItem;
}
/**
 * 未完成的断点下载任务
 **/
+(NSMutableArray*)unFinishedDownloadTasks{
    FMDatabase* dbConnection = [LTxCoreDatabase dbmsConnection];
    NSMutableArray* retArray;
    if([dbConnection open]){
        retArray = [dbConnection queryWithSQL:@"select * from download_cache_v1 where finish = 0 "];
        [dbConnection close];
    }
    return retArray;
}

#pragma mark - 私有方法

+(void)dropTables:(NSArray*)tableNameArray{
    if (tableNameArray.count > 0) {
        for (NSString* tableName in tableNameArray) {
            if ([LTxCoreDatabase isTableExists:tableName]) {
                FMDatabase* _dbms = [LTxCoreDatabase dbmsConnection];
                if([_dbms open]){
                    NSString* sql = [NSString stringWithFormat:@"DROP TABLE %@ ",tableName];
                    [_dbms executeUpdate:sql];
                }
                [_dbms close];
                
            }
        }
    }
}
+(BOOL)isTableExists:(NSString *)tableName{
    BOOL ret = false;
    FMDatabase* _dbms = [LTxCoreDatabase dbmsConnection];
    if([_dbms open]){
        FMResultSet *rs = [_dbms executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
        while ([rs next]){
            // just print out what we've got in a number of formats.
            NSInteger count = [rs intForColumn:@"count"];
            if (0 == count){
                ret = NO;
            }else{
                ret = YES;
            }
        }
    }
    [_dbms close];
    return ret;
}
@end
