//
//  IndexViewController.m
//  sosozhe
//
//  Created by seed on 14-4-16.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import "IndexViewController.h"
#import "SGFocusImageItem.h"
#import "SGFocusImageFrame.h"
#import <AFNetworking.h>
#import "Header.h"
#import "MBProgressHUD.h"
#import "BrandView.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "LoginUtil.h"
#import "MD5Util.h"
#import "CommonUtil.h"
#import "Constant.h"
#import "PassValueUtil.h"

@interface IndexViewController ()<MBProgressHUDDelegate>
@property MBProgressHUD *HUD;
@property BOOL isLogin;
@end

@implementation IndexViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [[self indexTabBar] setFinishedSelectedImage:[UIImage imageNamed:@"tab_index_2_s"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_index_1_s"]];
    [LoginUtil checkLoginAsyn];
    [[self searchText] setReturnKeyType:UIReturnKeyGo];
    [[self searchText] setDelegate:self];
   
    SGFocusImageItem *item1 = [[SGFocusImageItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"banner1"] tag:0];
    SGFocusImageItem *item2 = [[SGFocusImageItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"banner3"] tag:1];
    SGFocusImageItem *item3 = [[SGFocusImageItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"banner3"] tag:2];
    SGFocusImageFrame *imageFrame = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, self.bannerView.bounds.size.width, self.bannerView.bounds.size.height)
                                                                    delegate:self
                                                             focusImageItems:item1, item2, item3,
                                     nil];
    [[self bannerView] addSubview:imageFrame];
    
    UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(vipClick:)];
    UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkInClick:)];
    UITapGestureRecognizer *tapGesture3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addFriendClick:)];
    [[self vipView] addGestureRecognizer:tapGesture1];
    [[self checkInView] addGestureRecognizer:tapGesture2];
    [[self addFriendView] addGestureRecognizer:tapGesture3];
    
    
    [self requestHotBrand];
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    self.HUD.delegate = self;
    self.HUD.labelText = @"正在加载数据";
    self.HUD.dimBackground = YES;
    [self.HUD show:YES];
    
    if (!IS_IPHONE5){
        [[self scrollView] setFrame:CGRectMake(0, 0, 320, 480)];
        [[self scrollView] setContentSize:CGSizeMake(320, 568)];
        [[self scrollView] setContentOffset:CGPointMake(0, 0)];
        [[self scrollView] setContentInset:UIEdgeInsetsMake(0 , 0, 0, 0)];
        self.scrollView.bounces=FALSE;
    }
}

-(void) requestHotBrand{
    NSURL *url = [NSURL URLWithString:@"http://m.sosozhe.com/"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *parameters = @{@"page": @"1", @"num" : @"9", @"mod" : @"ajax", @"act": @"malls"};
    
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];

    [client postPath:@"index.php?mod=ajax&act=malls&page=1&num=9" parameters:parameters
    success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.HUD removeFromSuperview];
        NSArray *array=(NSArray *) [responseObject objectForKey:@"result"];
        for (int i=0; i<[array count]; i=i+1) {
            NSDictionary *dict=[array objectAtIndex:i];
            int j=(i/3)%3;
            
            NSString *imgUrl=[dict objectForKey:@"img"];
            NSString *title=[[dict objectForKey:@"title"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *fanRation=[dict objectForKey:@"fan"];
            NSString *url=[dict objectForKey:@"url"];
            
            BrandView *brandView=[[BrandView alloc] initWithFrame:CGRectMake(9+100*(i%3), 29+76*(j%3), 77, 65)];
            brandView.url=url;
            UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(brandViewClick:)];
            [brandView addGestureRecognizer:tapGesture];
            
            
            
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 77, 40)];
            UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 41, 50, 25)];
            UILabel *fanLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 41, 30, 25)];
            
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
            [imageView setImage:image];
            [titleLabel setText:title];
            [titleLabel setFont:[UIFont systemFontOfSize:10]];
            [fanLabel setText:fanRation];
            [fanLabel setFont:[UIFont systemFontOfSize:10]];
            [fanLabel setTextColor:[UIColor orangeColor]];
            
            [brandView addSubview:imageView];
            [brandView addSubview:titleLabel];
            [brandView addSubview:fanLabel];
            
            [[self hotStoreView] addSubview:brandView];
        }
        
//        BrandView *brandView=[[BrandView alloc] initWithFrame:CGRectMake(9+100*2, 29+76*2, 77, 65)];
//        UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 41, 50, 25)];
//        [titleLabel setText:@"查看更多"];
//        [titleLabel setFont:[UIFont systemFontOfSize:10]];
//        [brandView addSubview:titleLabel];
//        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moreBrandViewClick:)];
//        [brandView addGestureRecognizer:tapGesture];
//        [[self hotStoreView] addSubview:brandView];

    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.HUD removeFromSuperview];
        NSLog(@"%@", error);
    }];
}

- (void)vipClick:(UITapGestureRecognizer *)gesture{
    AppDelegate *thisAppDelegate = [[UIApplication sharedApplication] delegate];
    [(UITabBarController *)thisAppDelegate.window.rootViewController setSelectedIndex:1];
}

-(void) brandViewClick:(UITapGestureRecognizer *) gesture{
    [self performSegueWithIdentifier:@"brandDetailWebView" sender:self];
    BrandView *view=(BrandView *)gesture.view;
    NSString *url=view.url;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"webviewParamNotification" object:url];
    
}

-(void) moreBrandViewClick:(UITapGestureRecognizer *) gesture{
    AppDelegate *thisAppDelegate = [[UIApplication sharedApplication] delegate];
    [(UITabBarController *)thisAppDelegate.window.rootViewController setSelectedIndex:2];
}

- (void)checkInClick:(UITapGestureRecognizer *)gesture{
    if (!LoginUtil.isLogin) {
        [self performSegueWithIdentifier:@"LoginViewControllerId" sender:self];
        return;
    }
    [CommonUtil checkIn:self.view];
    
}

- (void)addFriendClick:(UITapGestureRecognizer *)gesture{
    if (!LoginUtil.isLogin) {
        [self performSegueWithIdentifier:@"LoginViewControllerId" sender:self];
        return;
    }
    [CommonUtil inviteFriend:self];
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

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if (textField == [self searchText]) {
        [PassValueUtil setSearchText:textField.text];
        [textField resignFirstResponder];
        [self performSegueWithIdentifier:@"SearchViewIde" sender:self];
//        AppDelegate *thisAppDelegate = [[UIApplication sharedApplication] delegate];
//        [(UITabBarController *)thisAppDelegate.window.rootViewController setSelectedIndex:2];
        
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"searchResultParamNotification" object:textField.text];
        
    }
    return YES;
}



@end
