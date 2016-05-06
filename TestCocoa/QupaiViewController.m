//
//  QupaiViewController.m
//  TestCocoa
//
//  Created by jiang on 16/4/27.
//  Copyright © 2016年 科比. All rights reserved.
//

#import "QupaiViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface QupaiViewController ()

@end

@implementation QupaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fd_prefersNavigationBarHidden = YES;

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
