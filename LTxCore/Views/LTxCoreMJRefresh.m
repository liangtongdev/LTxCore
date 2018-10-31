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
    
//    //设置普通状态的动画图片
//    [self setImages:[NSArray arrayWithObject:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"LT.bundle/Loading/table_refresh_pulling" ofType:@"png"]]]
//           forState:MJRefreshStateIdle];
//    [self setImages:[NSArray arrayWithObject:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"LT.bundle/Loading/table_refresh_pulling" ofType:@"png"]]]
//           forState:MJRefreshStatePulling];
//
//    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//    NSMutableArray *refreshingImages = [NSMutableArray array];
//    for (int i = 1; i <= 33; i++) {
//        UIImage *image = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"LT.bundle/Loading/table_refresh_loading_%d", i] ofType:@"png"]];
//        if (image) {
//            [refreshingImages addObject:image];
//        }
//    }
//
//    // 设置正在刷新状态的动画图片
//    [self setImages:refreshingImages
//           duration:1.f
//           forState:MJRefreshStateRefreshing];
}
@end

#pragma mark - Footer
@implementation LTxCoreMJRefreshFooter

- (void)prepare{
    [super prepare];
    
//    [self setImages:[NSArray arrayWithObject:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"LT.bundle/Loading/table_refresh_pulling" ofType:@"png"]]]
//           forState:MJRefreshStateIdle];
//    [self setImages:[NSArray arrayWithObject:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"LT.bundle/Loading/table_refresh_pulling" ofType:@"png"]]]
//           forState:MJRefreshStatePulling];
//    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//    NSMutableArray *refreshingImages = [NSMutableArray array];
//    for (int i = 1; i <= 33; i++) {
//        UIImage *image = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"LT.bundle/Loading/table_refresh_loading_%d", i] ofType:@"png"]];
//        if (image) {
//            [refreshingImages addObject:image];
//        }
//    }
//    
//    // 设置正在刷新状态的动画图片
//    [self setImages:refreshingImages
//           duration:1.f
//           forState:MJRefreshStateRefreshing];
//    
//    [self setTitle:LTxLocalizedString(@"text_cmn_refresh_pull_up_no_more") forState:MJRefreshStateNoMoreData];
}

@end

#pragma mark - LTxCoreMJRefresh
@implementation LTxCoreMJRefresh 
+(LTxCoreMJRefreshHeader*)headerWithRefreshingBlock:(LTxCallbackBlock)pullDownRefresh{
    LTxCoreMJRefreshHeader *header = [LTxCoreMJRefreshHeader headerWithRefreshingBlock:^{
        if(pullDownRefresh){//加载数据
            pullDownRefresh();
            //            pullDownRefresh(^{
            //                dispatch_async(dispatch_get_main_queue(), ^{
            //                    [self.tableView reloadData];
            //                    [self.tableView.mj_header endRefreshing];
            //                });
            //            });
        }
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.textColor = [UIColor lightGrayColor];
    // 设置文字
    [header setTitle:LTxLocalizedString(@"text_cmn_refresh_pull_down_idle") forState:MJRefreshStateIdle];
    [header setTitle:LTxLocalizedString(@"text_cmn_refresh_pull_down_pulling") forState:MJRefreshStatePulling];
    [header setTitle:LTxLocalizedString(@"text_cmn_refresh_pull_down_refreshing") forState:MJRefreshStateRefreshing];
    return header;
}
+(LTxCoreMJRefreshFooter*)footerWithRefreshingBlock:(LTxCallbackBlock)pullUpRefresh{
    LTxCoreMJRefreshFooter *footer = [LTxCoreMJRefreshFooter footerWithRefreshingBlock:^{
        if(pullUpRefresh){//加载数据
            pullUpRefresh();
        }
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    footer.automaticallyChangeAlpha = YES;
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    // 设置文字
    [footer setTitle:LTxLocalizedString(@"text_cmn_refresh_pull_up_idle") forState:MJRefreshStateIdle];
    [footer setTitle:LTxLocalizedString(@"text_cmn_refresh_pull_up_pulling") forState:MJRefreshStatePulling];
    [footer setTitle:LTxLocalizedString(@"text_cmn_refresh_pull_up_refreshing") forState:MJRefreshStateRefreshing];
    return footer;
}
@end
