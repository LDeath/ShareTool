//
//  AppDelegate.m
//  ShareHelp
//
//  Created by 高赛 on 2017/7/13.
//  Copyright © 2017年 高赛. All rights reserved.
//

#import "AppDelegate.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <WechatOpenSDK/WXApi.h>
#import "MAFShareTool.h"

#define TencentAppID @"1105185695"
#define TencentAppKey @"orwhtbsgzrHAUNum"
#define WXAppKey @"wx2009368a9d89ba0a"
#define WXAppSecret @"4309f3be77ac5d08f7106841227a0327"
#define WeiBoAppKey @"3743428607"
#define WeiBoAppSecret @"8fe093bdbf0b44558d761afcbcb09ec3"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    MAFShareTool *shareTool = [MAFShareTool sharedInstance];
    [shareTool initTencentSDKWithAppID:TencentAppID];
    [shareTool initWechatSDKWithAppID:WXAppKey];
    [shareTool initWeiboSdkWithAppid:WeiBoAppKey];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [[MAFShareTool sharedInstance] HandleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [[MAFShareTool sharedInstance] HandleOpenURL:url];
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
