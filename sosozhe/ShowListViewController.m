//
//  ShowListViewController.m
//  sosozhe
//
//  Created by seed on 14-12-8.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import "ShowListViewController.h"
#import "IncomeTableViewCell.h"
#import "CheckInHistoryTableViewCell.h"
#import "MessageTableViewCell.h"
#import "PassValueUtil.h"
#import "MD5Util.h"
#import "Constant.h"
#import <AFNetworking.h>
#import "MBProgressHUD.h"
#import "MJRefresh.h"

@interface ShowListViewController ()

@property int page;
@property NSMutableArray *results;
@property MBProgressHUD *HUD;

@end

@implementation ShowListViewController

static NSString *TYPE;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.showListTableView.delegate=self;
    self.showListTableView.dataSource=self;
    self.page=0;
    self.results =[[NSMutableArray alloc] init];
    
    if ([[PassValueUtil listType] isEqualToString:@"income"]) {
        self.titleLabel.text=@"我的收入明细";
        UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
        label1.text=@"时间";
        label1.textAlignment=UITextAlignmentCenter;
        label1.font=[UIFont systemFontOfSize:13];
        [self.headerView addSubview:label1];
        
        UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(160, 0, 160, 40)];
        label2.text=@"内容";
        label2.textAlignment=UITextAlignmentCenter;
        label2.font=[UIFont systemFontOfSize:13];
        [self.headerView addSubview:label2];

        
    }else if ([[PassValueUtil listType] isEqualToString:@"checkin"]){
        UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
        label1.text=@"签到时间";
        label1.textAlignment=UITextAlignmentCenter;
        label1.font=[UIFont systemFontOfSize:13];
        [self.headerView addSubview:label1];
        
        UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(160, 0, 160, 40)];
        label2.text=@"积分宝";
        label2.textAlignment=UITextAlignmentCenter;
        label2.font=[UIFont systemFontOfSize:13];
        [self.headerView addSubview:label2];

        self.titleLabel.text=@"我的签到明细";
    }else if ([[PassValueUtil listType] isEqualToString:@"msg"]){
        UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
        label1.text=@"时间";
        label1.textAlignment=UITextAlignmentCenter;
        label1.font=[UIFont systemFontOfSize:13];
        [self.headerView addSubview:label1];
        
        UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(160, 0, 160, 40)];
        label2.text=@"内容";
        label2.textAlignment=UITextAlignmentCenter;
        label2.font=[UIFont systemFontOfSize:13];
        [self.headerView addSubview:label2];
        
        self.titleLabel.text=@"我的签到明细";

        self.titleLabel.text=@"站内消息";
    }
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    self.HUD.labelText = @"正在加载数据";
    self.HUD.dimBackground = YES;
    [self.HUD show:YES];
    
    [self.showListTableView addFooterWithTarget:self action:@selector(loadMoreDataToTable)];
    
    [self loadMoreDataToTable];
}

- (void) loadMoreDataToTable
{
    self.page=self.page+1;
    
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970];
    NSString *timestamp=[NSString stringWithFormat:@"%lld", recordTime];
    NSString *token=[MD5Util md5:[NSString stringWithFormat:@"%@%s", timestamp, SECURE_KEY ] ];
    
    
    NSURL *url = [NSURL URLWithString:@"http://m.sosozhe.com/"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    NSString *urlStr=nil;
    if ([[PassValueUtil listType] isEqualToString:@"income"]) {
        urlStr=[NSString stringWithFormat:@"%@%@%@%@%@%@%@", @"index.php?mod=ajax&act=income",@"&page_no=",[NSString stringWithFormat:@"%i", self.page],@"&page_size=10&timestamp=",timestamp,@"&token=",token ];
    }else if ([[PassValueUtil listType] isEqualToString:@"checkin"]){
        urlStr=[NSString stringWithFormat:@"%@%@%@%@%@%@%@", @"index.php?mod=ajax&act=qdmingxi",@"&page_no=",[NSString stringWithFormat:@"%i", self.page],@"&page_size=10&timestamp=",timestamp,@"&token=",token ];
    }else if ([[PassValueUtil listType] isEqualToString:@"msg"]){
        urlStr=[NSString stringWithFormat:@"%@%@%@%@%@%@%@", @"index.php?mod=ajax&act=get_msg",@"&page_no=",[NSString stringWithFormat:@"%i", self.page],@"&page_size=10&timestamp=",timestamp,@"&token=",token ];
    }
    
    [client postPath:urlStr parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 // [self.HUD removeFromSuperview];
                 NSArray *array=(NSArray *) [responseObject objectForKey:@"result"];
                 if ([array count]< 10) {
                     [self.showListTableView removeFooter];
                 }
                 NSLog(@"%@", array);
                 [self.results addObjectsFromArray:array];
                 
                 // 2.2秒后刷新表格UI
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [self.HUD removeFromSuperview];
                     // 刷新表格
                     [self.showListTableView reloadData];
                     
                     // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                     [self.showListTableView footerEndRefreshing];
                     
                 });
                 
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [self.HUD removeFromSuperview];
                 NSLog(@"%@", error);
                 
             }];
    
}

- (IBAction)back:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma make - tableview data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[PassValueUtil listType] isEqualToString:@"income"]) {
        static NSString *CellWithIdentifier = @"IncomeTableViewCell";
        IncomeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellWithIdentifier owner:self options:nil] lastObject];
            NSUInteger row = [indexPath row];
            NSDictionary *dict=[self.results objectAtIndex:row];
            cell.timeLabel.numberOfLines=2;
            cell.timeLabel.text=[dict objectForKey:@"addtime"];
        
            cell.detailLabel.numberOfLines=2;
            cell.detailLabel.text=[dict objectForKey:@"content"];
        }
        return cell;
    }else if ([[PassValueUtil listType] isEqualToString:@"checkin"]){
        static NSString *CellWithIdentifier = @"CheckInHistoryTableViewCell";
        CheckInHistoryTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellWithIdentifier owner:self options:nil] lastObject];
            NSUInteger row = [indexPath row];
            NSDictionary *dict=[self.results objectAtIndex:row];
            cell.timeLabel.numberOfLines=2;
            cell.timeLabel.text=[dict objectForKey:@"addtime"];
            
            cell.detailLabel.numberOfLines=2;
            cell.detailLabel.text=[dict objectForKey:@"jifenbao"];
        }
        return cell;
    }else if ([[PassValueUtil listType] isEqualToString:@"msg"]){
        static NSString *CellWithIdentifier = @"MessageTableViewCell";
        MessageTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellWithIdentifier owner:self options:nil] lastObject];
            NSUInteger row = [indexPath row];
            NSDictionary *dict=[self.results objectAtIndex:row];
            cell.timeLabel.numberOfLines=2;
            cell.timeLabel.text=[dict objectForKey:@"addtime"];
            
            cell.detailLabel.numberOfLines=0;
            cell.detailLabel.text=[dict objectForKey:@"content"];
        }
        return cell;
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[PassValueUtil listType] isEqualToString:@"msg"]) {
        return 112;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [[self results]count];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma make - tableview deletate

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
