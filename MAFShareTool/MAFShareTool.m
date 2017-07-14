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
@property (nonatomic, copy) NSString *wechatCode;
@property (nonatomic, copy) NSString *wechatAppid;
@property (nonatomic, copy) NSString *wechatAppSecret;

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
    self.wechatAppid = appID;
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
#pragma mark TencentSessionDelegate 腾讯代理
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
- (void)wechatLoginWithWechatSecret:(NSString *)secret withGetAuthBlock:(WechatGetAuthInfoBlock )block {
    self.wechatAuthBlock = block;
    self.wechatAppSecret = secret;
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo"; //应用授权作用域，如获取用户个人信息则填写snsapi_userinfo
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}
- (void)shareWXTextWithText:(NSString *)text withType:(int )type {
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.text = text;
    req.bText = YES;
    req.scene = type;
    [WXApi sendReq:req];
}
- (void)shareWXImageWithThumbImg:(UIImage *)thumbImg withImageData:(NSData *)imgData withType:(int )type {
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:thumbImg];
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData = imgData;
    message.mediaObject = imageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = type;
    [WXApi sendReq:req];
}
- (void)shareWXWebWithTitle:(NSString *)title withDescription:(NSString *)description withThumberImg:(UIImage *)thumberImg withUrl:(NSString *)url withType:(int )type{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:thumberImg];
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = url;
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = type;
    
    [WXApi sendReq:req];
}
#pragma mark WXApiDelegate 微信代理
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *auth = (SendAuthResp *)resp;
        if ([auth.state isEqualToString:@"123"]) {
            self.wechatCode = auth.code;
            [self wechatGetAccessToken];
        }
    }
    NSLog(@"%@",resp);
}
#pragma mark wechatNetWrok 微信网络请求
- (void)wechatGetAccessToken {
    // 1.根据网址初始化OC字符串对象
    NSString *urlStr = @"https://api.weixin.qq.com/sns/oauth2/access_token";
    // 2.创建NSURL对象
    NSURL *url = [NSURL URLWithString:urlStr];
    // 3.创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 4.创建参数字符串对象
    NSString *parmStr = [NSString stringWithFormat:@"appid=%@&secret=%@&code=%@&grant_type=authorization_code",self.wechatAppid,self.wechatAppSecret,self.wechatCode];
    // 5.将字符串转为NSData对象
    NSData *pramData = [parmStr dataUsingEncoding:NSUTF8StringEncoding];
    // 6.设置请求体
    [request setHTTPBody:pramData];
    // 7.设置请求方式
    [request setHTTPMethod:@"POST"];
    // 创建同步链接
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (self.wechatAuthBlock == NULL || self.wechatAuthBlock == nil) {
        return;
    }
    if ([[dic allKeys] containsObject:@"errcode"]) {
        NSString *err = [NSString stringWithFormat:@"%@:%@",dic[@"errcode"],dic[@"errmsg"]];
        self.wechatAuthBlock(NO, @"", @"", @"", err);
    } else {
        if ([[dic allKeys] containsObject:@"access_token"] && [[dic allKeys] containsObject:@"refresh_token"] && [[dic allKeys] containsObject:@"openid"]) {
            self.wechatAuthBlock(YES, dic[@"access_token"], dic[@"refresh_token"], dic[@"openid"], @"");
        } else {
            self.wechatAuthBlock(NO, @"", @"", @"", @"获取信息不全");
        }
    }
}
- (void)wechatGetInfoWithAccessToken:(NSString *)accessToken withOpenid:(NSString *)openID withGetInfoBlock:(WechatGetInfoBlock )block {
    self.wechatInfoBlock = block;
    // 1.根据网址初始化OC字符串对象
    NSString *urlStr = @"https://api.weixin.qq.com/sns/userinfo";
    // 2.创建NSURL对象
    NSURL *url = [NSURL URLWithString:urlStr];
    // 3.创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 4.创建参数字符串对象
    NSString *parmStr = [NSString stringWithFormat:@"access_token=%@&openid=%@",accessToken,openID];
    // 5.将字符串转为NSData对象
    NSData *pramData = [parmStr dataUsingEncoding:NSUTF8StringEncoding];
    // 6.设置请求体
    [request setHTTPBody:pramData];
    // 7.设置请求方式
    [request setHTTPMethod:@"POST"];
    // 创建同步链接
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (self.wechatInfoBlock == NULL || self.wechatInfoBlock == nil) {
        return;
    }
    if ([[dic allKeys] containsObject:@"errcode"]) {
        NSString *err = [NSString stringWithFormat:@"%@:%@",dic[@"errcode"],dic[@"errmsg"]];
        self.wechatInfoBlock(NO, @{}, err);
    } else {
        self.wechatInfoBlock(YES, dic, @"");
    }
}
#pragma mark 
- (BOOL)HandleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSString *urlStr = url.absoluteString;
    if ([urlStr containsString:@"tencent"]) {
        return [TencentOAuth HandleOpenURL:url];
    } else {
        return [WXApi handleOpenURL:url delegate:self];
    }
}
- (BOOL)HandleOpenURL:(NSURL *)url {
    NSString *urlStr = url.absoluteString;
    if ([urlStr containsString:@"tencent"]) {
        return [TencentOAuth HandleOpenURL:url];
    } else {
        return [WXApi handleOpenURL:url delegate:self];
    }
}

@end
