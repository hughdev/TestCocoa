//
//  TWOViewController.m
//  TestCocoa
//
//  Created by jiang on 16/4/26.
//  Copyright © 2016年 科比. All rights reserved.
//

#import "TWOViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "ThreeViewController.h"

@interface TWOViewController ()

@end

@implementation TWOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(100, 80, 100, 100);
    [button addTarget:self action:@selector(pushVC) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    button1.frame = CGRectMake(100, 220, 100, 100);
    [button1 addTarget:self action:@selector(qupai) forControlEvents:UIControlEventTouchUpInside];
    button1.backgroundColor = [UIColor greenColor];
    [self.view addSubview:button1];
//    self.fd_prefersNavigationBarHidden = YES;

    self.view.backgroundColor=[UIColor cyanColor];
    CGRect frame = CGRectMake(0, 144, 414, 44);
    self.navigationController.navigationBar.frame = frame;
    NSLog(@"%@", self.navigationController.navigationBar);
}

- (void)pushVC{
    ThreeViewController *vc = [ThreeViewController new];
    vc.view.backgroundColor = [UIColor grayColor];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)qupai{
    [self dismissViewControllerAnimated:YES completion:nil];
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
