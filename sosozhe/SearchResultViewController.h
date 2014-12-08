//
//  SearchResultViewController.h
//  sosozhe
//
//  Created by seed on 14-11-5.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *searchResultPullTableView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *searchTextArea;

@end
