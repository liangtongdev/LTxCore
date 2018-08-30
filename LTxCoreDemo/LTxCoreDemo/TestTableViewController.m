//
//  TestTableViewController.m
//  LTxCoreDemo
//
//  Created by liangtong on 2018/8/30.
//  Copyright © 2018年 LIANGTONG. All rights reserved.
//

#import "TestTableViewController.h"

@interface TestTableViewController ()

@property (nonatomic, strong) NSMutableArray* dataSource;

@end

@implementation TestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"刷新";
    [self addRefreshAndPullAction];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showAnimatingActivityView];
    [self doSomething];
}


#pragma mark - Action

-(void)addRefreshAndPullAction{
    __weak __typeof(self) weakSelf = self;
    [self addPullDownRefresh:^{
        [weakSelf doSomething];
    } andPullUpRefresh:^{
        [weakSelf doSomething];
    }];
}

-(void)doSomething{
    [self.dataSource addObjectsFromArray:@[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16,@17,@18,@19,@20]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideAnimatingActivityView];
         [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    });
}

#pragma mark - TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"BStaffSelectViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%td",indexPath.row + 1];
    return cell;
}

#pragma mark - Getter
-(NSMutableArray*)dataSource{
    if(!_dataSource){
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end
