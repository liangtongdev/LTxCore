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
        }else if (code == 100){
            retString = @"应用编号无效(Error:100)！";
        }else if (code == 101){
            retString = @"请求参数无效(Error:101)！";
        }else if (code == 102){
            retString = @"此服务已被弃用(Error:102)！";
        }else if (code == 103){
            retString = @"未找到此服务(Error:103)！";
        }else if (code == 104){
            retString = @"服务调用次数已达上限(Error:104)！";
        }else if (code == 105){
            retString = @"无权限访问服务！";
        }else if (code == 20100){
            retString = @"用户名不存在！";
        }else if (code == 20101){
            retString = @"用户名或密码错误！";
        }else if (code == 20102){
            retString = @"用户信息不完整！";
        }else if (code == 20200){
            retString = @"手机号已锁定！";
        }else if (code == 20201){
            retString = @"手机号未被授权！";
        }else if (code == 20202){
            retString = @"手机号格式错误！";
        }else if (code == 20203){
            retString = @"短信验证码发送失败！";
        }else if (code == 20204){
            retString = @"短信验证码发送次数已达今日上限！";
        }else if (code == 20205){
            retString = @"验证码已过期！";
        }else if (code == 20206){
            retString = @"验证码验证失败！";
        }else if (code == 20207){
            retString = @"验证码验证次数已达上限，请重新发送！";
        }else if (code == 20208){
            retString = @"云平台短信服务业务限流！";
        }else if (code == 20209){
            retString = @"云平台短信服务调用异常！";
        }else if (code == 20210){
            retString = @"短信暂未开通/暂停服务！";
        }else{
            retString = @"服务异常，请稍后再试！";
        }
    }
    return retString;
}
@end
