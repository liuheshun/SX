//
//  OrderDetailesViewController.m
//  Emeat
//
//  Created by liuheshun on 2017/12/8.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "OrderDetailesViewController.h"
#import "MyOrderDetailsStatusHeadView.h"
#import "MyOrderDetailsStatusFootView.h"
#import "MyOrderDetailsTableViewCell.h"
#import "ConfirmOrderInfoBottomView.h"
#import "SelectPayTypeViewController.h"
@interface OrderDetailesViewController ()<UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) MyOrderDetailsStatusHeadView *myOrderDetailsStatusHeadView;
@property (nonatomic,strong) MyOrderDetailsStatusFootView *myOrderDetailsStatusFootView;
@property (nonatomic,strong) ConfirmOrderInfoBottomView *orderInfoBottomView;

///商品数据
@property (nonatomic,strong) NSMutableArray *productMarray;
///配送地址
@property (nonatomic,strong) NSMutableArray *headViewSendAddressMarray;
///订单详细信息
@property (nonatomic,strong) NSMutableArray *footViewOrderInfoMarray;

///订单状态
@property (nonatomic,assign) NSInteger status;



@end

@implementation OrderDetailesViewController
{
    dispatch_source_t _timer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navItem.title = @"订单详情";
    self.view.backgroundColor = RGB(238, 238, 238, 1);
   
    [self requsetOrderDetailsData];

}
-(void)leftItemAction{
    if ([self.fromVC isEqualToString:@"1"])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark =====订单详情

-(void)requsetOrderDetailsData{
    self.productMarray = [NSMutableArray array];
    self.headViewSendAddressMarray = [NSMutableArray array];
    self.footViewOrderInfoMarray = [NSMutableArray array];
    [self.productMarray removeAllObjects];
    [self.headViewSendAddressMarray removeAllObjects];
    [self.footViewOrderInfoMarray removeAllObjects];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *ticket = [user valueForKey:@"ticket"];
    NSString *secret = @"UHnyKzP5sNmh2EV0Dflgl4VfzbaWc4crQ7JElfw1cuNCbcJUau";
    NSString *nonce = [self ret32bitString];//随机数
    NSString *curTime = [self dateTransformToTimeSp];
    NSString *checkSum = [self sha1:[NSString stringWithFormat:@"%@%@%@" ,secret ,  nonce ,curTime]];
    
    [dic setObject:secret forKey:@"secret"];
    [dic setObject:nonce forKey:@"nonce"];
    [dic setObject:curTime forKey:@"curTime"];
    [dic setObject:checkSum forKey:@"checkSum"];
    [dic setObject:ticket forKey:@"ticket"];
    [dic setValue:self.orderNo forKey:@"orderNo"];
    
    
    DLog(@"订单详情dic == %@   orderNo ==== %@ " ,dic , self.orderNo  );
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/auth/order/detail" , baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        DLog(@"订单详情===msg=  %@   returnData == %@" ,returnData[@"msg"] , returnData);
        
        if ([returnData[@"status"] integerValue] == 200)
        {
            [SVProgressHUD dismiss];
            
            MyAddressModel *addressModel = [MyAddressModel yy_modelWithJSON:returnData[@"data"][@"shippingVo"]];
         ////////下面此处出现脏数据的时候 会有问题
            if (addressModel) {
                [self.headViewSendAddressMarray addObject:addressModel];
            }
            
            for (NSMutableDictionary *proDic in returnData[@"data"][@"orderItemVoList"]) {///商品信息数据
                
                OrderModel *orderModel = [OrderModel yy_modelWithJSON:proDic];
                
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[orderModel.productImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    orderModel.productImage = [mainImvMarray firstObject];
                }
                
                orderModel.myAddressModel = addressModel;
                [self.productMarray addObject:orderModel];
            }
            
            OrderModel *footModel = [OrderModel yy_modelWithJSON:returnData[@"data"]];
            self.status = footModel.status;
            [self.footViewOrderInfoMarray addObject:footModel];
            
            [self.view addSubview:self.orderInfoBottomView];////////
            [self setBottomViewFrames];
            [self.view addSubview:self.tableView];

            [self.tableView reloadData];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:returnData[@"msg"]];
        }
     
    } failureBlock:^(NSError *error) {
        DLog(@"获取订单信息err0r=== %@  " ,error);
        [SVProgressHUD dismiss];
    } showHUD:NO];
    
}




#pragma mark =====取消订单


