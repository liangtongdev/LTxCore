//
//  LTxCoreBaseTableViewController.m
//  LTxCore
//
//  Created by liangtong on 2018/7/13.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import "LTxCoreBaseTableViewController.h"

@interface LTxCoreBaseTableViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (nonatomic, copy) LTxCallbackBlock refreshAction;

@end

@implementation LTxCoreBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*配置界面元素*/
    [self setupViewConfig];
}

#pragma mark - SetUp
-(void)setupViewConfig{
    [self setupLeftBackButton];
    self.view.backgroundColor = [LTxCoreConfig sharedInstance].viewBackgroundColor;
    [self setupActivityView];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.tableView reloadEmptyDataSet];
}

#pragma mark - Left Back Button
-(void)setupLeftBackButton{
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:LTxImageWithName(@"ic_navi_back") forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}
-(void)backAction{
    if (![self.navigationController popViewControllerAnimated:true]) {
        [self dismissViewControllerAnimated:true completion:nil];
    };
}

#pragma mark - ActivityView
-(void)setupActivityView{
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.translatesAutoresizingMaskIntoConstraints = NO;
    _activityView.layer.cornerRadius = 8.f;
    _activityView.clipsToBounds = YES;
    [self.view addSubview:_activityView];
    
    //添加约束
    //约束-X
    NSLayoutConstraint* centerXConstraint = [NSLayoutConstraint constraintWithItem:_activityView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0];
    //约束-Y
    NSLayoutConstraint* centerYConstraint = [NSLayoutConstraint constraintWithItem:_activityView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.f constant:-100];
    //宽度
    NSLayoutConstraint* widthConstraint = [NSLayoutConstraint constraintWithItem:_activityView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:80.f];
    //高度
    NSLayoutConstraint* heightConstraint = [NSLayoutConstraint constraintWithItem:_activityView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_activityView attribute:NSLayoutAttributeWidth multiplier:1.f constant:0.f];
    
    //激活约束，等价于单独设置约束.active = YES;
    [NSLayoutConstraint activateConstraints:@[centerXConstraint,centerYConstraint,widthConstraint,heightConstraint]];
    
    _activityView.backgroundColor = [LTxCoreConfig sharedInstance].activityViewBackgroundColor;
    
}
-(void)showAnimatingActivityView{
    [self.view bringSubviewToFront:_activityView];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityView startAnimating];
    });
}
-(void)showAnimatingActivityViewWithStyle:(UIActivityIndicatorViewStyle)style{
    _activityView.activityIndicatorViewStyle = style;
    [self.view bringSubviewToFront:_activityView];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityView startAnimating];
    });
}
-(void)hideAnimatingActivityView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityView stopAnimating];
    });
}
#pragma mark - 刷新
//下拉刷新
-(void)addPullDownRefresh:(LTxCallbackBlock)pullDownRefresh{
    _refreshAction = pullDownRefresh;
    self.tableView.mj_header = [self headerWithRefreshingBlock:pullDownRefresh];
    
}
-(void)addPullUpRefresh:(LTxCallbackBlock)pullUpRefresh{
    self.tableView.mj_footer = [self footerWithRefreshingBlock:pullUpRefresh];
    
}
//下拉刷新，上拉加载更多
-(void)addPullDownRefresh:(LTxCallbackBlock)pullDownRefresh
         andPullUpRefresh:(LTxCallbackBlock)pullUpRefresh{
    _refreshAction = pullDownRefresh;
    self.tableView.mj_header = [self headerWithRefreshingBlock:pullDownRefresh];
    self.tableView.mj_footer = [self footerWithRefreshingBlock:pullUpRefresh];
}
//停止刷新数据
-(void)finishSipprRefreshing{
    if (self.activityView.isAnimating) {
        [self hideAnimatingActivityView];
    }
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

-(LTxCoreMJRefreshHeader*)headerWithRefreshingBlock:(LTxCallbackBlock)pullDownRefresh{
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
-(LTxCoreMJRefreshFooter*)footerWithRefreshingBlock:(LTxCallbackBlock)pullUpRefresh{
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


#pragma mark - 空画面及错误提示
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    return nil;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    if (_errorTips == nil) {
        return nil;
    }else{
        NSString *text = _errorTips;
        NSMutableDictionary *attributes = [NSMutableDictionary new];
        NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        paragraph.alignment = NSTextAlignmentCenter;
        [attributes setObject:[UIFont systemFontOfSize:16.0] forKey:NSFontAttributeName];
        [attributes setObject:[UIColor lightGrayColor] forKey:NSForegroundColorAttributeName];
        [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
        
        return attributedString;
    }
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    if (_errorTips == nil) {
        return [UIImage imageNamed:@"ic_no_data"];//初始画面
    }else{
        return [UIImage imageNamed:@"app_view_error_code"];//发生错误了
    }
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}

//- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
//    NSString *text;
//    NSMutableDictionary *attributes = [NSMutableDictionary new];
//    [attributes setObject:[UIFont systemFontOfSize:13.0] forKey:NSFontAttributeName];
//
//    if (_errorTips == nil) {
//        text = @"";
//        [attributes setObject:[LTxSipprConfig sharedInstance].skinColor forKey:NSForegroundColorAttributeName];
//    }else{
//        text = @"点我重新加载";
//        [attributes setObject:[LTxSipprConfig sharedInstance].skinColor forKey:NSForegroundColorAttributeName];
//    }
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return NO;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    return 20.f;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return -0.f;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    if (_refreshAction) {
        [self showAnimatingActivityView];
        _refreshAction();
    }
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    if (_refreshAction) {
        [self showAnimatingActivityView];
        _refreshAction();
    }
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

@end
