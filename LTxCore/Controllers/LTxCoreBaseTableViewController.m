//
//  LTxCoreBaseTableViewController.m
//  LTxCore
//
//  Created by liangtong on 2018/7/13.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import "LTxCoreBaseTableViewController.h"

@interface LTxCoreBaseTableViewController ()
@property (nonatomic, copy) LTxCallbackBlock refreshAction;
@property(nonatomic, strong, readwrite) LTxCoreEmptyDataSetViewModel* emptyDataSet;
@end

@implementation LTxCoreBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*配置界面元素*/
    [self ltx_setupViewConfig];
}

-(void)dealloc{
    self.emptyDataSet = nil;
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
    _emptyDataSet = [[LTxCoreEmptyDataSetViewModel alloc] init];
    _emptyDataSet.emptyDataSetChangeCallback = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadEmptyDataSet];
        });
    };
    self.tableView.emptyDataSetSource = _emptyDataSet;
    self.tableView.emptyDataSetDelegate = _emptyDataSet;
    [self.tableView reloadEmptyDataSet];
    
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
    MBProgressHUD* hud = [MBProgressHUD HUDForView:self.view];
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
    });
}
#pragma mark - 刷新
//下拉刷新
-(void)addPullDownRefresh:(LTxCallbackBlock)pullDownRefresh{
    self.refreshAction = pullDownRefresh;
    self.tableView.mj_header = [LTxCoreMJRefresh headerWithRefreshingBlock:pullDownRefresh];
    
}
-(void)addPullUpRefresh:(LTxCallbackBlock)pullUpRefresh{
    self.tableView.mj_footer = [LTxCoreMJRefresh footerWithRefreshingBlock:pullUpRefresh];
    
}
//下拉刷新，上拉加载更多
-(void)addPullDownRefresh:(LTxCallbackBlock)pullDownRefresh
         andPullUpRefresh:(LTxCallbackBlock)pullUpRefresh{
    self.refreshAction = pullDownRefresh;
    self.tableView.mj_header = [LTxCoreMJRefresh headerWithRefreshingBlock:pullDownRefresh];
    self.tableView.mj_footer = [LTxCoreMJRefresh footerWithRefreshingBlock:pullUpRefresh];
}
//停止刷新数据
-(void)finishSipprRefreshing{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideAnimatingActivityView];
    });
    if ([self.tableView.mj_header isRefreshing]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
    }else if ([self.tableView.mj_footer isRefreshing]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}



//TableViewCell的线左侧充满屏幕
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Setter
-(void)setRefreshAction:(LTxCallbackBlock)refreshAction{
    _refreshAction = refreshAction;
    _emptyDataSet.refreshAction = refreshAction;
}


#pragma mark - KVO
-(void)addEmptyDataSetKVO{
    [self.emptyDataSet addObserver:self forKeyPath:@"emptyImage" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)removeEmptyDataSetKVO{
    [self.emptyDataSet removeObserver:self forKeyPath:@"emptyImage" context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)contex{

}

@end
