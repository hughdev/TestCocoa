//
//  BaseViewController.m
//  TestCocoa
//
//  Created by jiang on 16/4/25.
//  Copyright © 2016年 科比. All rights reserved.
//

#import "BaseViewController.h"
#import "UIImage+Category.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

+ (void)initialize {
    
    // 导航栏背景
    UINavigationBar *navBar = [UINavigationBar appearance];
    UIImage *image = [UIImage imageWithColor:[UIColor orangeColor]]; // colorFromHexRGB:@"f24e02"
    [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
    navBar.backgroundColor = [UIColor clearColor];
    [navBar setTintColor:[UIColor whiteColor]];
    
    // 标题字体
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [navBar setTitleTextAttributes:attrs];
    
    // UIBarButtonItem字体
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
    itemAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    itemAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
    
    // 状态栏样式
    //    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // jpush 消息队列
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessageLogOut:) name:@"JpushDidReceiveMessageLogOutNotification" object:nil];
    
}

- (void)networkDidReceiveMessageLogOut:(NSNotification *)notification {
    [self popToRootViewControllerAnimated:YES];
    
}

- (void)dealloc {
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
    
    //    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    //        self.interactivePopGestureRecognizer.delegate = nil;
    //    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    [self.view endEditing:YES];
    return [super popViewControllerAnimated:animated];
}
@end
