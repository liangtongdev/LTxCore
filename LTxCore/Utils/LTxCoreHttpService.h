//
//  LTxCoreHttpService.h
//  LTxCore
//
//  Created by liangtong on 2018/7/13.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTxCoreMacroDef.h"
#import "LTxCoreErrorCode.h"
/**
 * http网络访问服务接口
 **/
@interface LTxCoreHttpService : NSObject

+ (NSURLSessionDataTask*)doGetWithURL:(NSString*)url param:(NSDictionary*)param complete:(LTxStringAndObjectCallbackBlock)complete;

+ (NSURLSessionDataTask*)doPostWithURL:(NSString*)url param:(NSDictionary*)param complete:(LTxStringAndObjectCallbackBlock)complete;

+ (NSURLSessionDataTask*)doPutWithURL:(NSString*)url param:(NSDictionary*)param complete:(LTxStringAndObjectCallbackBlock)complete;

+ (NSURLSessionDataTask*)doDeleteWithURL:(NSString*)url param:(NSDictionary*)param complete:(LTxStringAndObjectCallbackBlock)complete;

+ (NSURLSessionDataTask*)doMultiPostWithURL:(NSString *)url param:(NSDictionary*)param filePathArray:(NSArray*)filePathArray progress:( void (^)(NSProgress *progress))progress complete:(LTxStringAndObjectCallbackBlock)complete;
@end
