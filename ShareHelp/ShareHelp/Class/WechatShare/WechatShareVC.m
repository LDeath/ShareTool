//
//  WechatShareVC.m
//  ShareHelp
//
//  Created by 高赛 on 2017/7/13.
//  Copyright © 2017年 高赛. All rights reserved.
//

#import "WechatShareVC.h"
#import "MAFShareTool.h"

@interface WechatShareVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *openID;

@end

@implementation WechatShareVC

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithObjects:@"微信登陆",@"获取用户信息",@"微信纯文字分享",@"微信图片分享",@"微信朋友圈纯文字分享",@"微信朋友圈图片分享",@"微信网页分享",@"微信朋友圈网页分享", nil];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"微信分享与登录";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weixinCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"weixinCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self weixinLogin];
    } else if (indexPath.row == 1) {
        [self getInfo];
    } else if (indexPath.row == 2) {
        [self shareText];
    } else if (indexPath.row == 3) {
        [self shareImage];
    } else if (indexPath.row == 4) {
        [self shareTextQ];
    } else if (indexPath.row == 5) {
        [self shareImageQ];
    } else if (indexPath.row == 6) {
        [self shareWeb];
    } else if (indexPath.row == 7) {
        [self shareWebQ];
    }
}
- (void)weixinLogin {
    MAFShareTool *shareTool = [MAFShareTool sharedInstance];
    [shareTool wechatLoginWithWechatSecret:@"4309f3be77ac5d08f7106841227a0327" withGetAuthBlock:^(BOOL isSuccess, NSString *access_token, NSString *refresh_token, NSString *openid, NSString *errmsg) {
        if (isSuccess) {
            NSLog(@"access_token:%@,openid:%@", access_token,openid);
            self.accessToken = access_token;
            self.openID = openid;
        }
    }];
}
- (void)getInfo {
    if (self.accessToken == nil || [self.accessToken isEqualToString:@""] || self.openID == nil || [self.openID isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有accessToken或openID,请先登陆" delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
        [alert show];
        return;
    }
    MAFShareTool *shareTool = [MAFShareTool sharedInstance];
    [shareTool wechatGetInfoWithAccessToken:self.accessToken withOpenid:self.openID withGetInfoBlock:^(BOOL isSuccess, NSDictionary *info, NSString *errmsg) {
        if (isSuccess) {
            NSMutableString *str = [NSMutableString stringWithFormat:@""];
            for (id key in info) {
                [str appendString: [NSString stringWithFormat:
                                    @"%@:%@\n", key, [info objectForKey:key]]];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message: [NSString stringWithFormat:@"%@",str] delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
            [alert show];
        }
    }];
}
- (void)shareText {
    MAFShareTool *shareTool = [MAFShareTool sharedInstance];
    [shareTool shareWXTextWithText:@"分享试试" withType:0];
}
- (void)shareImage {
    UIImage *thumbImg = [UIImage imageNamed:@"news.jpg"];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"news" ofType:@"jpg"];
    NSData *imgData = [NSData dataWithContentsOfFile:filePath];
    MAFShareTool *shareTool = [MAFShareTool sharedInstance];
    [shareTool shareWXImageWithThumbImg:thumbImg withImageData:imgData withType:0];
}
- (void)shareTextQ {
    MAFShareTool *shareTool = [MAFShareTool sharedInstance];
    [shareTool shareWXTextWithText:@"分享试试" withType:1];
}
- (void)shareImageQ {
    UIImage *thumbImg = [UIImage imageNamed:@"news.jpg"];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"news" ofType:@"jpg"];
    NSData *imgData = [NSData dataWithContentsOfFile:filePath];
    MAFShareTool *shareTool = [MAFShareTool sharedInstance];
    [shareTool shareWXImageWithThumbImg:thumbImg withImageData:imgData withType:1];
}
- (void)shareWeb {
    UIImage *thumbImg = [UIImage imageNamed:@"news.jpg"];
    MAFShareTool *shareTool = [MAFShareTool sharedInstance];
    [shareTool shareWXWebWithTitle:@"标题" withDescription:@"描述" withThumberImg:thumbImg withUrl:@"http://sports.qq.com/a/20120510/000650.htm" withType:0];
}
- (void)shareWebQ {
    UIImage *thumbImg = [UIImage imageNamed:@"news.jpg"];
    MAFShareTool *shareTool = [MAFShareTool sharedInstance];
    [shareTool shareWXWebWithTitle:@"标题" withDescription:@"描述" withThumberImg:thumbImg withUrl:@"http://sports.qq.com/a/20120510/000650.htm" withType:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
