//
//  ViewController.m
//  TestCocoa
//
//  Created by 科比 on 15/7/28.
//  Copyright (c) 2015年 科比. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "Masonry.h"
#import <objc/runtime.h>
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"
//#import <CommonCrypto/CommonDigest.h>
#import "FileHash.h"

#import <ALBBSDK/ALBBSDK.h>
#import <ALBBQuPai/ALBBQuPaiService.h>
#import <ALBBQuPai/QPEffectMusic.h>

#import "SecondViewController.h"

#import "TWOViewController.h"

#import "UINavigationController+FDFullscreenPopGesture.h"


@interface ViewController ()
{
//    AFHTTPSessionManager *manager;
    BOOL _down;

}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(100, 100, 100, 100);
    [button addTarget:self action:@selector(postFile) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:button];
    
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    button1.frame = CGRectMake(100, 220, 100, 100);
    [button1 addTarget:self action:@selector(qupai) forControlEvents:UIControlEventTouchUpInside];
    button1.backgroundColor = [UIColor greenColor];
    [self.view addSubview:button1];
//    [self test];
//    mainOme();
//    
    
    
}

- (void)qupai{
    
    id<ALBBQuPaiService> sdk = [[ALBBSDK sharedInstance] getService:@protocol(ALBBQuPaiService)];
    [sdk setDelegte:(id<QupaiSDKDelegate>)self];
    
    /* 可选设置 */
    [sdk setEnableImport:YES];
    [sdk setEnableMoreMusic:NO];
    [sdk setEnableBeauty:YES];
    [sdk setEnableVideoEffect:YES];
    [sdk setEnableWatermark:YES];
    //    [sdk setTintColor:[UIColor colorWithRed:_colorR.value/255.0 green:_colorG.value/255.0 blue:_colorB.value/255.0 alpha:1]];
    //    [sdk setThumbnailCompressionQuality:[_qualityThumbnail.text floatValue]];
    BOOL open = NO;
    [sdk setWatermarkImage:open ? [UIImage imageNamed:@"watermask"] : nil];
    [sdk setWatermarkPosition:QupaiSDKWatermarkPositionTopRight];
    [sdk setCameraPosition:open ? QupaiSDKCameraPositionFront : QupaiSDKCameraPositionBack];
    
    /* 基本设置 */
    UIViewController *recordController = [sdk createRecordViewControllerWithMinDuration:2 maxDuration:90 bitRate:450000];
    
    
    
//    TWOViewController *recordController = [[TWOViewController alloc]init];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:recordController];
//    recordController.fd_prefersNavigationBarHidden = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"fd_bool"];
    [defaults synchronize];
    recordController.fd_Hidden = YES;
    [self presentViewController:navigation animated:YES completion:^{
        [navigation setNavigationBarHidden:YES animated:YES];
//        navigation.fd_prefersNavigationBarHidden = YES;

    }];
}

- (void)qupaiSDK:(id<ALBBQuPaiService>)sdk compeleteVideoPath:(NSString *)videoPath thumbnailPath:(NSString *)thumbnailPath
{
    NSLog(@"Qupai SDK compelete %@",videoPath);
    [self dismissViewControllerAnimated:YES completion:nil];
    if (videoPath) {
        UISaveVideoAtPathToSavedPhotosAlbum(videoPath, nil, nil, nil);
    }
    if (thumbnailPath) {
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithContentsOfFile:thumbnailPath], nil, nil, nil);
    }
}

- (NSArray *)qupaiSDKMusics:(id<ALBBQuPaiService>)sdk
{
    NSString *baseDir = [[NSBundle mainBundle] bundlePath];
    NSString *configPath = [[NSBundle mainBundle] pathForResource:_down ? @"music2" : @"music1" ofType:@"json"];
    NSData *configData = [NSData dataWithContentsOfFile:configPath];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:configData options:NSJSONReadingAllowFragments error:nil];
    NSArray *items = dic[@"music"];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *item in items) {
        NSString *path = [baseDir stringByAppendingPathComponent:item[@"resourceUrl"]];
        QPEffectMusic *effect = [[QPEffectMusic alloc] init];
        effect.name = item[@"name"];
        effect.eid = [item[@"id"] intValue];
        effect.musicName = [path stringByAppendingPathComponent:@"one_audio.mp3"];
        effect.icon = [path stringByAppendingPathComponent:@"one_icon.png"];
        [array addObject:effect];
    }
    return array;
}


