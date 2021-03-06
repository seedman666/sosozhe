//
//  MemberOnlyViewController.m
//  sosozhe
//
//  Created by seed on 14-12-1.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import "MemberOnlyViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import <AFNetworking.h>
#import "MemberOnlyTableViewCell.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "Constant.h"
#import "PassValueUtil.h"
#import "MD5Util.h"

@interface MemberOnlyViewController ()

@property NSMutableArray* products;
@property MBProgressHUD* HUD;
@property NSInteger type;
@property NSInteger page;
@property NSArray* tags;
@property NSMutableArray* tagLabels;
@end

@implementation MemberOnlyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [[self memberOnlyBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"tab_tao_2_s"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_tao_1_s"]];
    
    [[self searchText] setReturnKeyType:UIReturnKeyGo];
    [[self searchText] setDelegate:self];
    
    self.tagProductShowTableView.dataSource=self;
    self.tagProductShowTableView.delegate=self;
    
    [self.tagProductShowTableView addFooterWithTarget:self action:@selector(loadMoreDataToTable)];
    self.page=1;
    [self.button0 setBackgroundColor:[UIColor grayColor]];
    
    self.tags=[NSArray arrayWithObjects:@"全部商品", @"女装", @"男装", @"居家", @"母婴", @"鞋包", @"配饰", @"美食", @"数码家电", @"化妆品", @"9.9元", @"19.9元", nil];
    
    
    [self genNavView];
    [self requestTagProducts:0];
    
}

-(void) genNavView{
    self.tagLabels=[[NSMutableArray alloc] init];
    for (int i=0; i<[self.tags count]; i++) {
        UIView *view=[[UIButton alloc] initWithFrame:CGRectMake((i)*50+5, 5, 50, self.navScrollView.frame.size.height-10)];
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
//        [label setTitle:[self.tags objectAtIndex:i] forState:UIControlStateNormal];
        label.text=[self.tags objectAtIndex:i];
        label.font=[UIFont systemFontOfSize:12];
        label.textAlignment=UITextAlignmentCenter;
        label.textColor=[UIColor blackColor];
        
//        [label setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (i==0) {
            view.backgroundColor=[UIColor grayColor];
        }
        [view addSubview:label];
        view.tag=i;
        UITapGestureRecognizer *tapGestureTel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelDown:)];
        [view addGestureRecognizer:tapGestureTel];
        
        [self.navScrollView addSubview:view];
        [self.tagLabels addObject:view];
    }
    self.navScrollView.contentSize = CGSizeMake([self.tags count]*50, self.navScrollView.frame.size.height);
}

-(void) labelDown:(UITapGestureRecognizer *)gesture{
    UIView *label=gesture.view;
    for (int i=0; i<self.tagLabels.count; i++) {
        UIView *view=[self.tagLabels objectAtIndex:i];
        view.backgroundColor=[UIColor clearColor];
        if (i==label.tag) {
            view.backgroundColor=[UIColor grayColor];
        }
    }
    [self requestTagProducts:label.tag];
}

- (IBAction)buttonDown:(id)sender {
    [self.button0 setBackgroundColor:[UIColor clearColor]];
    [self.button1 setBackgroundColor:[UIColor clearColor]];
    [self.button2 setBackgroundColor:[UIColor clearColor]];
    [self.button3 setBackgroundColor:[UIColor clearColor]];
    [self.button4 setBackgroundColor:[UIColor clearColor]];
    [self.button5 setBackgroundColor:[UIColor clearColor]];
    [self.button6 setBackgroundColor:[UIColor clearColor]];
    [self.button7 setBackgroundColor:[UIColor clearColor]];
    [self.button8 setBackgroundColor:[UIColor clearColor]];
    [self.button9 setBackgroundColor:[UIColor clearColor]];
    [self.button10 setBackgroundColor:[UIColor clearColor]];
    [self.button11 setBackgroundColor:[UIColor clearColor]];
    
    UIButton *button=sender;
    [button setBackgroundColor:[UIColor grayColor]];
    self.type=button.tag;
    
     [self requestTagProducts:button.tag];
    
}

