//
//  LTxCoreErrorCode.m
//  LTxCore
//
//  Created by liangtong on 2018/8/24.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import "LTxCoreErrorCode.h"

@implementation LTxCoreErrorCode

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
+(NSString*)errorTipsWithHttpStatusCode:(NSInteger)httpStatusCode responseDic:(NSDictionary*)responseDic{
    
    NSString* retString = nil;
    if (httpStatusCode == 0) {
        retString = @"网络请求失败！";
    }else if (httpStatusCode > 200) {
        if (httpStatusCode >= 200 && httpStatusCode < 400) {
            retString = [NSString stringWithFormat:@"访问异常(%td)！",httpStatusCode];
        }else if (httpStatusCode < 1000 ){
            if (httpStatusCode < 500){
                if (httpStatusCode == 404) {
                    retString = @"访问资源已失效(404)！";
                }else{
                    retString = [NSString stringWithFormat:@"访问异常(%td)！",httpStatusCode];
                }
            }else if (httpStatusCode == 500){
                retString = @"服务异常，请稍后再试(500)！";
            }else if (httpStatusCode < 600){
                retString = [NSString stringWithFormat:@"服务异常(%td)！",httpStatusCode];
            }else{// statusCode >= 600,hook
                retString = [NSString stringWithFormat:@"访问好像不太正常(%td)，我也不知道为什么会出现这个状态码�！",httpStatusCode];
            }
        }else{
            retString = @"数据访问出了点儿问题！";
        }
    }else{//网络请求正常的情况下，检查数据是否正常
        NSInteger code = [[responseDic objectForKey:@"code"] integerValue];
        if (code == 0) {//正常，不做处理
            
        }else if (code == 1){
            retString = [responseDic objectForKey:@"message"];
        }else {
            retString = [LTxCoreErrorCode serviceStatusWithCode:code];
        }
    }
    return retString;
}


#pragma mark - Private

/***
 * 解析错误码
 * 解析业务错误码
 ***/
static NSArray* static_service_code_array;
+(NSString*)serviceStatusWithCode:(NSInteger)code{
    NSString* sRet = nil;
    
    static dispatch_once_t onceTokenStaticServiceCodeArray;
    dispatch_once(&onceTokenStaticServiceCodeArray, ^{
        NSURL* serviceErrorCodeUrl = [[NSBundle mainBundle] URLForResource:@"LTxCoreError" withExtension:@"plist"];
        if (serviceErrorCodeUrl) {
            static_service_code_array = [NSArray arrayWithContentsOfURL:serviceErrorCodeUrl];
        }
        
    });
    if (static_service_code_array) {
        for (NSDictionary* item in static_service_code_array) {
            NSInteger itemCode = [[item objectForKey:@"code"] integerValue];
            if (code == itemCode) {
                sRet = [item objectForKey:@"value"];
                break;
            }
        }
        if (!sRet) {
            sRet = @"服务异常，请稍后再试！";
        }
    }else{
        switch (code) {
                case 100:
                sRet = @"应用编号无效(Error:100)！";
                break;
                case 101:
                sRet = @"请求参数无效(Error:101)！";
                break;
                case 102:
                sRet = @"此服务已被弃用(Error:102)！";
                break;
                case 103:
                sRet = @"未找到此服务(Error:103)！";
                break;
                case 104:
                sRet = @"服务调用次数已达上限(Error:104)！";
                break;
                case 105:
                sRet = @"无权限访问服务！";
                break;
                case 20100:
                sRet = @"用户名不存在！";
                break;
                case 20101:
                sRet = @"用户名或密码错误！";
                break;
                case 20102:
                sRet = @"用户信息不完整！";
                break;
                case 20200:
                sRet = @"手机号已锁定！";
                break;
                case 20201:
                sRet = @"手机号未被授权！";
                break;
                case 20202:
                sRet = @"手机号格式错误！";
                break;
                case 20203:
                sRet = @"短信验证码发送失败！";
                break;
                case 20204:
                sRet = @"短信验证码发送次数已达今日上限！";
                break;
                case 20205:
                sRet = @"验证码已过期！";
                break;
                case 20206:
                sRet = @"验证码验证失败！";
                case 20207:
                sRet = @"验证码验证次数已达上限，请重新发送！";
                case 20208:
                sRet = @"云平台短信服务业务限流！";
                case 20209:
                sRet = @"云平台短信服务调用异常！";
                case 20210:
                sRet = @"短信暂未开通/暂停服务！";
                break;
                
            default:
                sRet = @"服务异常，请稍后再试！";
                break;
        }
        
    }
    return sRet;
}


@end
