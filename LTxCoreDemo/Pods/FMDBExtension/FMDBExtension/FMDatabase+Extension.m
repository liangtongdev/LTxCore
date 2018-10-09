//
//  FMDatabase+Extension.m
//  FMDB
//
//  Created by liang tong on 2018/10/9.
//

#import "FMDatabase+Extension.h"

@implementation FMDatabase (Extension)

///#begin
/**
 * @brief  根据sql语句，查询记录集合。
 * @param  sql  sql语句
 */
///#end
-(NSMutableArray*)queryWithSQL:(NSString*)sql{
    NSMutableArray* retArray = [[NSMutableArray alloc] init];
    if([self open]){
        [self closeOpenResultSets];
        FMResultSet *rs = [self executeQuery:sql];
        NSDictionary* columnDic = [rs columnNameToIndexMap];
        while ([rs next]) {
            NSMutableDictionary* temp = [[NSMutableDictionary alloc] init];
            for (NSString*key in [columnDic allKeys]) {
                NSString* value = [rs stringForColumn:key];
                if (!value) {
                    value = @"";
                }
                [temp setObject:value forKey:key];
            }
            [retArray addObject:temp];
        }
        [rs close];
    }
    [self close];
    return retArray;
}
///#begin
/**
 * @brief  根据sql语句，查询记录数量。
 * @param  sql  sql语句
 */
///#end
-(NSInteger)countWithSQL:(NSString*)sql{
    NSInteger ret = -1;
    if([self open]){
        [self closeOpenResultSets];
        FMResultSet *rs = [self executeQuery:sql];
        while ([rs next]) {
            ret = [rs longForColumnIndex:0];
        }
        [rs close];
    }
    [self close];
    return ret;
}
@end
