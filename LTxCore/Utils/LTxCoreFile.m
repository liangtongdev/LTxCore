//
//  LTxCoreFile.m
//  LTxCore
//
//  Created by liangtong on 2018/7/13.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import "LTxCoreFile.h"
@implementation LTxCoreFile
///#begin
/**
 *  @brief    检查文件格式：可以理解为：图片、视频、PDF（其他文件类型）
 *
 */
///#end
+(LTxCoreFileType)fileTypeWithURL:(NSString*)url{
    NSArray* imageTypes = @[@"png",@"bmp",@"gif",@"jpg",@"jpeg",@"ico"];
    NSArray* videoTypes  = @[@"mp4",@"mov",@"m3u8",@"mp3"];
    NSArray* docTypes  = @[@"doc",@"docx",@"pdf",@"ppt",@"pptx",@"xls",@"xlsx"];
    NSString* type = [[url pathExtension] lowercaseString];
    for(int i=0; i<imageTypes.count; i++) {
        if([type isEqualToString:[imageTypes objectAtIndex:i]]) {
            return LTxCoreFileTypeImage;
        }
    }
    for(int i=0; i<videoTypes.count; i++) {
        if([type isEqualToString:[videoTypes objectAtIndex:i]]) {
            return LTxCoreFileTypeVideo;
        }
    }
    for(int i=0; i<docTypes.count; i++) {
        if([type isEqualToString:[docTypes objectAtIndex:i]]) {
            return LTxCoreFileTypeDocument;
        }
    }
    return LTxCoreFileTypeUnkonwn;
}

///#begin
/**
 * @brief    根据文件扩展类型，获取文件的扩展名图片
 *
 */
///#end
+ (NSString*)typeImageNameWithPathExtension:(NSString*)pathExtension{
    NSString* typeImageName = @"ic_document_file";
    if (pathExtension) {
        NSString* type = [pathExtension lowercaseString];
        NSArray* imageTypes = @[@"png",@"bmp",@"gif",@"jpg",@"jpeg",@"ico"];
        for (NSString* sub in imageTypes) {
            if ([sub isEqualToString:type]) {
                return @"ic_document_png";
            }
        }
        NSArray* wordTypes = @[@"doc",@"docx"];
        for (NSString* sub in wordTypes) {
            if ([sub isEqualToString:type]) {
                return @"ic_document_word";
            }
        }
        NSArray* videoTypes  = @[@"mp4",@"mov",@"m3u8",@"mp3"];
        for (NSString* sub in videoTypes) {
            if ([sub isEqualToString:type]) {
                return @"ic_document_mov";
            }
        }
        NSArray* pdfTypes  = @[@"pdf"];
        for (NSString* sub in pdfTypes) {
            if ([sub isEqualToString:type]) {
                return @"ic_document_pdf";
            }
        }
        NSArray* pptTypes  = @[@"ppt",@"pptx"];
        for (NSString* sub in pptTypes) {
            if ([sub isEqualToString:type]) {
                return @"ic_document_ppt";
            }
        }
        NSArray* txtTypes  = @[@"txt"];
        for (NSString* sub in txtTypes) {
            if ([sub isEqualToString:type]) {
                return @"ic_document_txt";
            }
        }
        NSArray* xlsTypes  = @[@"xls",@"xlsx"];
        for (NSString* sub in xlsTypes) {
            if ([sub isEqualToString:type]) {
                return @"ic_document_xls";
            }
        }
    }
    return typeImageName;
}
@end
