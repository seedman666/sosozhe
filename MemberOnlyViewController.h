//
//  MemberOnlyViewController.h
//  sosozhe
//
//  Created by seed on 14-12-1.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
#import "MBProgressHUD.h"

@interface MemberOnlyViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tagProductShowTableView;
@property (weak, nonatomic) IBOutlet CustomTextField *searchText;

@property (weak, nonatomic) IBOutlet UIButton *button0;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UIButton *button6;
@property (weak, nonatomic) IBOutlet UIButton *button7;
@property (weak, nonatomic) IBOutlet UIButton *button8;
@property (weak, nonatomic) IBOutlet UIButton *button9;
@property (weak, nonatomic) IBOutlet UIButton *button10;
@property (weak, nonatomic) IBOutlet UIButton *button11;

@property (weak, nonatomic) IBOutlet UIScrollView *navScrollView;


- (IBAction)buttonDown:(id)sender;
@property (weak, nonatomic) IBOutlet UITabBarItem *memberOnlyBarItem;


@end
