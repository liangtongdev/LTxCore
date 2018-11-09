//
//  LTxCoreEmptyDataSetViewModel.h
//  AFNetworking
//
//  Created by liangtong on 2018/8/30.
//

#import <Foundation/Foundation.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "LTxCoreConfig.h"

/***
 * 空画面相关协议实现类
 **/
@interface LTxCoreEmptyDataSetViewModel : NSObject<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

//图片
@property (nonatomic, strong) UIImage* emptyImage;
//标题
@property (nonatomic, copy) NSAttributedString* attributedTitle;

//描述
@property (nonatomic, copy) NSString* emptyDescription;
@property (nonatomic, copy) NSAttributedString* attributedEmptyDescription;

//点击空画面的回调
@property (nonatomic, copy) LTxCallbackBlock refreshAction;

@end
