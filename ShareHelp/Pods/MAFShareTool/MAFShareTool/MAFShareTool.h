//
//  MAFShareTool.h
//  ShareHelp
//
//  Created by 高赛 on 2017/7/12.
//  Copyright © 2017年 高赛. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 登陆授权回调
 0 成功,1 取消授权,2 授权失败,3 没有网络
 */
typedef void (^LoginBlock)(int status, NSString *accessToken, NSString *openID);
/**
 获取用户信息回调
 0 成功,1 失败
 */
typedef void (^GetInfoBlock)(int status, NSDictionary *info, NSString *erroMsg);

@interface MAFShareTool : NSObject

@property (nonatomic, copy) LoginBlock loginBlock;

@property (nonatomic, copy) GetInfoBlock getInfoBlock;

+ (MAFShareTool *)sharedInstance;
#pragma mark 初始化SDK
/**
 初始化腾讯qqSDK
 */
- (void)initTencentSDKWithAppID:(NSString *)appID;
/**
 初始化微信sdk
 */
- (void)initWechatSDKWithAppID:(NSString *)appID;
#pragma mark 腾讯qq
/**
 腾讯qq发起授权
 */
- (void)qqLoginWithLoginBlock:(LoginBlock )loginBlock;
/**
 获取授权后的信息
 */
- (void)qqGetInfoWithBlock:(GetInfoBlock )getInfoBlock;
/**
 qq消息分享纯文本消息
 */
- (void)shareQQTextMessageWithText:(NSString *)text;
/**
 qq消息分享纯图片消息
 */
- (void)shareQQImageMessageWithImageData:(NSData *)data;
/**
 qq消息分享网络链接分享
 */
- (void)shareQQNetMessageWithUrl:(NSURL *)url andTitle:(NSString *)title andDescription:(NSString *)description andPreviewImageUrl:(NSURL *)previewImageUrl;
/**
 qq空间纯文本分享
 */
- (void)shareQZoneTextMessageWithText:(NSString *)text;
/**
 qq空间网络链接分享
 */
- (void)shareQZoneNetMessageWithUrl:(NSURL *)url andTitle:(NSString *)title andDescription:(NSString *)description andPreviewImageUrl:(NSURL *)previewImageUrl;
#pragma mark 微信
#pragma mark 微博

@end
