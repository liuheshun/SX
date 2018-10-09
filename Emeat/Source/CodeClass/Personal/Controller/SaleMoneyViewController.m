//
//  SaleMoneyViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/8/28.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "SaleMoneyViewController.h"
#import "SaleMoneyTableViewCell.h"
#import "SaleWebViewController.h"
#import "ActionSheetView.h"
#import "SaleShareImageViewController.h"

@interface SaleMoneyViewController ()<UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;




@end

@implementation SaleMoneyViewController


-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    self.navItem.title = @"赛鲜推手 躺着赚钱";
    [self.view addSubview:self.tableView];
   
    
}


-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kBarHeight, kWidth, kHeight-kBarHeight-LL_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 0.0001*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 15*kScale)];
    view.backgroundColor = [UIColor redColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 15*kScale)];
    view.backgroundColor = [UIColor cyanColor];
    
    return view;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SaleMoneyTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"SaleMoneyTableViewCell"];
    if (cell1 == nil) {
        cell1 = [[SaleMoneyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SaleMoneyTableViewCell"];
        
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
        cell1.backgroundColor = [UIColor whiteColor];
        [cell1.enterSaleWeb addTarget:self action:@selector(enterSaleWebAction) forControlEvents:1];
    }
    
    
    return cell1;
}

#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //隐藏tabBar
    
}

#pragma mark ====进入分销平台
-(void)enterSaleWebAction{
    
    SaleWebViewController*VC = [SaleWebViewController new];
    
    [self.navigationController pushViewController:VC animated:YES];
    
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

@end
