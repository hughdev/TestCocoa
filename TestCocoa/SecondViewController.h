//
//  SecondViewController.h
//  TestCocoa
//
//  Created by jiang on 16/3/15.
//  Copyright © 2016年 科比. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^block) (void);
typedef NSArray*(^bg)(void);
@interface SecondViewController : UIViewController

//+(void)secondGetBlock:(void(^)(BOOL hehe))myBlock second:(NSString* (^)(void))secondBlock;

@end
