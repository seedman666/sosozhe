//
//  CommonUtil.m
//  sosozhe
//
//  Created by seed on 14-12-7.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import "CommonUtil.h"
#import "MBProgressHUD.h"
#import "MD5Util.h"
#import <AFNetworking.h>
#import "Constant.h"

@implementation CommonUtil

+(void) checkIn:(UIView *) view{
    
    
    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    HUD.labelText = @"正在加载数据";
    HUD.dimBackground = YES;
    [HUD show:YES];
    
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970];
    NSString *timestamp=[NSString stringWithFormat:@"%lld", recordTime];
    NSString *token=[MD5Util md5:[NSString stringWithFormat:@"%@%s", timestamp, SECURE_KEY ] ];
    NSString *urlStr=[NSString stringWithFormat:@"%@%@%@%@", @"index.php?mod=ajax&act=sign&timestamp=",timestamp,@"&token=",token ];
    NSLog(@"%@", urlStr);
    NSURL *url = [NSURL URLWithString:@"http://m.sosozhe.com/"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    [client postPath:urlStr parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [HUD removeFromSuperview];
                 NSString* status = [responseObject objectForKey:@"status"];
                 if ([status intValue]==112) {
                     MBProgressHUD* HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
                     HUD.labelText = @"您已经签过到了";
                     HUD.mode = MBProgressHUDModeText;
                     HUD.dimBackground = YES;
                     [HUD show:YES];
                     [HUD hide:YES afterDelay:2];
                 }
                 
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [HUD removeFromSuperview];
                 NSLog(@"%@", error);
                 
             }
     ];
}

+(void) inviteFriend:(UIViewController *) viewController{
    [viewController performSegueWithIdentifier:@"WebViewLoginId" sender:viewController];
    NSString *url=@"http://m.sosozhe.com/yaoqing.html?type=iphone1.0";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"webviewParamNotification" object:url];
}

@end