-(void)requsetCancelOrderData{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *ticket = [user valueForKey:@"ticket"];
    NSString *secret = @"UHnyKzP5sNmh2EV0Dflgl4VfzbaWc4crQ7JElfw1cuNCbcJUau";
    NSString *nonce = [self ret32bitString];//随机数
    NSString *curTime = [self dateTransformToTimeSp];
    NSString *checkSum = [self sha1:[NSString stringWithFormat:@"%@%@%@" ,secret ,  nonce ,curTime]];
    
    [dic setObject:secret forKey:@"secret"];
    [dic setObject:nonce forKey:@"nonce"];
    [dic setObject:curTime forKey:@"curTime"];
    [dic setObject:checkSum forKey:@"checkSum"];
    [dic setObject:ticket forKey:@"ticket"];
    [dic setValue:self.orderNo forKey:@"orderNo"];
    
    
    DLog(@"取消订单dic == %@   orderNo ==== %@ " ,dic , self.orderNo  );
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/auth/order/cancel" , baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        DLog(@"取消订单===msg=  %@   returnData == %@" ,returnData[@"msg"] , returnData);
        
        if ([returnData[@"status"] integerValue] == 200)
        {
            ///取消订单 刷新数据
            [self requsetOrderDetailsData];
    
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:returnData[@"msg"]];
        }
        
    } failureBlock:^(NSError *error) {
        DLog(@"取消订单err0r=== %@  " ,error);
        [SVProgressHUD dismiss];
    } showHUD:NO];
    
}



#pragma mark =====确认收货


-(void)confirmOrderData{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *ticket = [user valueForKey:@"ticket"];
    NSString *secret = @"UHnyKzP5sNmh2EV0Dflgl4VfzbaWc4crQ7JElfw1cuNCbcJUau";
    NSString *nonce = [self ret32bitString];//随机数
    NSString *curTime = [self dateTransformToTimeSp];
    NSString *checkSum = [self sha1:[NSString stringWithFormat:@"%@%@%@" ,secret ,  nonce ,curTime]];
    
    [dic setObject:secret forKey:@"secret"];
    [dic setObject:nonce forKey:@"nonce"];
    [dic setObject:curTime forKey:@"curTime"];
    [dic setObject:checkSum forKey:@"checkSum"];
    [dic setObject:ticket forKey:@"ticket"];
    [dic setValue:self.orderNo forKey:@"orderNo"];
    
    
    DLog(@"确认收货dic == %@   orderNo ==== %@ " ,dic , self.orderNo  );
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/auth/order/confirm" , baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        DLog(@"确认收货===msg=  %@   returnData == %@" ,returnData[@"msg"] , returnData);
        
        if ([returnData[@"status"] integerValue] == 200)
        {
            ///取消订单 刷新数据
            [self requsetOrderDetailsData];
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:returnData[@"msg"]];
        }
        
    } failureBlock:^(NSError *error) {
        DLog(@"确认收货订单信息err0r=== %@  " ,error);
        [SVProgressHUD dismiss];
    } showHUD:NO];
    
}




-(void)leftBottomBtnAction:(UIButton *)btn
{
    if (btn.tag == 10 || btn.tag == 40) {
        DLog(@"取消订单");
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否取消订单" preferredStyle:1];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self requsetCancelOrderData];
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okAction];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
    
        
        
        
        
    }
    else if (btn.tag == 60)
    {
        [self confirmOrderData];
        DLog(@"确认收货");
    }
    
    
    
}


