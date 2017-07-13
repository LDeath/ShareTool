//
//  QQShareVC.m
//  ShareHelp
//
//  Created by 高赛 on 2017/7/13.
//  Copyright © 2017年 高赛. All rights reserved.
//

#import "QQShareVC.h"
#import "MAFShareTool.h"

@interface QQShareVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation QQShareVC

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"qq登录",@"qq文字消息",@"qq图片消息",@"qq网络链接分享",@"qq空间文字分享",@"qq空间链接分享", nil];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"qqShare"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"qqShare"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self qqLogin];
    } else if (indexPath.row == 1) {
        [self shareTextMessage];
    } else if (indexPath.row == 2) {
        [self shareImageMessage];
    } else if (indexPath.row == 3) {
        [self shareNetMessage];
    } else if (indexPath.row == 4) {
        [self shareZoneTextMesage];
    } else if (indexPath.row == 5) {
        [self shareZoneNetMessage];
    }
}

- (void)qqLogin {
    MAFShareTool *shareTool = [MAFShareTool sharedInstance];
    [shareTool qqLoginWithLoginBlock:^(int status, NSString *accessToken, NSString *openID) {
        if (status == 0) {
            [shareTool qqGetInfoWithBlock:^(int status, NSDictionary *info, NSString *erroMsg) {
                if (status == 0) {
                    
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
    }];
}
- (void)shareTextMessage {
    MAFShareTool *shareTool = [MAFShareTool sharedInstance];
    NSString *text = @"马化腾指出，过去两年移动互联网有很多开放平台非常成功。事实上到现在来看，发展到现在一年多，最关键的开放平台是能不能真正从用户和经济回报中打造生态链。";
    [shareTool shareQQTextMessageWithText:text];
}
- (void)shareImageMessage {
    
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"news.jpg"];
    NSData *imgData = [NSData dataWithContentsOfFile:path];
    MAFShareTool *shareTool = [MAFShareTool sharedInstance];
    [shareTool shareQQImageMessageWithImageData:imgData];
}
- (void)shareNetMessage {
    NSURL *previewURL = [NSURL URLWithString:@"http://img1.gtimg.com/sports/pics/hv1/87/16/1037/67435092.jpg"];
    NSURL* url = [NSURL URLWithString:@"http://sports.qq.com/a/20120510/000650.htm"];
    MAFShareTool *shareTool = [MAFShareTool sharedInstance];
    [shareTool shareQQNetMessageWithUrl:url andTitle:@"标题" andDescription:@"描述" andPreviewImageUrl:previewURL];
}
- (void)shareZoneTextMesage {
    MAFShareTool *shareTool = [MAFShareTool sharedInstance];
    [shareTool shareQZoneTextMessageWithText:@"马化腾指出，过去两年移动互联网有很多开放平台非常成功。事实上到现在来看，发展到现在一年多，最关键的开放平台是能不能真正从用户和经济回报中打造生态链。"];
}
- (void)shareZoneNetMessage {
    MAFShareTool *shareTool = [MAFShareTool sharedInstance];
    NSURL *previewURL = [NSURL URLWithString:@"http://img1.gtimg.com/sports/pics/hv1/87/16/1037/67435092.jpg"];
    NSURL* url = [NSURL URLWithString:@"http://sports.qq.com/a/20120510/000650.htm"];
    [shareTool shareQZoneNetMessageWithUrl:url andTitle:@"标题" andDescription:@"描述" andPreviewImageUrl:previewURL];
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