- (void)getPlist{
    NSString *myRequestUrl = @"https://stage.ooch.com.cn/ooch/api/popstar/list?page=1&app_version=2.0&app_client=iPhone_OS&device_id=7AF8BCBC_7A33_4950_9CB9_0862927DB1C6";
    
//    NSString *myRequestUrl = @"https://stage.ooch.com.cn/ooch/api/popstar/list";

//    NSString *myRequestUrl = @"https://api.app.net/stream/0/posts/stream/global";

//    NSDictionary *param = @{@"page":@"1",@"app_version":@"2.0",@"app_client":@"iPhone_OS",@"device_id":@"7AF8BCBC_7A33_4950_9CB9_0862927DB1C6"};
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",nil];
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];

//    [manager setSecurityPolicy:[self customSecurityPolicy]];
    
//    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
//    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:myRequestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject %@",responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error===%@--- %@",error,error.localizedDescription);
        /**
         *  error===Error Domain=NSURLErrorDomain Code=-999 "cancelled" UserInfo={NSErrorFailingURLKey=https://stage.ooch.com.cn/ooch/api/popstar/list?page=1&app_version=2.0&app_client=iPhone_OS&device_id=7AF8BCBC_7A33_4950_9CB9_0862927DB1C6, NSLocalizedDescription=cancelled, NSErrorFailingURLStringKey=https://stage.ooch.com.cn/ooch/api/popstar/list?page=1&app_version=2.0&app_client=iPhone_OS&device_id=7AF8BCBC_7A33_4950_9CB9_0862927DB1C6}--- cancelled
         */
        
        
    }];
}

- (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = [NSSet setWithArray:@[certData]];
    
    return securityPolicy;
}


- (void)postFile{
    NSString *myRequestUrl = @"http://192.168.0.219:8080/ooch/api/popstar/short_video";
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *strName = @"he.zip";
//    NSString *executablePath = [[NSBundle mainBundle] executablePath];
    NSString *plistPath = [bundle pathForResource:strName ofType:nil];
    NSString *executableFileMD5Hash = [FileHash md5HashOfFileAtPath:plistPath];
    NSLog(@"executableFileMD5Hash : %@",executableFileMD5Hash);
    //    NSURL *myVideoUrl = [NSURL fileURLWithPath:plistPath];
    NSData *myVideoData = [NSData dataWithContentsOfFile:plistPath];
    NSDictionary *param = @{@"file_name":strName,@"md5hash":executableFileMD5Hash};
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;

    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",nil];
    [manager POST:myRequestUrl parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData :myVideoData name : @"file" fileName :strName mimeType : @"image/jpg/file" ];

    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        NSLog(@"%.2f", comF);
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat comF = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
            hud.labelText = [NSString stringWithFormat:@"已完成 %.2f", comF];
            hud.progress = comF;
        });
        

//        [self doSomethingInBackgroundWithProgressCallback:^(float progress) {
//            hud.progress = progress;
//        } completionCallback:^{
//            [hud hide:YES];
//        }];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject %@",responseObject);
        [hud hide:YES];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error--- %@",error.localizedDescription);
        [hud hide:YES];

    }];


    
    
//    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        [SVProgressHUD showProgress:(CGFloat)totalBytesWritten/(CGFloat)totalBytesExpectedToWrite status:[NSString stringWithFormat:@"已完成%d%%",(int)((CGFloat)totalBytesWritten/(CGFloat)totalBytesExpectedToWrite*100)] maskType:SVProgressHUDMaskTypeBlack];
//    }];
}
/**
 + (void) Taskupload:(NSDictionary *) param ImgArray:(NSArray *)imgArray VoiceArray:(NSArray *)voiceArray CallBack:(void(^)(NSDictionary *data, NSError *error)) block {
 [SVProgressHUD showProgress:0 status:@"开始提交" maskType:SVProgressHUDMaskTypeBlack];
 NSString *path =@"V7/comp/work/progress.do?addtask";
 AFHTTPRequestOperation * operation = [[AFAppDotNetAPIClient sharedClient] POST:path parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
 for(int i=0;i<imgArray.count;i++){
 if ([[[imgArray objectAtIndex:i] valueForKey:@"old"] isEqualToString:@"0"]) {
 NSData * imageData = [NSData dataWithContentsOfFile:[[imgArray objectAtIndex:i] valueForKey:@"path"]];
 NSString * paramName = [NSString stringWithFormat:@"plan_img_%ld",(long int)i+1];
 NSArray *fileNameArray = [[[imgArray objectAtIndex:i] valueForKey:@"path"] componentsSeparatedByString:@"/"];
 NSString *fileName = fileNameArray[[fileNameArray count]-1];
 [formData appendPartWithFileData:imageData name:paramName fileName:fileName mimeType:@"image/*"];
 }
 
 }
 for(int i=0;i<voiceArray.count;i++){
 if ([[[voiceArray objectAtIndex:i] valueForKey:@"old"] isEqualToString:@"0"]) {
 NSData * voiceData = [NSData dataWithContentsOfFile:[[voiceArray objectAtIndex:i] valueForKey:@"path"]];
 NSArray *fileNameArray = [[[voiceArray objectAtIndex:i] valueForKey:@"path"] componentsSeparatedByString:@"/"];
 NSString *fileName = fileNameArray[[fileNameArray count]-1];
 NSString * paramName = [NSString stringWithFormat:@"plan_voice_%ld",(long int)i+1];
 [formData appendPartWithFileData:voiceData name:paramName fileName:fileName mimeType:@"audio/*"];
 }
 
 }
 } success:^(AFHTTPRequestOperation *operation, id responseObject) {
 
 if (block) {
 block(responseObject, nil);
 }
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 [SVProgressHUD showErrorWithStatus:@"网络异常"];
 if (block) {
 block(nil, error);
 }
 
 }];
 [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
 [SVProgressHUD showProgress:(CGFloat)totalBytesWritten/(CGFloat)totalBytesExpectedToWrite status:[NSString stringWithFormat:@"已完成%d%%",(int)((CGFloat)totalBytesWritten/(CGFloat)totalBytesExpectedToWrite*100)] maskType:SVProgressHUDMaskTypeBlack];
 }];
 }
 */






