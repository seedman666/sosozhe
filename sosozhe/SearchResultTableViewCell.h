//
//  SearchResultTableViewCell.h
//  sosozhe
//
//  Created by seed on 14-11-18.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface SearchResultTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet EGOImageView *egoImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *fanliLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;


@end
