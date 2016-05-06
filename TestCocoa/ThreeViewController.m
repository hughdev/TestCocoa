//
//  ThreeViewController.m
//  TestCocoa
//
//  Created by jiang on 16/4/26.
//  Copyright © 2016年 科比. All rights reserved.
//

#import "ThreeViewController.h"
#import "TWOViewController.h"

@interface ThreeViewController ()

@end

@implementation ThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    button1.frame = CGRectMake(100, 220, 100, 100);
    [button1 addTarget:self action:@selector(qupai) forControlEvents:UIControlEventTouchUpInside];
    button1.backgroundColor = [UIColor greenColor];
    [self.view addSubview:button1];
    
    self.view.backgroundColor=[UIColor blueColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)qupai{
    TWOViewController *vc = [TWOViewController new];
//    vc.view.backgroundColor = [UIColor cyanColor];
    [self.navigationController pushViewController:vc animated:YES];
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
