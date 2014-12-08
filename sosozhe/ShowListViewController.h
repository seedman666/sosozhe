//
//  ShowListViewController.h
//  sosozhe
//
//  Created by seed on 14-12-8.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *showListTableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@end
