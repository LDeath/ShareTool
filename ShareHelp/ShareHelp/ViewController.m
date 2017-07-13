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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}
- (IBAction)clickQQShare:(id)sender {
    
    QQShareVC *qqShareVC = [[QQShareVC alloc] init];
    [self presentViewController:qqShareVC animated:YES completion:nil];
    
}
- (IBAction)clickWechatShare:(id)sender {
}
- (IBAction)clickSinaShare:(id)sender {
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
