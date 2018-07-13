//
//  LTxCoreBaseTableViewController.h
//  LTxCore
//
//  Created by liangtong on 2018/7/13.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "LTxCoreMJRefresh.h"
#import "LTxCoreConfig.h"
#import "LTxCoreCategories.h"
#import "LTxCorePopup.h"
@interface LTxCoreBaseTableViewController : UITableViewController
#pragma mark - 画面提示
@property(nonatomic,strong) NSString* errorTips;

#pragma mark - ActivityView
-(void)showAnimatingActivityView;
-(void)showAnimatingActivityViewWithStyle:(UIActivityIndicatorViewStyle)style;
-(void)hideAnimatingActivityView;

#pragma mark - 刷新
//下拉刷新
-(void)addPullDownRefresh:(LTxCallbackBlock)pullDownRefresh;
//上拉加载更多
-(void)addPullUpRefresh:(LTxCallbackBlock)pullUpRefresh;
//下拉刷新，上拉加载更多
-(void)addPullDownRefresh:(LTxCallbackBlock)pullDownRefresh
         andPullUpRefresh:(LTxCallbackBlock)pullUpRefresh;
//停止刷新数据
-(void)finishSipprRefreshing;
@end
