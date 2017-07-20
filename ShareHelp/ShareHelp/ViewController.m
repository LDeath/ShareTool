//
//  ViewController.m
//  ShareHelp
//
//  Created by 高赛 on 2017/7/13.
//  Copyright © 2017年 高赛. All rights reserved.
//

#import "ViewController.h"
#import "MAFShareTool.h"
#import "QQShareVC.h"
#import "WechatShareVC.h"
#import "WeiboShareVC.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;
@property (weak, nonatomic) IBOutlet UIButton *wbBtn;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
- (IBAction)clickQQShare:(id)sender {
    
    QQShareVC *qqShareVC = [[QQShareVC alloc] init];
    [self.navigationController pushViewController:qqShareVC animated:YES];
    
}
- (IBAction)clickWechatShare:(id)sender {
    WechatShareVC *wechatShareVC = [[WechatShareVC alloc] init];
    [self.navigationController pushViewController:wechatShareVC animated:YES];
}
- (IBAction)clickSinaShare:(id)sender {
    WeiboShareVC *weiboShareVC = [[WeiboShareVC alloc] init];
    [self.navigationController pushViewController:weiboShareVC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
