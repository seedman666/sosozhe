//
//  LoginUtil.h
//  sosozhe
//
//  Created by seed on 14-12-7.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginUtil : NSObject

+(BOOL) isLogin;
+(void) setLogin :(BOOL) islog;
+(void) checkLoginAsyn;

+(NSString *) getUid;
+(void) setUid:(NSString *)userId;
@end
