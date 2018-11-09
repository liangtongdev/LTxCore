//
//  LTxCoreBaseViewController.h
//  LTxCore
//
//  Created by liangtong on 2018/7/13.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <LTxCategories/LTxCategories.h>
#import "LTxCoreEmptyDataSetViewModel.h"//空画面
#import "LTxCoreMJRefresh.h"
#import "LTxCoreConfig.h"

@interface LTxCoreBaseViewController : UIViewController
#pragma mark - 画面提示
@property (nonatomic, strong) UIScrollView* emptyScrollView;
@property(nonatomic, strong, readonly) LTxCoreEmptyDataSetViewModel* emptyDataSet;

#pragma mark - ActivityView
-(void)showAnimatingActivityView;
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