-(void) loadMoreDataToTable{
    self.page=self.page+1;
    
    
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970];
    NSString *timestamp=[NSString stringWithFormat:@"%lld", recordTime];
    NSString *token=[MD5Util md5:[NSString stringWithFormat:@"%@%s", timestamp, SECURE_KEY ] ];
    NSString *urlStr=[NSString stringWithFormat:@"%@%li%@%li%@%@%@%@", @"index.php?mod=ajax&act=hyzx&page_no=",self.page, @"&page_size=10&cateid=",self.type,@"&timestamp=",timestamp,@"&token=",token ];
//    NSLog(@"%@", urlStr);
    
    NSURL *url = [NSURL URLWithString:@"http://m.sosozhe.com/"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    [client postPath:urlStr parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSArray *array=(NSArray *) [responseObject objectForKey:@"result"];
                 [self.products addObjectsFromArray:array];
                 
                 // 2.2秒后刷新表格UI
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     // 刷新表格
                     [self.tagProductShowTableView reloadData];
                     
                     // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                     [self.tagProductShowTableView footerEndRefreshing];
                 });
                 
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void) requestTagProducts :(NSInteger) type{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    self.HUD.delegate = self;
    self.HUD.labelText = @"正在加载数据";
    self.HUD.dimBackground = YES;
    [self.HUD show:YES];

    
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970];
    NSString *timestamp=[NSString stringWithFormat:@"%lld", recordTime];
    NSString *token=[MD5Util md5:[NSString stringWithFormat:@"%@%s", timestamp, SECURE_KEY ] ];
    NSString *urlStr=[NSString stringWithFormat:@"%@%li%@%@%@%@", @"index.php?mod=ajax&act=hyzx&page_no=1&page_size=10&cateid=",type,@"&timestamp=",timestamp,@"&token=",token ];
//    NSLog(@"%@", urlStr);
    NSURL *url = [NSURL URLWithString:@"http://m.sosozhe.com/"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    [client postPath:urlStr parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSArray *array=(NSArray *) [responseObject objectForKey:@"result"];
                 self.products = [NSMutableArray arrayWithArray:array];
                 [self.HUD removeFromSuperview];
                 [[self tagProductShowTableView] reloadData];
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"%@", error);
                 [self.HUD removeFromSuperview];
                 
             }];

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"MemberOnlyCell";
    MemberOnlyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MemberOnlyTableViewCell" owner:self options:nil] lastObject];
        
    }
    NSUInteger row = [indexPath row];
    NSDictionary *dict=[self.products objectAtIndex:row];
//    NSLog(@"%@", dict);
    
    NSURL *url=[NSURL URLWithString:[dict objectForKey:@"pic_url"]];
    cell.iconView.imageURL=url;
    
    cell.titleLabel.numberOfLines=2;
    cell.titleLabel.text=[dict objectForKey:@"title"];
    cell.priceLabel.text=[NSString stringWithFormat:@"￥%@",[dict objectForKey:@"price"]];
    cell.discountLabel.text=[NSString stringWithFormat:@"%@折",[dict objectForKey:@"zk"]];
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 104;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"%lu", (unsigned long)self.products.count);
    return  [[self products]count];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict=[self.products objectAtIndex:[indexPath row]];
    NSString *url=[dict objectForKey:@"click_url"];
    
    [self performSegueWithIdentifier:@"itemViewDetailId" sender:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"webviewParamNotification" object:url];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if (textField == [self searchText]) {
        [PassValueUtil setSearchText:textField.text];
        [textField resignFirstResponder];
        [self performSegueWithIdentifier:@"SearchViewIde" sender:self];
        
    }
    return YES;
}


@end
