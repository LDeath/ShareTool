//
//  WeiboShareVC.m
//  ShareHelp
//
//  Created by 高赛 on 2017/7/14.
//  Copyright © 2017年 高赛. All rights reserved.
//

#import "WeiboShareVC.h"
#import "MAFShareTool.h"

@interface WeiboShareVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *accessToken;

@end

@implementation WeiboShareVC

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithObjects:@"微博授权认证",@"微博分享文字信息",@"分享图片信息",@"微博分享图片和文字信息",@"分享链接", nil];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"微博分享与登陆";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weiboCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"weiboCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self auth];
    } else if (indexPath.row == 1) {
        [self shareText];
    } else if (indexPath.row == 2) {
        [self shareImage];
    } else if (indexPath.row == 3) {
        [self shareTextAndImg];
    } else if (indexPath.row == 4) {
        [self shareUrl];
    }
}
- (void)auth {
    MAFShareTool *shareTool = [MAFShareTool sharedInstance];
    //http://www.oushidai.com
    [shareTool weiboGetAuthWithRedirectUrl:@"http://www.oushidai.com" withRequestUserInfo:@{} withAuthBlock:^(BOOL isSuccess, NSDictionary *userInfo, NSDictionary *requestUserInfo) {
        if (isSuccess) {
            NSString *str = [NSString stringWithFormat:@"access_token:%@\n logo:%@\n name:%@\n uid:%@",userInfo[@"access_token"],userInfo[@"app"][@"logo"],userInfo[@"app"][@"name"],userInfo[@"uid"]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:str delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
            [alert show];
            self.accessToken = userInfo[@"access_token"];
        }
    }];
}
- (void)shareText {
    MAFShareTool *shareTool = [MAFShareTool sharedInstance];
    [shareTool shareWeiboText:@"分享分享分享" withImageData:nil withRedirectURL:@"http://www.oushidai.com" withAccessToken:self.accessToken withRequestUserInfo:@{} withShareBlock:^(BOOL isSuccess, NSDictionary *requestUserInfo) {
    }];
     
}
- (void)shareImage {
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"news.jpg"];
    NSData *imgData = [NSData dataWithContentsOfFile:path];
    MAFShareTool *shareTool = [MAFShareTool sharedInstance];
    [shareTool shareWeiboText:@"" withImageData:imgData withRedirectURL:@"http://www.oushidai.com" withAccessToken:self.accessToken withRequestUserInfo:@{} withShareBlock:^(BOOL isSuccess, NSDictionary *requestUserInfo) {
    }];
}
- (void)shareTextAndImg {
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"news.jpg"];
    NSData *imgData = [NSData dataWithContentsOfFile:path];
    MAFShareTool *shareTool = [MAFShareTool sharedInstance];
    [shareTool shareWeiboText:@"分享分享分享" withImageData:imgData withRedirectURL:@"http://www.oushidai.com" withAccessToken:self.accessToken withRequestUserInfo:@{} withShareBlock:^(BOOL isSuccess, NSDictionary *requestUserInfo) {
    }];
}
- (void)shareUrl {
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"image_2.jpg"];
    NSData *imgData = [NSData dataWithContentsOfFile:path];
    MAFShareTool *shareTool = [MAFShareTool sharedInstance];
    [shareTool shareWeiboURLTitle:@"这是标题标题" withDescription:@"这是描述描述" withThumbImgData:imgData withUrl:@"http://sports.qq.com/a/20120510/000650.htm" withRedirectURL:@"http://www.oushidai.com" withAccessToken:self.accessToken withRequestUserInfo:@{} withShareBlock:^(BOOL isSuccess, NSDictionary *requestUserInfo) {
        
    }];
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
