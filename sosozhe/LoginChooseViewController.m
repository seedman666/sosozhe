//
//  LoginChooseViewController.m
//  sosozhe
//
//  Created by seed on 14-12-2.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import "LoginChooseViewController.h"
#import "WebViewController.h"
#import "LoginUtil.h"
#import "PassValueUtil.h"

@interface LoginChooseViewController ()

@end

@implementation LoginChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.taobaoLoginButton addTarget:self action:@selector(taobaoLogin) forControlEvents:UIControlEventTouchDown];
    [self.qqLoginButton addTarget:self action:@selector(qqLogin) forControlEvents:UIControlEventTouchDown];
    [self.weiboLoginButton addTarget:self action:@selector(weiboLogin) forControlEvents:UIControlEventTouchDown];
    [self.quitButton addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchDown];
    
    [PassValueUtil setWebViewTitle:nil];
    [PassValueUtil setWebViewTitle2:nil];
    
}

-(void) taobaoLogin{
    [self performSegueWithIdentifier:@"WebViewLoginId" sender:self];
    NSString *url=@"http://www.sosozhe.com/index.php?mod=api&act=tb&type=iphone1.0";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"webviewParamNotification" object:url];
}

-(void) qqLogin{
    [self performSegueWithIdentifier:@"WebViewLoginId" sender:self];
    NSString *url=@"http://www.sosozhe.com/index.php?mod=api&act=qq&type=iphone1.0";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"webviewParamNotification" object:url];
}

-(void) weiboLogin{
    [self performSegueWithIdentifier:@"WebViewLoginId" sender:self];
    NSString *url=@"http://www.sosozhe.com/index.php?mod=api&act=sina&type=iphone1.0";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"webviewParamNotification" object:url];
}

-(void) quit{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) viewDidAppear:(BOOL)animated{
    if ([LoginUtil isLogin]) {
        [self dismissModalViewControllerAnimated:NO];
    }
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
