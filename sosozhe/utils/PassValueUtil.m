//
//  PassValueUtil.m
//  sosozhe
//
//  Created by seed on 14-12-7.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import "PassValueUtil.h"

@implementation PassValueUtil

static NSString* searchText;
static NSString* listType;
static NSString* messageId;
static NSString* msgContent;
static NSString * msgAddTime;
static NSString* url;
static NSString* webViewTitle;
static NSString* webViewTitle2;

+(NSString *) searchText{
    return searchText;
}

+(void) setSearchText:(NSString *)text{
    searchText=text;
}

+(NSString *) listType{
    return listType;
}

+(void) setListType:(NSString *)type{
    listType=type;
}

+(NSString *) msgId{
    return messageId;
}

+(void) setMsgId:(NSString *)msgId{
    messageId=msgId;
}

+(NSString *) msgContent{
    return msgContent;
}

+(void) setMsgContent:(NSString *)content{
    msgContent=content;
}

+(NSString *) msgAddTime{
    return msgAddTime;
}

+(void) setMsgAddTime:(NSString *)time{
    msgAddTime=time;
}

+(NSString *) getUrl{
    return  url;
}

+(void) setUrl:(NSString *)urlStr{
    url=urlStr;
}

+(NSString *) getWebViewTitle{
    return webViewTitle;
}

+(void) setWebViewTitle:(NSString *)title{
    webViewTitle=title;
}

+(NSString *) getWebViewTitle2{
    return webViewTitle2;
}

+(void) setWebViewTitle2:(NSString *)title2{
    webViewTitle2=title2;
}

@end
