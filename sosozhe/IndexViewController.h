//
//  IndexViewController.h
//  sosozhe
//
//  Created by seed on 14-4-16.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import "ViewController.h"
#import "CustomTextField.h"
#import "MBProgressHUD.h"

@interface IndexViewController : ViewController<MBProgressHUDDelegate, UITextFieldDelegate, UIAlertViewDelegate>{
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UITabBarItem *indexTabBar;
@property (weak, nonatomic) IBOutlet CustomTextField *searchText;
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UIImageView *vipView;
@property (weak, nonatomic) IBOutlet UIImageView *checkInView;
@property (weak, nonatomic) IBOutlet UIImageView *addFriendView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *hotStoreView;

@property (weak, nonatomic) IBOutlet UIView *brand1;
@property (weak, nonatomic) IBOutlet UIView *brand2;

@property (weak, nonatomic) IBOutlet UIView *brand3;
@property (weak, nonatomic) IBOutlet UIView *brand4;
@property (weak, nonatomic) IBOutlet UIView *brand5;
@property (weak, nonatomic) IBOutlet UIView *brand6;
@property (weak, nonatomic) IBOutlet UIView *brand7;
@property (weak, nonatomic) IBOutlet UIView *brand8;
@property (weak, nonatomic) IBOutlet UIView *brand9;

@end
