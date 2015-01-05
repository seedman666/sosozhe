//
//  RightLeftStoryboardSegue.m
//  sosozhe
//
//  Created by seed on 14-12-23.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import "RightLeftStoryboardSegue.h"

@implementation RightLeftStoryboardSegue


-(void)perform{
    UIViewController* source = (UIViewController *)self.sourceViewController;
    UIViewController* destination = (UIViewController *)self.destinationViewController;
    
    CGRect sourceFrame = source.view.frame;
    sourceFrame.origin.x = -sourceFrame.size.width;
    
    CGRect destFrame = destination.view.frame;
    destFrame.origin.x = destination.view.frame.size.width;
    destination.view.frame = destFrame;
    
    destFrame.origin.x = 0;
    [source.view.superview addSubview:destination.view];
    [UIView animateWithDuration:.25
                     animations:^{
                         source.view.frame = sourceFrame;
                         destination.view.frame = destFrame;
                     }
                     completion:^(BOOL finished) {
                         [source presentViewController:destination animated:NO completion:nil];
                     }];
}


@end
