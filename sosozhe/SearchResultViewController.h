//
//  SearchResultViewController.h
//  sosozhe
//
//  Created by seed on 14-11-5.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITabBarItem *shouyeBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *taobaofanliBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *myAccountBar;


@end
