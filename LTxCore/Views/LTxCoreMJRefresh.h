//
//  LTxCoreMJRefresh.h
//  LTxCore
//
//  Created by liangtong on 2018/7/13.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MJRefresh/MJRefreshGifHeader.h>
#import <MJRefresh/MJRefreshAutoGifFooter.h>

#import "LTxCoreConfig.h"

#pragma mark - Header
@interface LTxCoreMJRefreshHeader : MJRefreshGifHeader

@end

#pragma mark - Footer
@interface LTxCoreMJRefreshFooter : MJRefreshAutoGifFooter

@end

#pragma mark - LTxCoreMJRefresh
@interface LTxCoreMJRefresh : NSObject
+(LTxCoreMJRefreshHeader*)headerWithRefreshingBlock:(LTxCallbackBlock)pullDownRefresh;
+(LTxCoreMJRefreshFooter*)footerWithRefreshingBlock:(LTxCallbackBlock)pullUpRefresh;
@end

