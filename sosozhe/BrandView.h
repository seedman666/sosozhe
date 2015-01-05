//
//  BrandView.h
//  sosozhe
//
//  Created by seed on 14-4-19.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface BrandView : UIView

@property NSString *url;
@property NSString *title;
@property NSString *title2;

@property (weak, nonatomic) IBOutlet UILabel *fanliLabel;
@property (weak, nonatomic) IBOutlet EGOImageView *brandEgoImageVIew;

@end