-(void)rightBottomBtnAction:(UIButton *)btn
{
    if (btn.tag == 10) {
        DLog(@"立即支付");
        SelectPayTypeViewController *VC = [SelectPayTypeViewController new];
        VC.orderNo = self.orderNo;
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    
}




/**
 *  获取当天的年月日的字符串
 *  这里测试用
 *  @return 格式为年-月-日
 */
-(NSString *)getyyyymmdd{
   
        NSDate *currentDate = [NSDate date];//获得当前时间为UTC时间 2014-07-16 07:54:36 UTC  (UTC时间比标准时间差8小时)
        //转为字符串
        NSDateFormatter*df = [[NSDateFormatter alloc]init];//实例化时间格式类
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//格式化
        //2014-07-16 07:54:36(NSString类)
        NSString *timeString = [df stringFromDate:currentDate];
        return timeString;
    
    
}


////日期转换为时间字符串
//- (NSString *)stringFromdate:(NSDate *)date {
//    //实例化一个NSDateFormatter对象
//    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
//    //设定时间格式,这里可以设置成自己需要的格式
//    [dateFormat setDateFormat:dateFormatDefine];
//    // 设置时间格式的时区 东八区 北京时间
//    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
//    return [dateFormat stringFromDate:date];
//}

-(void)setBottomViewFrames{
    
    if (self.status == 10)////待支付
    {
        [self.orderInfoBottomView.leftBottomBtn setTitle:@"取消订单" forState:0];
        [self.orderInfoBottomView.leftBottomBtn setTitleColor:RGB(236, 31, 35, 1) forState:0];

        
        OrderModel *model = [self.footViewOrderInfoMarray firstObject];

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date1 = [formatter dateFromString:model.createOrderTime];
        NSDate *date2 = [NSDate date];
        NSTimeInterval timeInterval = [date2 timeIntervalSinceDate:date1];
 
        ///10分钟
        DLog(@"sdfffffffffffffffff============ %f" ,timeInterval);

        timeInterval = 10*60 - timeInterval;
        if (timeInterval >0) {
            
            if (_timer==nil) {
                __block int timeout = timeInterval; //倒计时时间
                
                if (timeout!=0) {
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                    dispatch_source_set_event_handler(_timer, ^{
                        if(timeout<=0){ //倒计时结束，关闭
                            dispatch_source_cancel(_timer);
                            _timer = nil;
                            dispatch_async(dispatch_get_main_queue(), ^{
                             
                                //取消订单
                                [self requsetCancelOrderData];
                                
                            });
                        }else{
                            int days = (int)(timeout/(3600*24));
                            //                        if (days==0) {
                            //                            [self.orderInfoBottomView.rightBottomBtn setTitle:[NSString stringWithFormat:@"立即支付(%@)" ,@"等于0"] forState:0];
                            //                        }
                            int hours = (int)((timeout-days*24*3600)/3600);
                            int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                            int second = timeout-days*24*3600-hours*3600-minute*60;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (days==0) {
                                    if (hours == 0) {
                                        if (minute <=10&& second<10) {
                                            [self.orderInfoBottomView.rightBottomBtn setTitle:[NSString stringWithFormat:@"立即支付(0%d:0%d)" ,minute , second] forState:0];
                                            
                                            
                                        }else if (minute <=10&& second>10){
                                            [self.orderInfoBottomView.rightBottomBtn setTitle:[NSString stringWithFormat:@"立即支付(0%d:%d)" ,minute , second] forState:0];
                                            
                                        }
                                        
                                    }
                                    
                                    
                                }else{
                                   
                                }
                                
                                
                            });
                            timeout--;
                        }
                    });
                    dispatch_resume(_timer);
                }
            }

        }
        else
        {
            
            //取消订单
            [self requsetCancelOrderData];
        }
        
 
        
       // [self.orderInfoBottomView.rightBottomBtn setTitle:[NSString stringWithFormat:@"立即支付(%@)" ,@"12:34:24"] forState:0];
        self.orderInfoBottomView.rightBottomBtn.backgroundColor = RGB(236, 31, 35, 1);
        self.orderInfoBottomView.leftBottomBtn.tag = 10;
        self.orderInfoBottomView.rightBottomBtn.tag = 10;

        [self.orderInfoBottomView.leftBottomBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderInfoBottomView);
            make.height.equalTo(@44);
            make.width.equalTo(@(kWidth/2));
            make.bottom.equalTo(self.orderInfoBottomView.mas_bottom).with.offset(0);
        }];
        
        [self.orderInfoBottomView.rightBottomBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.orderInfoBottomView);
            make.height.equalTo(@44);
            make.width.equalTo(@(kWidth/2));
            make.bottom.equalTo(self.orderInfoBottomView.mas_bottom).with.offset(0);
        }];
        
        [self setTableViewFrames];
        

    }
    else  if (self.status == 50 || self.status == 40)///待发货(待确认)
    {
        [self.orderInfoBottomView.rightBottomBtn removeFromSuperview];
        [self.orderInfoBottomView.leftBottomBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.orderInfoBottomView);
            make.height.equalTo(@44);
            make.bottom.equalTo(self.orderInfoBottomView.mas_bottom).with.offset(0);
        }];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 1)];
        lineView.backgroundColor = RGB(238, 238, 238, 1);
        [self.orderInfoBottomView addSubview:lineView];
        [self.orderInfoBottomView.leftBottomBtn setTitle:@"取消订单" forState:0];
        [self.orderInfoBottomView.leftBottomBtn setTitleColor:RGB(236, 31, 35, 1) forState:0];
        self.orderInfoBottomView.leftBottomBtn.backgroundColor = [UIColor whiteColor];
        self.orderInfoBottomView.leftBottomBtn.tag = 40;

        
        [self setTableViewFrames];

    }
    else if (self.status == 60)///配送中
    {

        [self.orderInfoBottomView removeFromSuperview];
        [self resetTableViewFrames];

    }
    if (self.status == 70)
    {
                [self.orderInfoBottomView.rightBottomBtn removeFromSuperview];
                [self.orderInfoBottomView.leftBottomBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.view);
                    make.height.equalTo(@44);
                    make.bottom.equalTo(self.view.mas_bottom).with.offset(LL_TabbarSafeBottomMargin);
          }];
                [self.orderInfoBottomView.leftBottomBtn setTitle:@"确认收货" forState:0];
                [self.orderInfoBottomView.leftBottomBtn setTitleColor:RGB(236, 31, 35, 1) forState:0];
                self.orderInfoBottomView.leftBottomBtn.tag = 60;
        
                [self setTableViewFrames];
    }
    
    
    else if (self.status == 120)///待核验
    {
        [self.orderInfoBottomView removeFromSuperview];
        [self resetTableViewFrames];

    }
    else if (self.status == 140)///已退货
    {
        [self.orderInfoBottomView removeFromSuperview];
        [self resetTableViewFrames];

    }
    else if (self.status == 20)///取消退货
    {
        [self.orderInfoBottomView removeFromSuperview];
        [self resetTableViewFrames];

        
    }else if (self.status == 80)///已完成
    {
        [self.orderInfoBottomView removeFromSuperview];
        [self resetTableViewFrames];

    }
    else if (self.status == 0)///已取消
    {
        [self.orderInfoBottomView removeFromSuperview];
        [self resetTableViewFrames];
    }
    
    
}

