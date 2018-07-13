//
//  LTxCorePopup.m
//  LTxCore
//
//  Created by liangtong on 2018/7/13.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import "LTxCorePopup.h"
#import "LTxCoreConfig.h"

@implementation LTxCorePopup

#pragma mark - Toast
/**
 * 在特定View上展示提示信息
 **/
+(void)showToast:(NSString*)msg onView:(UIView*)view{
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.messageFont = [UIFont systemFontOfSize:16.0];
    style.messageColor = [UIColor whiteColor];
    style.messageAlignment = NSTextAlignmentCenter;
    style.backgroundColor = [LTxCoreConfig sharedInstance].hintColor;
    
    [CSToastManager setSharedStyle:style];
    [CSToastManager setQueueEnabled:NO];
    
    // - position: [NSValue valueWithCGPoint:CGPointMake(110, 110)]
    [view hideAllToasts];
    dispatch_async(dispatch_get_main_queue(), ^{
        [view makeToast:msg duration:3.0 position:CSToastPositionBottom style:style];
    });
}

#pragma mark - Alert

/**
 * 特定位置展示Alert
 **/
+(void)showAlertOnViewController:(UIViewController*)viewController
                      sourceView:(UIView*)sourceView//iPad
                      sourceRect:(CGRect)sourceRect//iPad
                           style:(UIAlertControllerStyle)style
                           title:(NSString*)title
                         message:(NSString*)message
                         actions:(UIAlertAction*)action,... NS_REQUIRES_NIL_TERMINATION{
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover) {
        popover.sourceView = sourceView;
        popover.sourceRect = sourceRect;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    
    if(action){
        [alertController addAction:action];
        
        va_list list;//指向变参的指针
        va_start(list, action);//使用第一个参数来初使化list指针
        while (true) {
            UIAlertAction* otherAction = va_arg(list, UIAlertAction*);//后续参数便利
            if (!otherAction) {
                break;
            }
            [alertController addAction:otherAction];
        }
        va_end(list);// 清空参数列表，并置参数指针args无效
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [viewController presentViewController:alertController animated:YES completion:nil];
    });
}
@end
