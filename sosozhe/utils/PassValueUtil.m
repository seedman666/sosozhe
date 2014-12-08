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
@end
