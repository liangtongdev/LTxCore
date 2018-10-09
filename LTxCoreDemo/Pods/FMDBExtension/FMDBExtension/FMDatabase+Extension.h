//
//  FMDatabase+Extension.h
//  FMDB
//
//  Created by liang tong on 2018/10/9.
//

#import <FMDB/FMDB.h>

@interface FMDatabase (Extension)
///#begin
/**
 * @brief  根据sql语句，查询记录集合。
 * @param  sql  sql语句
 */
///#end
-(NSMutableArray*)queryWithSQL:(NSString*)sql;

///#begin
/**
 * @brief  根据sql语句，查询记录数量。
 * @param  sql  sql语句
 */
///#end
-(NSInteger)countWithSQL:(NSString*)sql;
@end
