//
//  LTxCoreCategories.h
//  LTxCore
//
//  Created by liangtong on 2018/7/13.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#define LT_DATE_MINUTE    60
#define LT_DATE_HOUR    3600
#define LT_DATE_DAY    86400
#define LT_DATE_MONTH    2592000
#define LT_DATE_YEAR    31556926

/**
 * 常用的扩展
 **/

#pragma mark - 日期
@interface NSDate (LTxSipprExtension)

/**
 * @brief：日期描述
 * @return：x分钟前/x小时前/昨天/x天前/x个月前/x年前
 */
- (NSString *)lt_timeDescription;

+ (NSString *)lt_timeDescriptionWithDateString:(NSString*)dateString;

- (NSString *)stringWithFormate:(NSString*)formate;

/**
 * 根据日期返回字符串
 */
+ (NSString *)jk_stringWithDate:(NSDate *)date format:(NSString *)format;
- (NSString *)jk_stringWithFormat:(NSString *)format;
+ (NSDate *)jk_dateWithString:(NSString *)string format:(NSString *)format;
/**
 *  日期是否相等
 */
- (BOOL)jk_isSameDay:(NSDate *)anotherDate;
@end


#pragma mark - 字符串
@interface NSString (LTxSipprExtension)

/**
 *  @brief  去除空格
 *  @return 去除空格后的字符串
 */
- (NSString *)lt_trimmingWhitespace;

//正则表达式
- (BOOL)lt_isValidateByRegex:(NSString *)regex;

/**
 *  手机号码的有效性:分电信、联通、移动和小灵通
 */
- (BOOL)lt_isMobileNumberClassification;
/**
 *  手机号有效性
 */
- (BOOL)lt_isMobileNumber;

/**
 *  邮箱的有效性
 */
- (BOOL)lt_isEmailAddress;

/**
 *  简单的身份证有效性
 *
 */
- (BOOL)lt_simpleVerifyIdentityCardNum;

/**
 *  精确的身份证号码有效性检测
 *
 *  @param value 身份证号
 */
+ (BOOL)lt_accurateVerifyIDCardNumber:(NSString *)value;

/**
 *  车牌号的有效性
 */
- (BOOL)lt_isCarNumber;

/**
 *  银行卡的有效性
 */
- (BOOL)lt_bankCardluhmCheck;

/**
 *  IP地址有效性
 */
- (BOOL)lt_isIPAddress;

/**
 *  Mac地址有效性
 */
- (BOOL)lt_isMacAddress;

/**
 *  网址有效性
 */
- (BOOL)lt_isValidUrl;

/**
 *  纯汉字
 */
- (BOOL)lt_isValidChinese;

/**
 *  邮政编码
 */
- (BOOL)lt_isValidPostalcode;

/**
 *  工商税号
 */
- (BOOL)lt_isValidTaxNo;
/**
 @brief     是否符合最小长度、最长长度，是否包含中文,首字母是否可以为数字
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     firstCannotBeDigtal 首字母不能为数字
 @return    正则验证成功返回YES, 否则返回NO
 */
- (BOOL)lt_isValidWithMinLenth:(NSInteger)minLenth
                      maxLenth:(NSInteger)maxLenth
                containChinese:(BOOL)containChinese
           firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

/**
 @brief     是否符合最小长度、最长长度，是否包含中文,数字，字母，其他字符，首字母是否可以为数字
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     containDigtal   包含数字
 @param     containLetter   包含字母
 @param     containOtherCharacter   其他字符
 @param     firstCannotBeDigtal 首字母不能为数字
 @return    正则验证成功返回YES, 否则返回NO
 */
- (BOOL)lt_isValidWithMinLenth:(NSInteger)minLenth
                      maxLenth:(NSInteger)maxLenth
                containChinese:(BOOL)containChinese
                 containDigtal:(BOOL)containDigtal
                 containLetter:(BOOL)containLetter
         containOtherCharacter:(NSString *)containOtherCharacter
           firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;


@end


@interface NSString (JKHash)
#pragma mark - Hash
/// 返回结果：32长度(128位，16字节，16进制字符输出则为32字节长度)   终端命令：md5 -s "123"
@property (readonly) NSString *jk_md5String;
/// 返回结果：40长度   终端命令：echo -n "123" | openssl sha -sha1
@property (readonly) NSString *jk_sha1String;
/// 返回结果：56长度   终端命令：echo -n "123" | openssl sha -sha224
@property (readonly) NSString *jk_sha224String;
/// 返回结果：64长度   终端命令：echo -n "123" | openssl sha -sha256
@property (readonly) NSString *jk_sha256String;
/// 返回结果：96长度   终端命令：echo -n "123" | openssl sha -sha384
@property (readonly) NSString *jk_sha384String;
/// 返回结果：128长度   终端命令：echo -n "123" | openssl sha -sha512
@property (readonly) NSString *jk_sha512String;
#pragma mark - HMAC
/// 返回结果：32长度  终端命令：echo -n "123" | openssl dgst -md5 -hmac "123"
- (NSString *)jk_hmacMD5StringWithKey:(NSString *)key;
/// 返回结果：40长度   echo -n "123" | openssl sha -sha1 -hmac "123"
- (NSString *)jk_hmacSHA1StringWithKey:(NSString *)key;
- (NSString *)jk_hmacSHA224StringWithKey:(NSString *)key;
- (NSString *)jk_hmacSHA256StringWithKey:(NSString *)key;
- (NSString *)jk_hmacSHA384StringWithKey:(NSString *)key;
- (NSString *)jk_hmacSHA512StringWithKey:(NSString *)key;
@end
@interface UIColor (JKHEX)
+ (UIColor *)jk_colorWithHex:(UInt32)hex;
+ (UIColor *)jk_colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;
+ (UIColor *)jk_colorWithHexString:(NSString *)hexString;
- (NSString *)jk_HEXString;
///值不需要除以255.0
+ (UIColor *)jk_colorWithWholeRed:(CGFloat)red
                            green:(CGFloat)green
                             blue:(CGFloat)blue
                            alpha:(CGFloat)alpha;
///值不需要除以255.0
+ (UIColor *)jk_colorWithWholeRed:(CGFloat)red
                            green:(CGFloat)green
                             blue:(CGFloat)blue;
@end

@interface NSDictionary (JKJSONString)
/**
 *  @brief NSDictionary转换成JSON字符串
 *
 *  @return  JSON字符串
 */
-(NSString *)jk_JSONString;
@end

@interface UITextView (JKPlaceHolder) <UITextViewDelegate>
@property (nonatomic, strong) UITextView *jk_placeHolderTextView;
- (void)jk_addPlaceHolder:(NSString *)placeHolder;
@end


@interface UIView (JKScreenshot)
/**
 *  @brief  view截图
 *
 *  @return 截图
 */
- (UIImage *)jk_screenshot;

/**
 *  @author Jakey
 *
 *  @brief  截图一个view中所有视图 包括旋转缩放效果
 *
 *  @param maxWidth 限制缩放的最大宽度 保持默认传0
 *
 *  @return 截图
 */
- (UIImage *)jk_screenshot:(CGFloat)maxWidth;
@end
