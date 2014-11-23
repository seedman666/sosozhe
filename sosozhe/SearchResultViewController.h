//
//  SearchResultViewController.h
//  sosozhe
//
//  Created by seed on 14-11-5.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"

@interface SearchResultViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate>
@property (weak, nonatomic) IBOutlet PullTableView *searchResultPullTableView;
@property (weak, nonatomic) IBOutlet UITabBarItem *shouyeBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *taobaofanliBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *myAccountBar;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *searchTextArea;

@end
