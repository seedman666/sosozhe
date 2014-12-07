//
//  LoginUtil.m
//  sosozhe
//
//  Created by seed on 14-12-7.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import "LoginUtil.h"
#import "MD5Util.h"
#import <AFNetworking.h>
#import "MBProgressHUD.h"
#import "Constant.h"

@implementation LoginUtil

static BOOL isLogin;

+(BOOL) isLogin{
    return isLogin;
}

+(void) setLogin :(BOOL) islog{
    isLogin=islog;
}

+(void) checkLoginAsyn{
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970];
    NSString *timestamp=[NSString stringWithFormat:@"%lld", recordTime];
    NSString *token=[MD5Util md5:[NSString stringWithFormat:@"%@%s", timestamp, SECURE_KEY ] ];
    NSString *urlStr=[NSString stringWithFormat:@"%@%@%@%@", @"index.php?mod=ajax&act=userinfo&timestamp=",timestamp,@"&token=",token ];
    NSLog(@"%@", urlStr);
    
    NSURL *url = [NSURL URLWithString:@"http://m.sosozhe.com/"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    [client postPath:urlStr parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"%@", responseObject);
                 NSString* status = [responseObject objectForKey:@"status"];
                 
                 if ([status intValue]==101) {
                     isLogin=false;
                 }else{
                     isLogin=true;
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"%@", error);
                 
             }
     ];
}

@end
