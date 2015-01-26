//
//  MyAccountViewController.h
//  sosozhe
//
//  Created by seed on 14-4-21.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAccountViewController : UIViewController
//@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIView *qiandaoView;
@property (weak, nonatomic) IBOutlet UIView *yaoqingView;
@property (weak, nonatomic) IBOutlet UIView *taobaoOrderView;
@property (weak, nonatomic) IBOutlet UIView *paipaiOrderView;
@property (weak, nonatomic) IBOutlet UIView *shouruListView;
@property (weak, nonatomic) IBOutlet UIView *qiandaoListView;
@property (weak, nonatomic) IBOutlet UITabBarItem *myAccountBarItem;
@property (weak, nonatomic) IBOutlet UIView *mallOrderView;
@property (weak, nonatomic) IBOutlet UIButton *msgButton;
@property (weak, nonatomic) IBOutlet UILabel *jifenbaoLabe;

@end
