//
//  ViewController.h
//  TestCocoa
//
//  Created by 科比 on 15/7/28.
//  Copyright (c) 2015年 科比. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^myBlock)(void);
@interface ViewController : UIViewController
@property (nonatomic, copy) myBlock myOBlock;

@end

