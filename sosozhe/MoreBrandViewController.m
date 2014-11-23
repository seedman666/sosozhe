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

@interface MoreBrandViewController ()<MBProgressHUDDelegate>
@property NSArray *results;
@property MBProgressHUD *HUD;
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
    
    [[self searchText] setReturnKeyType:UIReturnKeyGo];
    [[self searchText] setDelegate:self];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self requestHotBrand];
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    self.HUD.delegate = self;
    self.HUD.labelText = @"正在加载数据";
    self.HUD.dimBackground = YES;
    [self.HUD show:YES];
    //[self.HUD showWhileExecuting:@selector(requestHotBrand) onTarget:self withObject:nil animated:YES];

}

-(void) requestHotBrand{
    
    NSURL *url = [NSURL URLWithString:@"http://m.sosozhe.com/"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *parameters = @{@"page": @"2", @"num" : @"9"};
    
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    [client postPath:@"index.php?mod=ajax&act=malls&page=2&num=18" parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"%@", responseObject);
                 NSArray *array=(NSArray *) [responseObject objectForKey:@"result"];
                 self.results=array;
                 [self.tableView reloadData];
                 [self.HUD removeFromSuperview];
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
    NSLog(@"1%@", url);
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
        
        [textField resignFirstResponder];
        [self performSegueWithIdentifier:@"SearchViewIde" sender:self];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"searchResultParamNotification" object:textField.text];
        
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
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"BrandView" owner:self options:nil];
    BrandView *view=[nib objectAtIndex:0];
    if (image) {
        view.imageView.image=image;
    }
    view.fanliLabel.text=[NSString stringWithFormat:@"最高返利：%@", [dict objectForKey:@"fan"]];
    NSString *url=[dict objectForKey:@"url"];
    view.url=url;

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
