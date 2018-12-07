//
//  SliceService ViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/7/26.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "SliceService ViewController.h"

@interface SliceService_ViewController ()<UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *titleMarray;


@end

@implementation SliceService_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    self.navItem.title = @"加工服务";
    self.titleMarray = [NSMutableArray array];
    [self requestServeData];
    [self.view addSubview:self.tableView];
}
#pragma mark =============获取加工服务类型
-(void)requestServeData{
    NSDictionary *dic = [NSDictionary dictionary];
    dic = [self checkoutData];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/order/get_service_types" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        if ([returnData[@"status"] integerValue] == 200) {
            for (NSDictionary *dic in returnData[@"data"]) {
                [self.titleMarray addObject:dic];

            }
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
    
    
    
}



-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kBarHeight, kWidth, kHeight-kBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = RGB(238, 238, 238, 1);
    }
    return _tableView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.titleMarray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40*kScale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 10*kScale)];
    view.backgroundColor = RGB(238, 238, 238, 1);
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == (self.titleMarray.count -1)) {
        return 50*kScale;
    }
    return 0.001*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == (self.titleMarray.count -1)) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.001*kScale)];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15*kScale, 0, kWidth-30, 50*kScale)];
        lab.text = @"服务说明: 本公司无偿提供分切服务, 仅收取部分包装耗材费用!";
        lab.font = [UIFont systemFontOfSize:12.0f*kScale];
        lab.textColor = RGB(136, 136, 136, 1);
        [view addSubview:lab];
        view.backgroundColor = RGB(238, 238, 238, 1);
        
        return view;
        
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.001*kScale)];
   
    view.backgroundColor = RGB(238, 238, 238, 1);

    return view;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"slice_cell"];
    if (cell1 == nil) {
        cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"slice_cell"];
        
      [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
        cell1.backgroundColor = [UIColor whiteColor];
        
    }
    cell1.textLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
    cell1.textLabel.textColor = RGB(51, 51, 51, 1);
    NSDictionary *dic = self.titleMarray[indexPath.section];
    cell1.textLabel.text =  dic[@"name"];
    
    return cell1;
}

#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    NSDictionary *dic = self.titleMarray[indexPath.section];
    
    self.returnSelectSliceBlock(dic[@"name"] ,dic[@"types"] , @"" , @"");
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
    
    
    //[self requestSliceServeMoneyDataServiceType:dic[@"types"] ServiceName:dic[@"name"]];
   
    
}

#pragma mark =======计算切片服务费
-(void)requestSliceServeMoneyDataServiceType:(NSString*)serviceType ServiceName:(NSString*)serviceName {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic = [self checkoutData];
    [dic setValue:serviceType forKey:@"serviceType"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/order/get_service_price" , baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
        if ([returnData[@"status"] integerValue] == 200) {
            
            self.returnSelectSliceBlock(serviceName ,serviceType ,returnData[@"data"][@"servicePrice"] , returnData[@"data"][@"totalPrice"]);
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:@"出错啦 (꒦_꒦) "];
            [self.navigationController popViewControllerAnimated:YES];

        }
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"出错啦 (꒦_꒦) "];
        [self.navigationController popViewControllerAnimated:YES];

        
    } showHUD:NO];
    
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
