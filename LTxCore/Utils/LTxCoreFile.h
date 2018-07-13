//
//  LTxCoreFile.h
//  LTxCore
//
//  Created by liangtong on 2018/7/13.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * 文件类型
 **/

typedef NS_ENUM(NSInteger, LTxCoreFileType) {
    LTxCoreFileTypeImage = 0,  // 照片
    LTxCoreFileTypeVideo,      //视频
    LTxCoreFileTypeDocument,    // Document
    LTxCoreFileTypeUnkonwn    // Unkonwn
};

@interface LTxCoreFile : NSObject

///#begin
/**
 * @brief    检查文件格式：可以理解为：图片、视频、PDF（其他文件类型）
 *
 */
///#end
+(LTxCoreFileType)fileTypeWithURL:(NSString*)url;


///#begin
/**
 * @brief    根据文件扩展类型，获取文件的扩展名图片
 *
 */
///#end
+ (NSString*)typeImageNameWithPathExtension:(NSString*)pathExtension;
@end
