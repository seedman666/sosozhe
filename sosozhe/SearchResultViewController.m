//
//  SearchResultViewController.m
//  sosozhe
//
//  Created by seed on 14-11-5.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import "SearchResultViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import <AFNetworking.h>


@interface SearchResultViewController ()
@property NSArray *searchResult;

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:@"searchResultParamNotification" object:nil];
    [self tableView].dataSource=self;
    [self tableView].delegate=self;
    
}

-(void) notificationHandler:(NSNotification *) notification{
    
    NSString *text = [notification object];
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970];
    NSString *timestamp=[NSString stringWithFormat:@"%lld", recordTime];
    NSString *token=[self md5:[NSString stringWithFormat:@"%@%@", timestamp, @"uuN5wmUuRsDe6" ] ];
    NSString *urlStr=[NSString stringWithFormat:@"%@%@%@%@%@%@", @"index.php?mod=ajax&act=search&keyword=",text,@"&page_no=1&page_size=30&type=1&timestamp=",timestamp,@"&token=",token ];
    NSLog(@"%@", urlStr);
    
    NSURL *url = [NSURL URLWithString:@"http://m.sosozhe.com/"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    [client postPath:urlStr parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 self.searchResult=(NSArray *) [responseObject objectForKey:@"result"];
                 [[self tableView] reloadData];
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"%@", error);
             }];
    
    
    
}

- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellWithIdentifier];
    }
    NSUInteger row = [indexPath row];
    NSDictionary *dict=[self.searchResult objectAtIndex:row];
    //NSLog(@"%@", dict);
    cell.textLabel.text = [dict objectForKey:@"title"];
    NSLog(@"%@", [dict objectForKey:@"pic_url"]);
    NSURL *url = [NSURL URLWithString:[dict objectForKey:@"pic_url"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    
    cell.imageView.image = image;
    cell.detailTextLabel.text = @"详细信息";
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu", (unsigned long)self.searchResult.count);
    return  [[self searchResult]count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
