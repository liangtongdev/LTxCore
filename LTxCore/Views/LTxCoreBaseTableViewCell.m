//
//  LTxCoreBaseTableViewCell.m
//  LTxCore
//
//  Created by liangtong on 2018/7/13.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import "LTxCoreBaseTableViewCell.h"
#import "LTxCoreConfig.h"

@interface LTxCoreBaseTableViewCell()

@property (weak, nonatomic) UIView *bgView;

@end

@implementation LTxCoreBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupCommonConfig];
}

-(void)setupCommonConfig{
    self.contentView.backgroundColor = [LTxCoreConfig sharedInstance].cellContentViewColor;
    
    self.bgView.layer.cornerRadius = 2.f;
    self.bgView.layer.shadowColor = [LTxCoreConfig sharedInstance].cellContentViewShadowColor;
    self.bgView.layer.shadowOpacity = 0.6;
    self.bgView.layer.shadowOffset = CGSizeMake(3, 3);
    self.bgView.layer.shadowRadius = 3.0;
}

@end
