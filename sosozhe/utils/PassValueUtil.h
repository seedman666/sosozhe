//
//  PassValueUtil.h
//  sosozhe
//
//  Created by seed on 14-12-7.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PassValueUtil : NSObject

+(NSString *) searchText;
+(void) setSearchText:(NSString *) text;

+(NSString *) listType;
+(void) setListType : (NSString *) type;

+(NSString *) msgId;
+(void) setMsgId:(NSString *)msgId;

+(NSString *) msgContent;
+(void) setMsgContent:(NSString *) content;

+(NSString *) msgAddTime;
+(void) setMsgAddTime:(NSString *) time;

+(NSString *) getUrl;
+(void) setUrl:(NSString *)urlStr;

+(NSString *) getWebViewTitle;
+(void) setWebViewTitle:(NSString *) title;

+(NSString *) getWebViewTitle2;
+(void) setWebViewTitle2:(NSString *)title2;

+(NSString *) getMallSearchTitle;
+(void) setMallSearchTitle:(NSString *) title;

@end
