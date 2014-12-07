//
//  WebViewController.m
//  sosozhe
//
//  Created by seed on 14-12-6.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import "WebViewController.h"
#import "MBProgressHUD.h"

@interface WebViewController ()<MBProgressHUDDelegate>

@property MBProgressHUD *HUD;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:@"webviewParamNotification" object:nil];
    self.webView.delegate=self;
}

-(void) notificationHandler:(NSNotification *) notification{
    
    NSString *urlStr = [notification object];
    NSURL *url=[[NSURL alloc] initWithString:urlStr];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (IBAction)press:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url=[request.URL absoluteString];
    
    
    
    if ([url isEqualToString:@"http://www.sosozhe.com/index.php?mod=api&act=do"]) {
        
        
        
//        [self dismissModalViewControllerAnimated:YES];
        return YES;
    }
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%@", response);
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    self.HUD.delegate = self;
    self.HUD.labelText = @"正在加载数据";
    self.HUD.dimBackground = YES;
    [self.HUD show:YES];
    [self.HUD hide:YES afterDelay:1];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
    
    NSString *url=[webView.request.URL absoluteString];
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://www.sosozhe.com"]];
    NSLog(@"COOKIE：%@", cookies);
    
    if ([url isEqualToString:@"http://www.sosozhe.com/index.php?mod=api&act=do"]) {
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
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