#pragma mark - AFNetworking上传文件
- (void)didClickUploadButtonAction{
    
//    NSString *fileName = @"337576";
//    //  确定需要上传的文件(假设选择本地的文件)
//    NSURL *filePath = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"jpg"];
//    NSDictionary *parameters = @{@"file_name":@"337576.jpg"};
//    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
//    [requestManager POST:@"http://192.168.0.219:8080/ooch/api/popstar/short_video" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//        /**
//         *  appendPartWithFileURL   //  指定上传的文件
//         *  name                    //  指定在服务器中获取对应文件或文本时的key
//         *  fileName                //  指定上传文件的原始文件名
//         *  mimeType                //  指定商家文件的MIME类型
//         */
//        [formData appendPartWithFileURL:filePath name:@"file" fileName:[NSString stringWithFormat:@"%@.jpg",fileName] mimeType:@"image/png/jpg" error:nil];
//        
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSLog(@"获取服务器响应出错");
//        
//    }];
    
}


/**
 NSString *myRequestUrl = @"http......";
 NSURL *myVideoUrl = [NSURL fileURLWithPath:myVideoStr];
 NSData *myVideoData = [NSData dataWithContentsOfURL:myVideoUrl];
 
 AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
 [manager POST:myRequestUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
 [formData appendPartWithFileData:myVideoData name:@"video" fileName:@"video.mp4" mimeType:@"video/mp4"];
 } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
 NSLog(@"success");
 } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
 NSLog(@"failure");
 }];
 
 
 或者直接：
 
 [formData appendPartWithFileURL: [NSURL fileURLWithPath:myVideoStr] name:@"video" error:nil];
 */

//- (void)uploadFileWithMediaData:(NSMutableArray *)mediaDatas
//                            url:(NSString *)url
//                         params:(id)params
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",
//                                                         @"text/plain",
//                                                         @"application/json",nil];
//
//    
//    AFHTTPRequestOperation *operation = [manager POST:url
//                                           parameters:nil
//                            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//                                
//    if (mediaDatas.count > 0) {
//    NSObject *firstObj = [mediaDatas objectAtIndexSafe:0];
//    if([firstObj isKindOfClass:[ALAsset class]]){
//        
//        // 视频
//        AVAsset *asset = [mediaDatas objectAtIndexSafe:0];
//        if (asset != nil) {
//            NSArray *documentPaths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            NSString *docuPath = [documentPaths objectAtIndex:0];
//            
//            NSString *videoPath= [docuPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.mov", 0]];    // 这里直接强制写一个即可，之前计划是用i++来区分不明视频
//            NSURL *url = [NSURL fileURLWithPath:videoPath];
//            NSError *theErro = nil;
//            BOOL exportResult = [asset exportDataToURL:url error:&theErro];
//            NSLog(@"exportResult=%@", exportResult?@"YES":@"NO");
//            
//            NSData *videoData = [NSData dataWithContentsOfURL:url];
//            [formData appendPartWithFileData:videoData name:@"file" fileName:@"video1.mov" mimeType:@"video/quicktime"];
//        }
//        
//            }
//        }
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //成功后回调
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //失败后回调
//    }];
//    
//    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        //进度
//        self.progressBlock(totalBytesWritten*1.0/totalBytesExpectedToWrite);
//    }];
//}


