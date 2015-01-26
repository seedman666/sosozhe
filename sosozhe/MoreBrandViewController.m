//
//  MoreBrandViewController.m
//  sosozhe
//
//  Created by seed on 14-4-20.
//  Copyright (c) 2014年 sosozhe. All rights reserved.
//

#import "MoreBrandViewController.h"
#import <AFNetworking.h>
#import "Header.h"
#import "BrandView.h"
#import <math.h>
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "PassValueUtil.h"

@interface MoreBrandViewController ()<MBProgressHUDDelegate>
@property NSMutableArray *results;
@property MBProgressHUD *HUD;
@property int page;
@end

@implementation MoreBrandViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [[self moreBrandBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"tab_mall_2_s"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_mall_1_s"]];
    
    [[self searchText] setReturnKeyType:UIReturnKeyGo];
    [[self searchText] setDelegate:self];
    self.moreBrandPullTableView.dataSource=self;
    self.moreBrandPullTableView.delegate=self;
    self.page=1;
    [self requestHotBrand];
    
    [self.moreBrandPullTableView addFooterWithTarget:self action:@selector(loadMoreDataToTable)];

    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    self.HUD.delegate = self;
    self.HUD.labelText = @"正在加载数据";
    self.HUD.dimBackground = YES;
    [self.HUD show:YES];
    //[self.HUD showWhileExecuting:@selector(requestHotBrand) onTarget:self withObject:nil animated:YES];

    //self.moreBrandPullTableView.pullDelegate=self;
    //self.moreBrandPullTableView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
    //self.moreBrandPullTableView.pullBackgroundColor = [UIColor whiteColor];
    //self.moreBrandPullTableView.pullTextColor = [UIColor blackColor];
}

-(void) requestHotBrand{
    
    NSURL *url = [NSURL URLWithString:@"http://m.sosozhe.com/"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *parameters = @{@"page": @"1", @"num" : @"9"};
    
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    NSString *urlStr=@"index.php?mod=ajax&act=malls&page=1&num=18";
    if ([PassValueUtil getMallSearchTitle]) {
        urlStr=[NSString stringWithFormat:@"index.php?mod=ajax&act=malls&page=1&num=18&title=%@", [[PassValueUtil getMallSearchTitle] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    [client postPath:urlStr parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSArray *array=(NSArray *) [responseObject objectForKey:@"result"];
                 if (array.count == 0) {
                     
                 }else{
                     self.results=[NSMutableArray arrayWithArray:array];
                     [self.moreBrandPullTableView reloadData];
                     [self.HUD removeFromSuperview];
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"%@", error);
                 [self.HUD removeFromSuperview];
             }];
}

-(void) brandViewClick:(UITapGestureRecognizer *) gesture{
    [self performSegueWithIdentifier:@"brandDetailWebView" sender:self];
    BrandView *view=(BrandView *)gesture.view;
    NSString *url=view.url;
    [PassValueUtil setWebViewTitle:view.title];
    [PassValueUtil setWebViewTitle2:view.title2];
    //NSDictionary *dicts = [NSDictionary dictionaryWithObjectsAndKeys:@"url",url, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"webviewParamNotification" object:url];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if (textField == [self searchText]) {
        [PassValueUtil setMallSearchTitle:textField.text];
//        [textField resignFirstResponder];
//        [self performSegueWithIdentifier:@"SearchViewIde" sender:self];
        [self requestHotBrand];
    }
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"HotBrandTableViewId";
    HotBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HotBrandTableViewCell" owner:self options:nil] lastObject];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.row*3 < self.results.count) {
        UIView *view1=[self getBrandView:indexPath.row*3];
        [cell.view1 addSubview:view1];
    }
    
    if (indexPath.row*3+1 < self.results.count) {
        UIView *view2=[self getBrandView:indexPath.row*3+1];
        [cell.view2 addSubview:view2];
    }
    
    if (indexPath.row*3+2 < self.results.count) {
        UIView *view3=[self getBrandView:indexPath.row*3+2];
        [cell.view3 addSubview:view3];
    }
    
    return cell;
}

-(UIView *) getBrandView :(NSInteger) index
{
    NSDictionary *dict=[self.results objectAtIndex:index];
    NSString *imgUrl=[dict objectForKey:@"img"];
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"BrandView" owner:self options:nil];
    BrandView *view=[nib objectAtIndex:0];
    if (imgUrl.length > 0) {
        view.brandEgoImageVIew.imageURL=[NSURL URLWithString:imgUrl];
        
    }
    view.fanliLabel.text=[NSString stringWithFormat:@"%@", [dict objectForKey:@"fan"]];
    NSString *url=[dict objectForKey:@"url"];
    view.url=url;
    view.title=[dict objectForKey:@"title"];
    view.title2=[dict objectForKey:@"fan"];

    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(brandViewClick:)];
    [view addGestureRecognizer:tapGesture];
    
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 79;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu", (unsigned long)self.results.count);
    return  ceil([[self results]count]/3.0);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void) loadMoreDataToTable
{
    self.page=self.page+1;
    NSURL *url = [NSURL URLWithString:@"http://m.sosozhe.com/"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *parameters = @{@"page": [ NSString stringWithFormat:@"%i",self.page], @"num" : @"9"};
    
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    NSString *urlStr=[NSString stringWithFormat:@"index.php?mod=ajax&act=malls&page=%i&num=18", self.page];
    if ([PassValueUtil getMallSearchTitle]) {
        urlStr=[NSString stringWithFormat:@"index.php?mod=ajax&act=malls&page=%i&num=18&title=%@", self.page,[[PassValueUtil getMallSearchTitle] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [client postPath: urlStr parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSArray *array=(NSArray *) [responseObject objectForKey:@"result"];
                 [self.results addObjectsFromArray:array];
                 
                 // 2.2秒后刷新表格UI
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     // 刷新表格
                     [self.moreBrandPullTableView reloadData];
                     
                     // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                     [self.moreBrandPullTableView footerEndRefreshing];
                 });
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"%@", error);
                 //[self.HUD removeFromSuperview];
             }];
    
    //self.moreBrandPullTableView.pullTableIsLoadingMore = NO;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