-(void)resetTableViewFrames{
    CGRect rect = self.tableView.frame;
    rect.size.height = kHeight - kBarHeight - LL_TabbarSafeBottomMargin;
    self.tableView.frame = rect;
}

-(void)setTableViewFrames{
    CGRect rect = self.tableView.frame;
    rect.size.height = kHeight - kBarHeight - LL_TabbarSafeBottomMargin - 44;
    self.tableView.frame = rect;
    
}



-(ConfirmOrderInfoBottomView *)orderInfoBottomView{
    if (!_orderInfoBottomView) {
        _orderInfoBottomView = [ConfirmOrderInfoBottomView new];
        [self.view addSubview:self.orderInfoBottomView];
        [self.orderInfoBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.equalTo(@44);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-LL_TabbarSafeBottomMargin);
            
        }];
        [_orderInfoBottomView.leftBottomBtn addTarget:self action:@selector(leftBottomBtnAction:) forControlEvents:1];
        [_orderInfoBottomView.rightBottomBtn addTarget:self action:@selector(rightBottomBtnAction:) forControlEvents:1];

    }
    
    return _orderInfoBottomView;
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
    return self.productMarray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.footViewOrderInfoMarray.count != 0) {
        OrderModel *orderModel = [self.footViewOrderInfoMarray firstObject];
        
        
        CGSize strSize = [orderModel.orderComment boundingRectWithSize:CGSizeMake(kWidth-30, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f*kScale]} context:nil].size;
        

        return 282*kScale+strSize.height;
    }else{
    return 0;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    self.myOrderDetailsStatusHeadView = [[MyOrderDetailsStatusHeadView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 242+40)];
    self.myOrderDetailsStatusHeadView.backgroundColor = RGB(238, 238, 238, 1);
    
    if (self.headViewSendAddressMarray.count != 0) {
        MyAddressModel *addressModel = [self.headViewSendAddressMarray firstObject];
        OrderModel *orderModel = [self.footViewOrderInfoMarray firstObject];
        [self.myOrderDetailsStatusHeadView configAddressWithModel:addressModel orderModel:orderModel];
        
    }
  
    return self.myOrderDetailsStatusHeadView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 269+10;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
   
    self.myOrderDetailsStatusFootView = [[MyOrderDetailsStatusFootView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 269+10)];
    self.myOrderDetailsStatusFootView.backgroundColor = RGB(238, 238, 238, 1);
    if (self.footViewOrderInfoMarray.count != 0)
    {
        
        OrderModel *model = [self.footViewOrderInfoMarray firstObject];
       [self.myOrderDetailsStatusFootView configOrderDetailsFootViewWithModel:model];
    }
    
    
    return self.myOrderDetailsStatusFootView;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyOrderDetailsTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"MyOrderDetails_cell"];
    if (cell1 == nil) {
        cell1 = [[MyOrderDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyOrderDetails_cell"];
        
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
        cell1.backgroundColor = [UIColor whiteColor];
        
    }
    if (self.productMarray.count != 0) {
        OrderModel *model = self.productMarray[indexPath.row];
        [cell1 configCellWithModel:model];
    }
   
    
    return cell1;
}

#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //隐藏tabBar
    
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
