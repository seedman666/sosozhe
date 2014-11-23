//
//  HotBrandTableViewCell.h
//  sosozhe
//
//  Created by seed on 14-11-23.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandView.h"

@interface HotBrandTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet BrandView *view1;
@property (weak, nonatomic) IBOutlet BrandView *view2;
@property (weak, nonatomic) IBOutlet BrandView *view3;

@end