//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (void)test{
//    u_int count;
//    Ivar *ivarlist = class_copyIvarList([UIView class], &count);
//    for (int i = 0; i<count; i++) {
//        const char *ivarName = ivar_getName(ivarlist[i]);
//        NSString *str = [NSString stringWithCString:ivarName encoding:NSUTF8StringEncoding];
//        NSLog(@"%@ \n %s",str, __FUNCTION__);
//    }
//    
//    
//}
//
//- (void)test1{
//    dispatch_queue_t queue = dispatch_queue_create("testgcd", DISPATCH_QUEUE_SERIAL);
//    dispatch_async(queue, ^{
//        [NSThread sleepForTimeInterval:5];
//        NSLog(@" After 5 seconds");
//    });
//    dispatch_async(queue, ^{
//        [NSThread sleepForTimeInterval:5];
//        NSLog(@" After 5 again");
//    });
//    
//    NSLog(@" sleep 1 second ");
//    [NSThread sleepForTimeInterval:1];
//    NSLog(@" suspend ");
//    dispatch_suspend(queue);
//    NSLog(@" sleep 10 second ");
//    [NSThread sleepForTimeInterval:10];
//
//    NSLog(@" resume ");
//    dispatch_resume(queue);
//    /*
//     2016-03-15 10:07:37.931 TestCocoa[998:16175]  sleep 1 second
//     2016-03-15 10:07:38.937 TestCocoa[998:16175]  suspend
//     2016-03-15 10:07:38.937 TestCocoa[998:16175]  sleep 10 second
//     2016-03-15 10:07:42.936 TestCocoa[998:16288]  After 5 seconds
//     2016-03-15 10:07:48.940 TestCocoa[998:16175]  resume
//     2016-03-15 10:07:53.946 TestCocoa[998:16288]  After 5 again
//     */
//    
//    /*
//     2016-03-15 11:06:11.158 TestCocoa[1207:44259]  sleep 1 second
//     2016-03-15 11:06:12.159 TestCocoa[1207:44259]  suspend
//     2016-03-15 11:06:12.160 TestCocoa[1207:44259]  sleep 10 second
//     2016-03-15 11:06:16.161 TestCocoa[1207:44301]  After 5 seconds
//     2016-03-15 11:06:16.161 TestCocoa[1207:44298]  After 5 again
//     2016-03-15 11:06:22.166 TestCocoa[1207:44259]  resume
//     */
//    
//}
//
//void mainOme()
//{
//    int s,x;
//    int music(int x);
//    scanf("%d",&x);
//    s=music(5);
//    printf("%d\n",s);
//}
//int music(int x)
//{
//    int i=0,t;
//    while(x!=0)
//    {
//        t=x%2;
//        if(t==1)
//            i++;
//        x=x/2;
//    }
//    return i;
//}
//
//- (void)addGreenView{
//    // Do any additional setup after loading the view, typically from a nib.
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:@"http://example.com/resources.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//    
//    UIView *superview = self.view;
//    
//    UIView *view1 = [[UIView alloc] init];
//    view1.translatesAutoresizingMaskIntoConstraints = NO;
//    view1.backgroundColor = [UIColor greenColor];
//    [superview addSubview:view1];
//    
//    UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
//    
//    [superview addConstraints:@[
//                                
//                                //view1 constraints
//                                [NSLayoutConstraint constraintWithItem:view1
//                                                             attribute:NSLayoutAttributeTop
//                                                             relatedBy:NSLayoutRelationEqual
//                                                                toItem:superview
//                                                             attribute:NSLayoutAttributeTop
//                                                            multiplier:1.0
//                                                              constant:padding.top],
//                                
//                                [NSLayoutConstraint constraintWithItem:view1
//                                                             attribute:NSLayoutAttributeLeft
//                                                             relatedBy:NSLayoutRelationEqual
//                                                                toItem:superview
//                                                             attribute:NSLayoutAttributeLeft
//                                                            multiplier:1.0
//                                                              constant:padding.left],
//                                
//                                [NSLayoutConstraint constraintWithItem:view1
//                                                             attribute:NSLayoutAttributeBottom
//                                                             relatedBy:NSLayoutRelationEqual
//                                                                toItem:superview
//                                                             attribute:NSLayoutAttributeBottom
//                                                            multiplier:1.0
//                                                              constant:-padding.bottom],
//                                
//                                [NSLayoutConstraint constraintWithItem:view1
//                                                             attribute:NSLayoutAttributeRight
//                                                             relatedBy:NSLayoutRelationEqual
//                                                                toItem:superview
//                                                             attribute:NSLayoutAttributeRight
//                                                            multiplier:1
//                                                              constant:-padding.right],
//                                
//                                ]];
//}

@end
