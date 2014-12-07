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
#import "AppDelegate.h"
#import "SearchResultTableViewCell.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "MD5Util.h"
#import "Constant.h"

@interface SearchResultViewController ()<MBProgressHUDDelegate>
@property NSMutableArray *searchResult;
@property MBProgressHUD *HUD;
@property int page;
@property NSString *searchText;
@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:@"searchResultParamNotification" object:nil];
    [self searchResultPullTableView].dataSource=self;
    [self searchResultPullTableView].delegate=self;
    
    [self.backButton addTarget:self action:@selector(backButtonDown) forControlEvents:UIControlEventTouchDown];
    self.searchResultPullTableView.delegate=self;
    
    [self.searchResultPullTableView addFooterWithTarget:self action:@selector(loadMoreDataToTable)];
    
}


-(void) backButtonDown{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) notificationHandler:(NSNotification *) notification{
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    self.HUD.delegate = self;
    self.HUD.labelText = @"正在加载数据";
    self.HUD.dimBackground = YES;
    [self.HUD show:YES];

    
    self.searchText = [notification object];
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970];
    NSString *timestamp=[NSString stringWithFormat:@"%lld", recordTime];
    NSString *token=[MD5Util md5:[NSString stringWithFormat:@"%@%s", timestamp, SECURE_KEY ] ];
    NSString *urlStr=[NSString stringWithFormat:@"%@%@%@%@%@%@", @"index.php?mod=ajax&act=search&keyword=",self.searchText,@"&page_no=1&page_size=10&type=1&timestamp=",timestamp,@"&token=",token ];
    NSLog(@"%@", urlStr);
    
    self.searchTextArea.text=self.searchText;
    
    NSURL *url = [NSURL URLWithString:@"http://m.sosozhe.com/"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    [client postPath:urlStr parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [self.HUD removeFromSuperview];
                 
                 NSArray *array=(NSArray *) [responseObject objectForKey:@"result"];
                 self.searchResult = [NSMutableArray arrayWithArray:array];
                 
                 [[self searchResultPullTableView] reloadData];
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [self.HUD removeFromSuperview];
                 NSLog(@"%@", error);
                 
             }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"SearchTableViewCell";
    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchResultTableViewCell" owner:self options:nil] lastObject];
        
    }
    NSUInteger row = [indexPath row];
    NSDictionary *dict=[self.searchResult objectAtIndex:row];
    
    NSURL *url=[NSURL URLWithString:[dict objectForKey:@"pic_url"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    cell.imageView.image=image;
    
    cell.titleLabel.numberOfLines=2;
    cell.titleLabel.text=[dict objectForKey:@"title"];
    cell.moneyLabel.text=[NSString stringWithFormat:@"￥%@",[dict objectForKey:@"price"]];
    NSNumber *fanli=[dict objectForKey:@"fanli"];
    if (fanli==0) {
        cell.fanliLabel.text=@"☆暂无返利";
    }else{
        cell.fanliLabel.text=@"☆有返利";
    }
    NSNumber *sales=[dict objectForKey:@"volume"];
    cell.saleLabel.text=[NSString stringWithFormat:@"最近售出：%@", sales];
//    cell.imageView.image = image;
    //cell.detailTextLabel.text = [dict objectForKey:@"title"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSUInteger row = [indexPath row];
//    // 列寬
//    CGFloat contentWidth = self.tableView.frame.size.width;
//    // 用何種字體進行顯示
//    UIFont *font = [UIFont systemFontOfSize:14];
//    // 該行要顯示的內容
//    NSDictionary *dict=[self.searchResult objectAtIndex:row];
//    NSString *content = [dict objectForKey:@"title"];
//    // 計算出顯示完內容需要的最小尺寸
//    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
//    // 這裏返回需要的高度
//    return size.height+20;
    return 95;
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

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict=[self.searchResult objectAtIndex:[indexPath row]];
    NSString *url=[dict objectForKey:@"click_url"];
    
    [self performSegueWithIdentifier:@"itemViewDetailId" sender:self];
    //NSDictionary *dicts = [NSDictionary dictionaryWithObjectsAndKeys:@"url",url, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"webviewParamNotification" object:url];
}


- (void) loadMoreDataToTable
{
    self.page=self.page+1;
    
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970];
    NSString *timestamp=[NSString stringWithFormat:@"%lld", recordTime];
    NSString *token=[MD5Util md5:[NSString stringWithFormat:@"%@%s", timestamp, SECURE_KEY ] ];
    NSString *urlStr=[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", @"index.php?mod=ajax&act=search&keyword=",self.searchText,@"&page_no=",[NSString stringWithFormat:@"%i", self.page],@"&page_size=10&type=1&timestamp=",timestamp,@"&token=",token ];
    NSLog(@"%@", urlStr);
    
    NSURL *url = [NSURL URLWithString:@"http://m.sosozhe.com/"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    [client postPath:urlStr parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSArray *array=(NSArray *) [responseObject objectForKey:@"result"];
                 [self.searchResult addObjectsFromArray:array];
                 
                 // 2.2秒后刷新表格UI
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     // 刷新表格
                     [self.searchResultPullTableView reloadData];
                     
                     // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                     [self.searchResultPullTableView footerEndRefreshing];
                 });
                 
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [self.HUD removeFromSuperview];
                 NSLog(@"%@", error);
                 
             }];

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
