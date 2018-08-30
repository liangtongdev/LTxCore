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

@property (nonatomic, copy) NSString* errorTips;
@property (nonatomic, copy) LTxCallbackBlock refreshAction;

@end
