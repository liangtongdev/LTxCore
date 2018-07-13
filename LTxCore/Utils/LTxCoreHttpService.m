//
//  LTxCoreHttpService.m
//  LTxCore
//
//  Created by liangtong on 2018/7/13.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import "LTxCoreHttpService.h"
#import "AFNetworking.h"
#import "LTxCoreConfig.h"
#import "LTxCoreCategories.h"

@interface LTxSipprHTTPSessionManager :AFHTTPSessionManager
@end

@implementation LTxSipprHTTPSessionManager
//重写方法，像Request中添加签名验证信息
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    if (serializationError) {
        if (failure) {
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
        }
        
        return nil;
    }
    
    if ([LTxCoreConfig sharedInstance].signature) {
        /*添加签名信息*/
        NSString* token = [LTxCoreConfig sharedInstance].signatureToken;
        NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
        NSMutableString* stringBuffer = [[NSMutableString alloc] init];
        if ([parameters isKindOfClass:[NSDictionary class]]) {
            NSDictionary* parametersDic = (NSDictionary*)parameters;
            NSArray* sortedKeyArray = [parametersDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString* key1, NSString* key2)  {
                return [key1 compare:key2];
            }];
            for (NSString* key in sortedKeyArray) {
                id object = [parametersDic objectForKey:key];
                NSString* keyValueElement = [NSString stringWithFormat:@"&%@=%@",key,object];
                if (keyValueElement) {
                    [stringBuffer appendString:keyValueElement];
                }
            }
        }
        [stringBuffer insertString:[token substringToIndex:32] atIndex:0];
        [stringBuffer insertString:[NSString stringWithFormat:@"%.0f&",timestamp] atIndex:0];
        //对stringBuffer进行MD5加密，之后添加到Request中
        NSString* calcSgin = [stringBuffer jk_md5String];
//        NSLog(@"\n***********calcSign加密***********\n前：%@\n后：%@\n",stringBuffer,calcSgin);
        
        [request setValue:token forHTTPHeaderField:@"token"];
        [request setValue:[NSString stringWithFormat:@"%.0f",timestamp] forHTTPHeaderField:@"timestamp"];
        [request setValue:calcSgin forHTTPHeaderField:@"sign"];
        
//        NSLog(@"====================Request Header Log====================");
//        NSLog(@"Content-Type = %@",[request valueForHTTPHeaderField:@"Content-Type"]);
//        NSLog(@"accept-language = %@",[request valueForHTTPHeaderField:@"accept-language"]);
//        NSLog(@"user-agent = %@",[request valueForHTTPHeaderField:@"user-agent"]);
//        NSLog(@"token = %@",[request valueForHTTPHeaderField:@"token"]);
//        NSLog(@"timestamp = %@",[request valueForHTTPHeaderField:@"timestamp"]);
//        NSLog(@"sign = %@",[request valueForHTTPHeaderField:@"sign"]);
//        NSLog(@"==========================================================");
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request
                          uploadProgress:uploadProgress
                        downloadProgress:downloadProgress
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                           if (error) {
                               if (failure) {
                                   failure(dataTask, error);
                               }
                           } else {
                               if (success) {
                                   success(dataTask, responseObject);
                               }
                           }
                       }];
    
    return dataTask;
}
@end
@implementation LTxCoreHttpService
static LTxSipprHTTPSessionManager *_sharedManager;
+ (LTxSipprHTTPSessionManager*)sharedManager{
    static dispatch_once_t onceTokenLTxSipprHTTPSessionManager;
    dispatch_once(&onceTokenLTxSipprHTTPSessionManager, ^{
        _sharedManager = [LTxSipprHTTPSessionManager manager];
        _sharedManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
        _sharedManager.requestSerializer.timeoutInterval = 30.f;
    });
    
    return _sharedManager;
}

+ (NSURLSessionDataTask*)doGetWithURL:(NSString*)url
                                param:(NSDictionary*)param
                             complete:(LTxStringAndObjectCallbackBlock)complete{
    LTxSipprHTTPSessionManager *manager  =  [LTxCoreHttpService sharedManager];
    
    return [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask *task, id _Nullable responseObject) {
        [LTxCoreHttpService handleHttpResponseWithStatusCode:((NSHTTPURLResponse*)(task.response)).statusCode
                                               responseObject:responseObject
                                                     complete:complete];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        NSLog(@"\n网络访问异常：%s\n%@",__func__,error);
        [LTxCoreHttpService handleHttpResponseWithStatusCode:((NSHTTPURLResponse*)(task.response)).statusCode
                                               responseObject:nil
                                                     complete:complete];
    }];
}

