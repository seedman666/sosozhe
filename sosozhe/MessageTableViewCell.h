//
//  MessageTableViewCell.h
//  sosozhe
//
//  Created by seed on 14-12-8.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end
