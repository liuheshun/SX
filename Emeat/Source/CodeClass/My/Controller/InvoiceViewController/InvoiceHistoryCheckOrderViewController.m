//
//  InvoiceHistoryCheckOrderViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/6/27.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "InvoiceHistoryCheckOrderViewController.h"
#import "InvoiceListModel.h"
#import "InvoiceListTableViewCell.h"
#import "MyOrderTableViewCell.h"
@interface InvoiceHistoryCheckOrderViewController ()<UITableViewDelegate , UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *invoiceListMarray;
@property (nonatomic,strong) NSMutableArray *invoiceImageListMarray;


@end

@implementation InvoiceHistoryCheckOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navItem.title = @"开票订单详情";
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    [self.view addSubview:self.tableView];
    self.invoiceListMarray = [NSMutableArray array];
    self.invoiceImageListMarray = [NSMutableArray array];
    [self requestInvoiceHistoryOrdersDetails:self.invoiceId];
}




#pragma mark===开票历史详情

-(void)requestInvoiceHistoryOrdersDetails:(NSString*)InvoiceHistoryDetailsId{
    
    NSDictionary *dic = [self checkoutData];
    [dic setValue:self.invoiceId forKey:@"invoiceId"];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    

    [MHAsiNetworkHandler startMonitoring];
    [MHNetworkManager getRequstWithURL:[NSString stringWithFormat:@"%@/m/auth/appInvoice/queryOrdersByInoviceId" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {

        if ([returnData[@"status"] integerValue] == 200) {
            [self.invoiceImageListMarray removeAllObjects];
            if ([returnData[@"data"][@"list"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in returnData[@"data"][@"list"]) {
                    
                    OrderModel *firstModel = [OrderModel yy_modelWithJSON:dic];
                    
                    NSString *Id = dic[@"id"];
                    
                    CGFloat prices = [ dic[@"orderMoney"][@"netPrice"] floatValue]/100;
                    NSString *netPrice = [NSString stringWithFormat:@"%.2f" ,prices];
                    firstModel.productId = Id;
                    firstModel.payment = netPrice;
                    firstModel.productAmount = dic[@"quantity"];
                    
                    
                    
                    // timeStampString 是服务器返回的13位时间戳
                    NSString *timeStampString  = dic[@"createTime"];
                    // iOS 生成的时间戳是10位
                    NSTimeInterval interval    =[timeStampString doubleValue] / 1000.0;
                    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *dateString       = [formatter stringFromDate: date];
                   // NSLog(@"服务器返回的时间戳对应的时间是:%@",dateString);
                    
                    firstModel.createOrderTime = dateString;
                    firstModel.statusDesc = @"已完成";
                    [self.invoiceListMarray addObject:firstModel];
                    
                        
                   
                    NSMutableArray *Marray = [NSMutableArray array];
                    for (NSDictionary *dicDetails in dic[@"orderItem"]) {
                        
                        OrderModel *model = [OrderModel yy_modelWithJSON:dicDetails];
                        NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.productImage componentsSeparatedByString:@","]];
                            if (mainImvMarray.count!=0) {
                                model.productImage = [mainImvMarray firstObject];
                            }
                            
                            //                model.pages = pages;
                            //                model.pageSize = pageSize;
                            //                model.total = total;
                            [Marray addObject:model.productImage];
                        }
                        [self.invoiceImageListMarray addObject:Marray];
                        
                    }
                    
                    [self.tableView reloadData];
                
                

            }
            //[self.tableView reloadData];
            
        }
        
        
        
        
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
    
    
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
    
    return self.invoiceListMarray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180*kScale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 15)];
    view.backgroundColor = [UIColor redColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 15*kScale)];
    view.backgroundColor = RGB(238, 238, 238, 1);
    
    return view;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.invoiceImageListMarray.count != 0) {
        MyOrderTableCellConfig *orderConfig = [MyOrderTableCellConfig myOrderTableCellConfig];
        orderConfig.orderImvArray = self.invoiceImageListMarray[indexPath.section];

        
    }
    NSString *s = [NSString stringWithFormat:@"%ldInvoiceHistoryCheckOrderView_cell",indexPath.section];

    MyOrderTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:s];
    if (cell1 == nil) {
        cell1 = [[MyOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:s];
        
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        cell1.backgroundColor = [UIColor whiteColor];
        
    }
    
    if (self.invoiceListMarray.count != 0) {
        OrderModel *model = self.invoiceListMarray[indexPath.section];
//        totalPageCount = model.pages;
        [cell1 configWithOrderModel:model];
        cell1.orderTimeLab.text = model.createTime;
        cell1.orderStated.text = @"已完成";


        
    }
    return cell1;
}

#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //隐藏tabBar
    OrderDetailesViewController *VC = [OrderDetailesViewController new];
    OrderModel *model = self.invoiceListMarray[indexPath.section];
    VC.orderNo = model.orderNo;
    [self.navigationController pushViewController:VC animated:YES];
}




//#pragma mark===开票订单详情
//
//-(void)requestInvoiceHistoryDetails:(NSString*)InvoiceHistoryDetailsId{
//
//    NSDictionary *dic = [self checkoutData];
//    [dic setValue:@"10" forKey:@"invoiceId"];
//    DLog(@"开票订单详情数据== %@" ,dic );
//
//
//    [MHAsiNetworkHandler startMonitoring];
//    [MHNetworkManager getRequstWithURL:[NSString stringWithFormat:@"%@/m/auth/appInvoice/queryOrdersByInoviceId" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
//
//        if ([returnData[@"status"] integerValue] == 200) {
//
//
//        }
//
//        //[self.tableView reloadData];
//
//        DLog(@"开票订单详情详情数据== jeikou == %@ " ,returnData);
//
//
//
//    } failureBlock:^(NSError *error) {
//
//
//    } showHUD:NO];
//
//
//}
//






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
