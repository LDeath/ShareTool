//
//  MAFShareTool.m
//  ShareHelp
//
//  Created by 高赛 on 2017/7/12.
//  Copyright © 2017年 高赛. All rights reserved.
//

#import "MAFShareTool.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface MAFShareTool()<TencentSessionDelegate>

@property (nonatomic, retain)TencentOAuth *tencentOAuth;

@end

@implementation MAFShareTool

static id instance = nil;
+ (MAFShareTool *)sharedInstance {
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        instance = [[MAFShareTool alloc] init];
    });
    return instance;
}

- (void)initTencentSDKWithAppID:(NSString *)appID {
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:appID andDelegate:self];
}

@end
