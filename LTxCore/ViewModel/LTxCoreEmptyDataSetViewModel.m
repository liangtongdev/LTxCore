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
    return _attributedTitle;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    if (!_attributedEmptyDescription) {
        return _attributedEmptyDescription;
    }else if (!_emptyDescription ) {
        NSMutableDictionary *attributes = [NSMutableDictionary new];
        NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        paragraph.alignment = NSTextAlignmentCenter;
        [attributes setObject:[UIFont systemFontOfSize:16.0] forKey:NSFontAttributeName];
        [attributes setObject:[UIColor lightGrayColor] forKey:NSForegroundColorAttributeName];
        [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_emptyDescription attributes:attributes];
        
        return attributedString;
    }else{
        return nil;
    }

}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    if (_emptyImage) {
        return _emptyImage;
    }else if (_emptyDescription || _attributedEmptyDescription) {
        return [UIImage imageNamed:@"ic_error"];//发生错误了
    }else{
        return [UIImage imageNamed:@"ic_no_data"];//初始画面
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
