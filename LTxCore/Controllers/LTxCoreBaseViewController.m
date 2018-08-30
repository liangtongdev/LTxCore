//
//  LTxCoreBaseViewController.m
//  LTxCore
//
//  Created by liangtong on 2018/7/13.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import "LTxCoreBaseViewController.h"

@interface LTxCoreBaseViewController ()
@property(nonatomic, strong, readwrite) LTxCoreEmptyDataSetViewModel* emptyDataSet;
@property (nonatomic, copy) LTxCallbackBlock refreshAction;
@end

@implementation LTxCoreBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*配置界面元素*/
    [self ltx_setupViewConfig];
}

#pragma mark - SetUp
-(void)ltx_setupViewConfig{
    //    /*导航栏透明，配合页面view的渲染起点使用*/
    //    self.navigationController.navigationBar.translucent = YES;
    //   /*
    //    UIRectEdgeNone;       //从navigationBar下面开始计算一直到屏幕tabBar上部
    //    UIRectEdgeAll;        //从屏幕边缘计算（默认）
    //    UIRectEdgeTop;        //navigationBar下面开始计算一直到屏幕tabBar上部
    //    UIRectEdgeBottom;     //从navigationBar下面开始计算一直到屏幕底部
    //    */
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    [self ltx_setupLeftBackButton];
    self.view.backgroundColor = [LTxCoreConfig sharedInstance].viewBackgroundColor;
}

-(void)dealloc{
    self.emptyDataSet = nil;
}

#pragma mark - Left Back Button
-(void)ltx_setupLeftBackButton{
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, LTxNavigationBarItemSize, LTxNavigationBarItemSize)];
    [backBtn addTarget:self action:@selector(ltx_backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:LTxImageWithName(@"ic_navi_back") forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}
-(void)ltx_backAction{
    if (![self.navigationController popViewControllerAnimated:true]) {
        [self dismissViewControllerAnimated:true completion:nil];
    };
}

#pragma mark - ActivityView
-(void)showAnimatingActivityView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
}
-(void)hideAnimatingActivityView{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        MBProgressHUD* hud = [MBProgressHUD HUDForView:self.view];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
    
    
}

#pragma mark - 刷新
//下拉刷新
-(void)addPullDownRefresh:(LTxCallbackBlock)pullDownRefresh
                   onView:(UIScrollView*)pullView{
    //设置刷新及空画面相关
    self.emptyScrollView = pullView;
    self.refreshAction = pullDownRefresh;
    pullView.mj_header = [LTxCoreMJRefresh headerWithRefreshingBlock:pullDownRefresh];
    
    
}
-(void)addPullUpRefresh:(LTxCallbackBlock)pullUpRefresh
                 onView:(UIScrollView*)pullView{
    //设置刷新及空画面相关
    self.emptyScrollView = pullView;
    pullView.mj_footer = [LTxCoreMJRefresh footerWithRefreshingBlock:pullUpRefresh];
    
}
//下拉刷新，上拉加载更多
-(void)addPullDownRefresh:(LTxCallbackBlock)pullDownRefresh
         andPullUpRefresh:(LTxCallbackBlock)pullUpRefresh
                   onView:(UIScrollView*)pullView{
    self.emptyScrollView = pullView;
    self.refreshAction = pullDownRefresh;
    pullView.mj_header = [LTxCoreMJRefresh headerWithRefreshingBlock:pullDownRefresh];
    pullView.mj_footer = [LTxCoreMJRefresh footerWithRefreshingBlock:pullUpRefresh];
}


#pragma mark - Setter
-(void)setEmptyScrollView:(UIScrollView *)emptyScrollView{
    _emptyScrollView = emptyScrollView;
    emptyScrollView.emptyDataSetSource = self.emptyDataSet;
    emptyScrollView.emptyDataSetDelegate = self.emptyDataSet;
}

-(LTxCoreEmptyDataSetViewModel*)emptyDataSet{
    if(!_emptyDataSet){
         _emptyDataSet = [[LTxCoreEmptyDataSetViewModel alloc] init];
    }
    return _emptyDataSet;
}

-(void)setRefreshAction:(LTxCallbackBlock)refreshAction{
    _refreshAction = refreshAction;
    _emptyDataSet.refreshAction = refreshAction;
}
-(void)setErrorTips:(NSString *)errorTips{
    _errorTips = errorTips;
    _emptyDataSet.errorTips = errorTips;
}


@end
