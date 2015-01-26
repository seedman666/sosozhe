//
//  WebViewController.m
//  sosozhe
//
//  Created by seed on 14-12-6.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import "WebViewController.h"
#import "MBProgressHUD.h"
#import "LoginUtil.h"
#import "LoginUtil.h"
#import "ILBarButtonItem.h"
#import "PassValueUtil.h"

@interface WebViewController ()<MBProgressHUDDelegate>

@property MBProgressHUD *HUD;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:@"webviewParamNotification" object:nil];
    self.webView.delegate=self;
    
    /* Left bar button item */
    ILBarButtonItem *backBtn =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"back1.png"]
                        selectedImage:[UIImage imageNamed:@"back1.png"]
                               target:self
                               action:@selector(backTapped:)];
    
    self.titleBar.leftBarButtonItem = backBtn;
    
    /* Right bar button item */
    ILBarButtonItem *closeBtn =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"gear"]
                        selectedImage:[UIImage imageNamed:@"gearSelected.png"]
                               target:self
                               action:@selector(CloseTapped:)];
    self.titleBar.rightBarButtonItem=closeBtn;
}

- (IBAction)backTapped:(id)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

-(IBAction)CloseTapped:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) notificationHandler:(NSNotification *) notification{
    
    NSString *urlStr = [notification object];
    NSString *urlStrWithUid=urlStr;
    if ([LoginUtil isLogin]) {
        if ([urlStr rangeOfString:@"uid="].location != NSNotFound) {
            urlStrWithUid =[NSString stringWithFormat:@"%@%@", urlStr, [LoginUtil getUid]];
        }else{
            urlStrWithUid =[NSString stringWithFormat:@"%@&uid=%@", urlStr, [LoginUtil getUid]];
        }
        
    }
    NSLog(@"URL:%@", urlStrWithUid);
    NSURL *url=[[NSURL alloc] initWithString:urlStrWithUid];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //NSString *url=[request.URL absoluteString];

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
    self.HUD.dimBackground = NO;
    [self.HUD show:YES];
    [self.HUD hide:YES afterDelay:1];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
    
    NSString *url=[webView.request.URL absoluteString];
    
//    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://www.sosozhe.com"]];
    
    
//     NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    if ([PassValueUtil getWebViewTitle]) {
            self.titleBar.title=[NSString stringWithFormat:@"%@最高返利(%@)", [PassValueUtil getWebViewTitle], [PassValueUtil getWebViewTitle2]];
    }

    if ([url isEqualToString:@"http://www.sosozhe.com/index.php?mod=api&act=do"]) {
        [LoginUtil setLogin:YES];
        [LoginUtil checkLoginAsyn];
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
