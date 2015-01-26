//
//  MyAccountViewController.m
//  sosozhe
//
//  Created by seed on 14-4-21.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import "MyAccountViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD.h"
#import "LoginChooseViewController.h"
#import "MD5Util.h"
#import "LoginUtil.h"
#import "CommonUtil.h"
#import "Constant.h"
#import "PassValueUtil.h"

@interface MyAccountViewController ()<MBProgressHUDDelegate>

@property MBProgressHUD *HUD;

@end

@implementation MyAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    [self checkLoginStatus:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [[self myAccountBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"tab_user_2_s"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_user_1_s"]];
    
    UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkInClick:)];
    [self.qiandaoView addGestureRecognizer:tapGesture1];
    
    UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addFriend:)];
    [self.yaoqingView addGestureRecognizer:tapGesture2];
    
    UITapGestureRecognizer *tapGesture3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showShouRu:)];
    [self.shouruListView addGestureRecognizer:tapGesture3];
    
    UITapGestureRecognizer *tapGesture4=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showCheckIn:)];
    [self.qiandaoListView addGestureRecognizer:tapGesture4];

    [self.msgButton addTarget:self action:@selector(showMsg) forControlEvents:UIControlEventTouchDown];
    
    UITapGestureRecognizer *tapGesture5=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showTaoBaoOrder:)];
    [self.taobaoOrderView addGestureRecognizer:tapGesture5];

    UITapGestureRecognizer *tapGesture6=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPaiPaiOrder:)];
    [self.paipaiOrderView addGestureRecognizer:tapGesture6];

    UITapGestureRecognizer *tapGesture7=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMallOrder:)];
    [self.mallOrderView addGestureRecognizer:tapGesture7];

    
    [self checkLoginStatus:YES];
    
}

-(void) showMallOrder :(UITapGestureRecognizer *) gesture{
    if (!LoginUtil.isLogin) {
        [self performSegueWithIdentifier:@"LoginViewControllerId" sender:self];
        return;
    }
    [PassValueUtil setListType:@"mallOrder"];
    [self performSegueWithIdentifier:@"ShowListViewControllerId" sender:self];
}

-(void) showPaiPaiOrder :(UITapGestureRecognizer *) gesture{
    if (!LoginUtil.isLogin) {
        [self performSegueWithIdentifier:@"LoginViewControllerId" sender:self];
        return;
    }
    [PassValueUtil setListType:@"paipaiOrder"];
    [self performSegueWithIdentifier:@"ShowListViewControllerId" sender:self];
}

-(void) showTaoBaoOrder :(UITapGestureRecognizer *) gesture{
    if (!LoginUtil.isLogin) {
        [self performSegueWithIdentifier:@"LoginViewControllerId" sender:self];
        return;
    }
    [PassValueUtil setListType:@"taobaoOrder"];
    [self performSegueWithIdentifier:@"ShowListViewControllerId" sender:self];
}

-(void) showMsg{
    if (!LoginUtil.isLogin) {
        [self performSegueWithIdentifier:@"LoginViewControllerId" sender:self];
        return;
    }
    [PassValueUtil setListType:@"msg"];
    [self performSegueWithIdentifier:@"ShowListViewControllerId" sender:self];
}

-(void) showCheckIn:(UITapGestureRecognizer *) gesture{
    if (!LoginUtil.isLogin) {
        [self performSegueWithIdentifier:@"LoginViewControllerId" sender:self];
        return;
    }
    [PassValueUtil setListType:@"checkin"];
    [self performSegueWithIdentifier:@"ShowListViewControllerId" sender:self];
}

-(void) showShouRu:(UITapGestureRecognizer *) gesture{
    if (!LoginUtil.isLogin) {
        [self performSegueWithIdentifier:@"LoginViewControllerId" sender:self];
        return;
    }
    [PassValueUtil setListType:@"income"];
    [self performSegueWithIdentifier:@"ShowListViewControllerId" sender:self];

}

-(void) addFriend:(UITapGestureRecognizer *) gesture{
    if (!LoginUtil.isLogin) {
        [self performSegueWithIdentifier:@"LoginViewControllerId" sender:self];
        return;
    }
   
    [CommonUtil inviteFriend:self];
    
}

-(void) checkInClick:(UITapGestureRecognizer *)gesture{
    if (!LoginUtil.isLogin) {
        [self performSegueWithIdentifier:@"LoginViewControllerId" sender:self];
        return;
    }
    
    [CommonUtil checkIn:self.view];
    
}

-(void) checkLoginStatus:(BOOL) isShowDialog
{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    self.HUD.delegate = self;
    self.HUD.labelText = @"正在加载数据";
    self.HUD.dimBackground = YES;
    [self.HUD show:YES];
    [self.HUD hide:YES afterDelay:1];

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
    
//    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://sosozhe.com"]];
    
    [client postPath:urlStr parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [self.HUD removeFromSuperview];
                 NSLog(@"%@", responseObject);
                 NSString* status = [responseObject objectForKey:@"status"];
                 
                 if ([status intValue]==101) {
                     [LoginUtil setLogin:false];
                     if (isShowDialog) {
                         [self performSegueWithIdentifier:@"LoginViewControllerId" sender:self];
                     }
                     
                 }else{
                     [LoginUtil setLogin:true];
                     [self initUserInfo:responseObject];
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [self.HUD removeFromSuperview];
                 NSLog(@"%@", error);
                 
             }
     ];
}

-(void) initUserInfo : (NSDictionary *)info{
    NSDictionary *dict =[info objectForKey:@"result"];
    NSString *userName= [dict objectForKey:@"name"];
    self.userNameLabel.text=userName;
    
    NSString *avatar = [dict objectForKey:@"avatar"];
    NSString *avatarUrl=nil;
    if([avatar rangeOfString:@"http://"].location==NSNotFound){
        avatarUrl = [NSString stringWithFormat:@"http://www.sosozhe.com/%@", avatar];
    }else{
        avatarUrl=avatar;
    }
//    NSURL *url=[NSURL URLWithString:avatarUrl];
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
//    self.avatarImageView.image=image;
    
    NSString *money=[dict objectForKey:@"money"];
    self.moneyLabel.text=[NSString stringWithFormat:@"%@元", money];
    
    NSString *jifenbao=[dict objectForKey:@"jifenbao"];
    self.jifenbaoLabe.text=[NSString stringWithFormat:@"%@", jifenbao];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
