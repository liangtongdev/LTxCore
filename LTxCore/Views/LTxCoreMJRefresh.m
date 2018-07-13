//
//  LTxCoreMJRefresh.m
//  LTxCore
//
//  Created by liangtong on 2018/7/13.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import "LTxCoreMJRefresh.h"
#import "LTxCoreConfig.h"

#pragma mark - Header
@implementation LTxCoreMJRefreshHeader

- (void)prepare{
    [super prepare];
    
    //设置普通状态的动画图片
    [self setImages:[NSArray arrayWithObject:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"LT.bundle/Loading/table_refresh_pulling" ofType:@"png"]]]
           forState:MJRefreshStateIdle];
    [self setImages:[NSArray arrayWithObject:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"LT.bundle/Loading/table_refresh_pulling" ofType:@"png"]]]
           forState:MJRefreshStatePulling];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 1; i <= 33; i++) {
        UIImage *image = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"LT.bundle/Loading/table_refresh_loading_%d", i] ofType:@"png"]];
        if (image) {
            [refreshingImages addObject:image];
        }
    }
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages
           duration:1.f
           forState:MJRefreshStateRefreshing];
}
@end

#pragma mark - Footer
@implementation LTxCoreMJRefreshFooter

- (void)prepare{
    [super prepare];
    
    [self setImages:[NSArray arrayWithObject:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"LT.bundle/Loading/table_refresh_pulling" ofType:@"png"]]]
           forState:MJRefreshStateIdle];
    [self setImages:[NSArray arrayWithObject:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"LT.bundle/Loading/table_refresh_pulling" ofType:@"png"]]]
           forState:MJRefreshStatePulling];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 1; i <= 33; i++) {
        UIImage *image = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"LT.bundle/Loading/table_refresh_loading_%d", i] ofType:@"png"]];
        if (image) {
            [refreshingImages addObject:image];
        }
    }
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages
           duration:1.f
           forState:MJRefreshStateRefreshing];
    
    [self setTitle:LTxLocalizedString(@"text_cmn_refresh_pull_up_no_more") forState:MJRefreshStateNoMoreData];
}

@end