+ (NSURLSessionDataTask*)doPostWithURL:(NSString*)url
                                 param:(NSDictionary*)param
                              complete:(LTxStringAndObjectCallbackBlock)complete{
    LTxSipprHTTPSessionManager *manager  =  [LTxCoreHttpService sharedManager];
    
    return [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask *task, id _Nullable responseObject) {
        [LTxCoreHttpService handleHttpResponseWithStatusCode:((NSHTTPURLResponse*)(task.response)).statusCode
                                               responseObject:responseObject
                                                     complete:complete];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        NSLog(@"\n网络访问异常：%s\n%@",__func__,error);
        [LTxCoreHttpService handleHttpResponseWithStatusCode:((NSHTTPURLResponse*)(task.response)).statusCode
                                               responseObject:nil
                                                     complete:complete];
    }];
}

+ (NSURLSessionDataTask*)doPutWithURL:(NSString*)url
                                param:(NSDictionary*)param
                             complete:(LTxStringAndObjectCallbackBlock)complete{
    LTxSipprHTTPSessionManager *manager  =  [LTxCoreHttpService sharedManager];
    
    return [manager PUT:url parameters:param success:^(NSURLSessionDataTask *task, id _Nullable responseObject) {
        [LTxCoreHttpService handleHttpResponseWithStatusCode:((NSHTTPURLResponse*)(task.response)).statusCode
                                               responseObject:responseObject
                                                     complete:complete];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        NSLog(@"\n网络访问异常：%s\n%@",__func__,error);
        [LTxCoreHttpService handleHttpResponseWithStatusCode:((NSHTTPURLResponse*)(task.response)).statusCode
                                               responseObject:nil
                                                     complete:complete];
    }];
}

+ (NSURLSessionDataTask*)doDeleteWithURL:(NSString*)url
                                   param:(NSDictionary*)param
                                complete:(LTxStringAndObjectCallbackBlock)complete{
    LTxSipprHTTPSessionManager *manager  =  [LTxCoreHttpService sharedManager];
    
    return [manager DELETE:url parameters:param success:^(NSURLSessionDataTask *task, id _Nullable responseObject) {
        [LTxCoreHttpService handleHttpResponseWithStatusCode:((NSHTTPURLResponse*)(task.response)).statusCode
                                               responseObject:responseObject
                                                     complete:complete];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        NSLog(@"\n网络访问异常：%s\n%@",__func__,error);
        [LTxCoreHttpService handleHttpResponseWithStatusCode:((NSHTTPURLResponse*)(task.response)).statusCode
                                               responseObject:nil
                                                     complete:complete];
    }];
}

+ (NSURLSessionDataTask*)doMultiPostWithURL:(NSString *)url
                                      param:(NSDictionary*)param
                              filePathArray:(NSArray*)filePathArray
                                   progress:( void (^)(NSProgress *progress))progress
                                   complete:(LTxStringAndObjectCallbackBlock)complete{
    
    LTxSipprHTTPSessionManager *manager = [LTxCoreHttpService sharedManager];
    
    return [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSURL* filePath in filePathArray) {
            NSString* fileName = filePath.path.lastPathComponent;
            [formData appendPartWithFileURL:filePath
                                       name:fileName
                                      error:nil];
        }
    } progress:^(NSProgress *uploadProgress){
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask *task, id _Nullable responseObject) {
        [LTxCoreHttpService handleHttpResponseWithStatusCode:((NSHTTPURLResponse*)(task.response)).statusCode
                                               responseObject:responseObject
                                                     complete:complete];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        NSLog(@"\n网络访问异常：%s\n%@",__func__,error);
        [LTxCoreHttpService handleHttpResponseWithStatusCode:((NSHTTPURLResponse*)(task.response)).statusCode
                                               responseObject:nil
                                                     complete:complete];
    }];
}

#pragma mark - 数据检查/处理
+(void)handleHttpResponseWithStatusCode:(NSInteger)statusCode
                         responseObject:(id)responseObject
                               complete:(LTxStringAndObjectCallbackBlock)complete{
    NSString* errorTips = [LTxCoreHttpService errorTipsWithHttpStatusCode:statusCode responseDic:responseObject];
    NSDictionary* data;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        data = [responseObject objectForKey:@"data"];
    }
    if (complete) {
        complete(errorTips, data);
    }
}

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
                retString = [NSString stringWithFormat:@"访问好像不太正常(%td)，我也不知道为什么会出现这个状态码😄！",httpStatusCode];
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
        }else{
            retString = @"服务异常，请稍后再试！";
        }
    }
    return retString;
}
@end
