//
//  NSUserDefaults+LTxCore.m
//  LTxCore
//
//  Created by liangtong on 2018/7/13.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import "NSUserDefaults+LTxCore.h"

@implementation NSUserDefaults (LTxCore)
///#begin
/**
 *    @brief    删除特定key对应的值。
 *    @param     key         key值
 */
///#end
+ (void)lt_removeObjectForKey:(NSString *)key{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults removeObjectForKey:key];
    [accountDefaults synchronize];
}


///#begin
/**
 *    @brief    清空UserDefaults
 */
///#end
+(void)lt_removeDefaultAppObjects{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* keys = @[
                      /*用户基本信息*/
                      USERDEFAULT_USER_LOGIN_NAME,
                      USERDEFAULT_USER_LOGIN_PASSWORD,
                      USERDEFAULT_USER_ID,
                      USERDEFAULT_USER_NUMBER,
                      USERDEFAULT_USER_NAME,
                      USERDEFAULT_USER_NICKNAME,
                      USERDEFAULT_USER_AVATAR_IMAGE,
                      USERDEFAULT_USER_SEX,
                      USERDEFAULT_USER_DEPARTMENT,
                      USERDEFAULT_USER_PHONE_NUMBER,
                      /*HOST*/
                      USERDEFAULT_APP_UPDATE_HOST,
                      USERDEFAULT_APP_MSG_HOST,
                      USERDEFAULT_APP_SERVICE_HOST,
                      USERDEFAULT_APP_SHARE_HOST
                      ];
    for (NSString* key in keys) {
        [accountDefaults removeObjectForKey:key];
    }
    
    [accountDefaults synchronize];
}

///#begin
/**
 *    @brief    获取UserDefaults中的特定key对应的值。
 *    @param     defaultName         key值
 */
///#end
+ (id)lt_objectForKey:(NSString *)defaultName{
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}
///#begin
/**
 *    @brief    向UserDefaults中设置对应的Key－Value键值对。
 *    @param     value               value值
 *    @param     defaultName         key值
 */
///#end
+ (void)lt_setObject:(id)value forKey:(NSString *)defaultName{
    if (!value || [value isEqual:[NSNull null]] || !defaultName || [defaultName isEqual:[NSNull null]]) {
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:defaultName];
    [userDefaults synchronize];
}
@end
