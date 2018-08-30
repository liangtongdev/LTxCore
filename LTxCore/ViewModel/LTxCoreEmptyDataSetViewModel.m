//
//  LTxCoreEmptyDataSetViewModel.m
//  AFNetworking
//
//  Created by liangtong on 2018/8/30.
//

#import "LTxCoreEmptyDataSetViewModel.h"

@implementation LTxCoreEmptyDataSetViewModel

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
        _refreshAction();
    }
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    if (_refreshAction) {
        _refreshAction();
    }
}


@end
