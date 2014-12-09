//
//  OrderTableViewCell.h
//  sosozhe
//
//  Created by seed on 14-12-9.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface OrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet EGOImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *productMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *fanLabel;

@end
