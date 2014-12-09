//
//  MsgDetailViewController.m
//  sosozhe
//
//  Created by seed on 14-12-9.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import "MsgDetailViewController.h"
#import "PassValueUtil.h"
#import <AFNetworking.h>
#import "MD5Util.h"
#import "Constant.h"

@interface MsgDetailViewController ()

@end

@implementation MsgDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.detailLabel.numberOfLines=0;
    self.detailLabel.text=[NSString stringWithFormat:@"    %@(%@)", [PassValueUtil msgContent], [PassValueUtil msgAddTime]];
    [self.detailLabel sizeToFit];
    
    [self setMsgReaded];
}

-(void) setMsgReaded{
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970];
    NSString *timestamp=[NSString stringWithFormat:@"%lld", recordTime];
    NSString *token=[MD5Util md5:[NSString stringWithFormat:@"%@%s", timestamp, SECURE_KEY ] ];
    
    
    NSURL *url = [NSURL URLWithString:@"http://m.sosozhe.com/"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@%@%@%@%@%@", @"index.php?mod=ajax&act=read_msg",@"&id=",[PassValueUtil msgId] ,@"&timestamp=",timestamp,@"&token=",token ];
    
    [client postPath:urlStr parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"%@", responseObject);
                 
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"%@", error);
                 
             }
     ];
}


- (IBAction)back:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
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
