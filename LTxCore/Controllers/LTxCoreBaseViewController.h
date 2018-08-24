//
//  LTxCoreBaseViewController.h
//  LTxCore
//
//  Created by liangtong on 2018/7/13.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <LTxCategories/LTxCategories.h>
#import "LTxCoreMJRefresh.h"
#import "LTxCoreConfig.h"

@interface LTxCoreBaseViewController : UIViewController
#pragma mark - 画面提示
@property (nonatomic, strong) NSString* errorTips;
@property (nonatomic, strong) UIScrollView* emptyScrollView;

#pragma mark - ActivityView
-(void)showAnimatingActivityView;
-(void)showAnimatingActivityViewWithStyle:(UIActivityIndicatorViewStyle)style;
-(void)hideAnimatingActivityView;

#pragma mark - 刷新
//下拉刷新
-(void)addPullDownRefresh:(LTxCallbackBlock)pullDownRefresh
                   onView:(UIScrollView*)pullView;
-(void)addPullUpRefresh:(LTxCallbackBlock)pullUpRefresh
                 onView:(UIScrollView*)pullView;
//下拉刷新，上拉加载更多
-(void)addPullDownRefresh:(LTxCallbackBlock)pullDownRefresh
         andPullUpRefresh:(LTxCallbackBlock)pullUpRefresh
                   onView:(UIScrollView*)pullView;
@end
