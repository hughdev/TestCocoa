//
//  SecondViewController.m
//  TestCocoa
//
//  Created by jiang on 16/3/15.
//  Copyright © 2016年 科比. All rights reserved.
//

#import "SecondViewController.h"
#import "TWOViewController.h"

#import "UINavigationController+FDFullscreenPopGesture.h"
#import "QupaiViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%.4f",3.1415926);
    
//    UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
//    
//    [self.view addSubview:webview];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//
//    NSURL *url = [NSURL URLWithString:@"https://ooch.com.cn"];
//    NSURLRequest *req = [NSURLRequest requestWithURL:url];
//    [webview loadRequest:req];
    //    TWOViewController *recordController = [[TWOViewController alloc]init];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    button1.frame = CGRectMake(100, 220, 100, 100);
    [button1 addTarget:self action:@selector(qupai) forControlEvents:UIControlEventTouchUpInside];
    button1.backgroundColor = [UIColor greenColor];
    [self.view addSubview:button1];
    
}

- (void)qupai{
    TWOViewController *recordController = [[TWOViewController alloc]init];
    QupaiViewController *navigation = [[QupaiViewController alloc] initWithRootViewController:recordController];
    [navigation setNavigationBarHidden:YES animated:YES];
//    recordController.fd_prefersNavigationBarHidden = YES;
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setBool:YES forKey:@"fd_bool"];
//    [defaults synchronize];
//    recordController.fd_Hidden = YES;
    [self presentViewController:navigation animated:YES completion:^{
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
