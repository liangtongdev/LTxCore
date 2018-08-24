//
//  LTxCoreErrorCode.h
//  LTxCore
//
//  Created by liangtong on 2018/8/24.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTxCoreErrorCode : NSObject


/**
 * @brief 错误代码分析
 *
 * @param     httpStatusCode     状态编码
 * @param     responseDic     业务数据
 *
 *  （一）HTTP网络相关
 *  2?:OK
 *  3?:OK
 *  404:访问资源已失效！->log
 *  4？:访问异常(4XX)，我们将尽快解决此问题！  ->log
 *  500:服务异常，请稍后再试！ ->log
 *  5？：服务异常(5XX)，我们将尽快解决此问题！ ->log
 *
 * （二）业务处理相关
 *
 */
+(NSString*)errorTipsWithHttpStatusCode:(NSInteger)httpStatusCode responseDic:(NSDictionary*)responseDic;
@end
