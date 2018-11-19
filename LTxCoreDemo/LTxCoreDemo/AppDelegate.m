//
//  AppDelegate.m
//  LTxCore
//
//  Created by liangtong on 2018/7/13.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import "AppDelegate.h"
#import "LTxCore.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    [LTxCoreConfig sharedInstance].skinColor = [UIColor brownColor];
    [[LTxCoreConfig sharedInstance] appSetup];
    
    [LTxCoreFileManager fileManagerInit];
    [LTxCoreDatabase tablesInit];
    
//    [self testDownload];
    
//    [LTxCoreDownloadTaskService sharedInstance];
    
//    [self testErrorCode];
    
    return YES;
}


-(void)testDownload{
    for (NSInteger i = 1; i < 20; ++i) {
        [[LTxCoreDownloadTaskService sharedInstance] addDownloadTaskWithURL:@"https://developer.apple.com/ibeacon/Getting-Started-with-iBeacon.pdf" pathInSandbox:LTX_CORE_FILE_PREVIEW_CACHE_RELATIVE_PATH saveName:[NSString stringWithFormat:@"test_download_%td",i] unzip:@0];
    }
}

-(void)testErrorCode{
    NSDictionary* params = @{
                             @"username":@"liangtong",
                             @"password":@"111112",
                             @"appId":@"8c41f00f-8870-469d-8180-5d9e556f0170",
                             };
    [LTxCoreHttpService doPostWithURL:@"http://192.168.1.75:8802/eepj-base-login/v1/api/mobile/user/authentication" param:params complete:^(NSString *error, id code) {
        
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
