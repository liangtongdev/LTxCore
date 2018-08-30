//
//  MainTableViewController.m
//  LTxCore
//
//  Created by liangtong on 2018/7/16.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import "TestFilePreviewTableViewController.h"
#import "LTxCoreFilePreviewViewController.h"

@interface TestFilePreviewTableViewController ()



@end

@implementation TestFilePreviewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"文件预览功能";
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:@"filePreview_localPdf"]) {
        LTxCoreFilePreviewViewController* previewVC = [[LTxCoreFilePreviewViewController alloc] init];
        previewVC.fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"filePreview_local" ofType:@"pdf"]];
        [self.navigationController pushViewController:previewVC animated:YES];
    }else if ([cell.reuseIdentifier isEqualToString:@"filePreview_localImage"]) {
        LTxCoreFilePreviewViewController* previewVC = [[LTxCoreFilePreviewViewController alloc] init];
        previewVC.fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"filePreview_local" ofType:@"jpg"]];
        [self.navigationController pushViewController:previewVC animated:YES];
    }else if ([cell.reuseIdentifier isEqualToString:@"filePreview_localVideo"]) {
        LTxCoreFilePreviewViewController* previewVC = [[LTxCoreFilePreviewViewController alloc] init];
        previewVC.fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"filePreview_local" ofType:@"MOV"]];
        previewVC.shareWithOtherApp = YES;
        [self.navigationController pushViewController:previewVC animated:YES];
    }else if ([cell.reuseIdentifier isEqualToString:@"filePreview_webUrl"]){
        LTxCoreFilePreviewViewController* previewVC = [[LTxCoreFilePreviewViewController alloc] init];
        previewVC.fileURL = [NSURL URLWithString:@"https://www.github.com/"];
        previewVC.shareWithOtherApp = YES;
        [self.navigationController pushViewController:previewVC animated:YES];
    }else if ([cell.reuseIdentifier isEqualToString:@"filePreview_pdfUrl"]){
        LTxCoreFilePreviewViewController* previewVC = [[LTxCoreFilePreviewViewController alloc] init];
        previewVC.fileURL = [NSURL URLWithString:@"https://developer.apple.com/ibeacon/Getting-Started-with-iBeacon.pdf"];
        previewVC.shareWithOtherApp = YES;
        previewVC.needToDownload = YES;
        previewVC.preferCache = YES;
        [self.navigationController pushViewController:previewVC animated:YES];
    }else if ([cell.reuseIdentifier isEqualToString:@"filePreview_webVideoUrl1"]){
        LTxCoreFilePreviewViewController* previewVC = [[LTxCoreFilePreviewViewController alloc] init];
        previewVC.fileURL = [NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
        previewVC.shareWithOtherApp = YES;
        previewVC.needToDownload = YES;
        previewVC.preferCache = YES;
         [self.navigationController pushViewController:previewVC animated:YES];
    }else if ([cell.reuseIdentifier isEqualToString:@"filePreview_webVideoUrl2"]){
        LTxCoreFilePreviewViewController* previewVC = [[LTxCoreFilePreviewViewController alloc] init];
        previewVC.fileURL = [NSURL URLWithString:@"http://data.vod.itc.cn/?rb=1&key=jbZhEJhlqlUN-Wj_HEI8BjaVqKNFvDrn&prod=flash&pt=1&new=/205/94/e6zfHOBsSJulHDLoFp3JHC.mp4"];
         [self.navigationController pushViewController:previewVC animated:YES];
    }
}
@end
