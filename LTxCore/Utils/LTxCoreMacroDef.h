//
//  LTxCoreMacroDef.h
//  LTxCore
//
//  Created by liangtong on 2018/7/13.
//  Copyright © 2018年 LTx. All rights reserved.
//

/**
 * 宏定义
 * 1、常用的闭包函数
 * 2、语言/资源文件
 * 3、其他
 **/

#import <UIKit/UIKit.h>
#import <Photos/PHAsset.h>

#ifndef LTxCoreMacroDef_h
#define LTxCoreMacroDef_h


typedef void (^LTxCallbackBlock)(void);
typedef void (^LTxBoolCallbackBlock)(BOOL);
typedef void (^LTxFloatCallbackBlock)(CGFloat);
typedef void (^LTxIntegerCallbackBlock)(NSInteger);
typedef void (^LTxStringCallbackBlock)(NSString*);
typedef void (^LTxDictionaryCallbackBlock)(NSDictionary*);
typedef void (^LTxProgressCallbackBlock)(NSProgress*);
typedef void (^LTxObjectCallbackBlock)(id);

typedef void (^LTxBoolAndStringCallbackBlock)(BOOL, NSString*);
typedef void (^LTxBoolAndObjectCallbackBlock)(BOOL, id);
typedef void (^LTxStringAndArrayCallbackBlock)(NSString*, NSArray*);
typedef void (^LTxStringAndDictionaryCallbackBlock)(NSString*, NSDictionary*);
typedef void (^LTxStringAndObjectCallbackBlock)(NSString*, id);

typedef void (^LTxImageAndURLCallbackBlock)(UIImage*, NSURL*);
typedef void (^LTxImageURLAndPHAssetCallbackBlock)(UIImage*, NSURL*, PHAsset *);


#define SelfBundle  [NSBundle bundleForClass:[self class]]

//语言文件
#define LTxLocalizedString(key)  NSLocalizedStringFromTable(key,@"LT.bundle/Language/LT",nil)

//资源文件
#define LTxImageWithName(imageName)  [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"LT.bundle/Images/%@",imageName] ofType:@"png"]]

//导航栏图标大小
#define LTxNavigationBarItemSize 32

#endif /* LTxCoreMacroDef_h */
