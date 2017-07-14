//
//  MAFShareTool.m
//  ShareHelp
//
//  Created by 高赛 on 2017/7/12.
//  Copyright © 2017年 高赛. All rights reserved.
//

#import "MAFShareTool.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/sdkdef.h>
#import <WechatOpenSDK/WXApi.h>

@interface MAFShareTool()<TencentSessionDelegate, TencentLoginDelegate, WXApiDelegate>

@property (nonatomic, retain) TencentOAuth *tencentOAuth;

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
#pragma mark 初始化SDK
/**
 初始化腾讯qqSDK
 */
- (void)initTencentSDKWithAppID:(NSString *)appID {
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:appID andDelegate:self];
    self.tencentOAuth.redirectURI = @"";
}
/**
 初始化微信sdk
 */
- (void)initWechatSDKWithAppID:(NSString *)appID {
    [WXApi registerApp:appID];
}
#pragma mark 腾讯qq
/**
 腾讯qq发起授权
 */
- (void)qqLoginWithLoginBlock:(LoginBlock )loginBlock {
    self.loginBlock = loginBlock;
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_GET_INFO,
                            nil];
    self.tencentOAuth.authShareType = AuthShareType_QQ;
    [self.tencentOAuth authorize:permissions inSafari:NO];
}
/**
 获取授权后的信息
 */
- (void)qqGetInfoWithBlock:(GetInfoBlock )getInfoBlock {
    self.getInfoBlock = getInfoBlock;
    BOOL success = [self.tencentOAuth getUserInfo];
    if (!success) {
        self.getInfoBlock(1, @{}, @"");
    }
}
/**
 qq消息分享纯文本消息
 */
- (void)shareQQTextMessageWithText:(NSString *)text {
    
    QQApiTextObject* txtObj = [QQApiTextObject objectWithText:text];
    txtObj.shareDestType = ShareDestTypeQQ;
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:txtObj];
    
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}
/**
 qq消息分享纯图片消息
 */
- (void)shareQQImageMessageWithImageData:(NSData *)data {
    
    QQApiImageObject* img = [QQApiImageObject objectWithData:data previewImageData:data title:@" " description:@" "];
    img.shareDestType = ShareDestTypeQQ;
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}
/**
 qq消息分享网络链接分享
 */
- (void)shareQQNetMessageWithUrl:(NSURL *)url andTitle:(NSString *)title andDescription:(NSString *)description andPreviewImageUrl:(NSURL *)previewImageUrl {
    //    NSURL *previewURL = [NSURL URLWithString:@"http://img1.gtimg.com/sports/pics/hv1/87/16/1037/67435092.jpg"];
    //    NSURL* url = [NSURL URLWithString:@"http://sports.qq.com/a/20120510/000650.htm"];
    QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:@"标题" description:@"描述" previewImageURL:previewImageUrl];
    img.shareDestType = ShareDestTypeQQ;
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}
/**
 qq空间纯文本分享
 */
- (void)shareQZoneTextMessageWithText:(NSString *)text {
    
    QQApiImageArrayForQZoneObject* txtObj = [QQApiImageArrayForQZoneObject objectWithimageDataArray:nil title:text extMap:nil];
    txtObj.shareDestType = ShareDestTypeQQ;
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:txtObj];
    
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}
/**
 qq空间网络链接分享
 */
- (void)shareQZoneNetMessageWithUrl:(NSURL *)url andTitle:(NSString *)title andDescription:(NSString *)description andPreviewImageUrl:(NSURL *)previewImageUrl {
    QQApiNewsObject* imgObj = [QQApiNewsObject objectWithURL:url title:title description:description previewImageURL:previewImageUrl];
    [imgObj setTitle:title ? : @""];
    [imgObj setCflag:kQQAPICtrlFlagQZoneShareOnStart]; //不要忘记设置这个flag
    
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:imgObj];
    
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    [self handleSendResult:sent];
}
#pragma mark TencentSessionDelegate
- (void)tencentDidLogin {
    if (self.tencentOAuth.accessToken && 0 != [self.tencentOAuth.accessToken length])
    {
        //  记录登录用户的OpenID、Token以及过期时间
        NSString *accessToken = self.tencentOAuth.accessToken;
        NSLog(@"%@",accessToken);
    }

    if (self.loginBlock != NULL && self.loginBlock != nil) {
        self.loginBlock(0,self.tencentOAuth.accessToken,self.tencentOAuth.openId);
    }
}
- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (cancelled) {
        if (self.loginBlock != NULL && self.loginBlock != nil) {
            self.loginBlock(1,@"",@"");
        }
    } else {
        if (self.loginBlock != NULL && self.loginBlock != nil) {
            self.loginBlock(2,@"",@"");
        }
    }
}
- (void)tencentDidNotNetWork {
    if (self.loginBlock != NULL && self.loginBlock != nil) {
        self.loginBlock(3,@"",@"");
    }
}
- (void)getUserInfoResponse:(APIResponse *)response {
    if (URLREQUEST_SUCCEED == response.retCode
        && kOpenSDKErrorSuccess == response.detailRetCode) {
        self.getInfoBlock(0, response.jsonResponse, @"");
    } else {
        NSString *errMsg = [NSString stringWithFormat:@"errorMsg:%@\n%@", response.errorMsg, [response.jsonResponse objectForKey:@"msg"]];
        self.getInfoBlock(1, @{}, errMsg);
    }
    
}
- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPITIMNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装TIM" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        case EQQAPITIMNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIVERSIONNEEDUPDATE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"当前QQ版本太低，需要更新" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case ETIMAPIVERSIONNEEDUPDATE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"当前QQ版本太低，需要更新" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        default:
        {
            break;
        }
    }
}
#pragma mark 微信
- (void)wechatLogin {
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo"; //应用授权作用域，如获取用户个人信息则填写snsapi_userinfo
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}
#pragma mark 
- (BOOL)HandleOpenURL:(NSURL *)url {
    NSString *urlStr = url.absoluteString;
    if ([urlStr containsString:@"tencent"]) {
        return [TencentOAuth HandleOpenURL:url];
    } else {
        return [WXApi handleOpenURL:url delegate:self];
    }
}

@end
