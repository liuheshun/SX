//
//  ConfirmOrderInfoViewController.m
//  Emeat
//
//  Created by liuheshun on 2017/11/9.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "ConfirmOrderInfoViewController.h"
#import "ConfirmOrderInfoTableViewCell.h"
#import "ConfirmOrderInfoFootView.h"
#import "ConfirmOrderInfoBottomView.h"
#import "ConfirmOrderCommentViewController.h"
#import "ConfirmOrderInfoAddressHeadView.h"
#import "SelectPayTypeViewController.h"
#import "MyAddressViewController.h"
@interface ConfirmOrderInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
//底部视图
@property (nonatomic,strong) ConfirmOrderInfoBottomView *bottomView;

///头部地址视图
@property (nonatomic,strong)  ConfirmOrderInfoAddressHeadView *headView;
///收货地址id
@property (nonatomic,strong) NSString *shoppingId;
///订单数据源

///订单备注
@property (nonatomic,strong) NSString *conmmentStr;


@end

@implementation ConfirmOrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    self.navItem.title = @"确认订单";
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:@"" forKey:@"conmmentString"];
 
    
}


//http://192.168.0.124:8080/order/get_order_cart_product?userId=7


#pragma mark = =创建订单(确认订单)
-(void)makeOrderData{
    if (self.shoppingId.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择您的收货地址"];

    }else{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *ticket = [user valueForKey:@"ticket"];
        NSString *secret = @"UHnyKzP5sNmh2EV0Dflgl4VfzbaWc4crQ7JElfw1cuNCbcJUau";
        NSString *nonce = [self ret32bitString];//随机数
        NSString *curTime = [self dateTransformToTimeSp];
        NSString *checkSum = [self sha1:[NSString stringWithFormat:@"%@%@%@" ,secret ,  nonce ,curTime]];
        
        [dic setValue:secret forKey:@"secret"];
        [dic setValue:nonce forKey:@"nonce"];
        [dic setValue:curTime forKey:@"curTime"];
        [dic setValue:checkSum forKey:@"checkSum"];
        [dic setValue:ticket forKey:@"ticket"];
        //[dic setValue :[user valueForKey:@"shoppingId"] forKey:@"shippingId"];
        [dic setValue:self.shoppingId forKey:@"shippingId"];
        [dic setValue:self.conmmentStr forKey:@"comment"];
        DLog(@"q确认订单信息 dic == %@" ,dic);
        
        [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/auth/order/create" , baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
            DLog(@"创建确认订单=== %@   %@" ,returnData[@"msg"] , returnData);
            
            if ([returnData[@"status"] integerValue] == 200) {
                NSString *orderNo =  returnData[@"data"][@"orderNo"];
                SelectPayTypeViewController *VC = [SelectPayTypeViewController new];
                VC.orderNo = orderNo;
                [self.navigationController pushViewController:VC animated:YES];
                
            }
            
        } failureBlock:^(NSError *error) {
            DLog(@"创建确认订单err0r=== %@  " ,error);
            
        } showHUD:NO];
        
    }
   
    
}




#pragma mark ====确认订单

-(void)rightBottomBtnAction{
   
        [self makeOrderData];
        NSLog(@"确认订单");
    
}

-(ConfirmOrderInfoBottomView*)bottomView{
    if (!_bottomView) {
        _bottomView = [[ConfirmOrderInfoBottomView alloc] initWithFrame:CGRectMake(0, kHeight-45 - LL_TabbarSafeBottomMargin, kWidth, 45)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_bottomView.rightBottomBtn addTarget:self action:@selector(rightBottomBtnAction) forControlEvents:1];
        
    
    }
    return _bottomView;
}

-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kBarHeight, kWidth, kHeight-kBarHeight-45-LL_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = RGB(238, 238, 238, 1);
    }
    return _tableView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3){
        return self.orderListMarray.count;
    }
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1){
        return 40;
    }else if (indexPath.section == 2){
        return 40;
    }else if (indexPath.section == 3){
        return 30;
    }
    return 65;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    view.backgroundColor = RGB(238, 238, 238, 1);
    if (section == 3) {
        view.backgroundColor = [UIColor whiteColor];

    }
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 3) {
        return 80;
    }
    return 0.1;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 3) {
        ConfirmOrderInfoFootView *view = [[ConfirmOrderInfoFootView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 80)];
        if (self.orderListMarray.count != 0) {
            ShoppingCartModel *model = [self.orderListMarray firstObject];
            [view configFootViewWithShoppingModel:model];
            
            [self.bottomView.rightBottomBtn setTitle:@"确认订单" forState:0];
            [self.bottomView.leftBottomBtn setTitle:[NSString stringWithFormat:@"需支付:¥ %@" ,model.productTotalPrice] forState:0];
        }
        view.backgroundColor = [UIColor whiteColor];
        return view;
        
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     if (indexPath.section == 3){
        
        ConfirmOrderInfoTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"orderInfo_cell1"];
        if (cell1 == nil) {
            cell1 = [[ConfirmOrderInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderInfo_cell1"];
            
            [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的
        }
         if (self.orderListMarray.count != 0) {
             ShoppingCartModel *model = self.orderListMarray[indexPath.row];
             [cell1 configWithShoppingModel:model];
         }
        
        return cell1;
         
    }else
    {
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"list_cell"];
        if (cell1 == nil) {
            cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"list_cell"];
            
            [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
            cell1.backgroundColor = [UIColor whiteColor];
            
        }
        if (indexPath.section == 0) {//我的收货地址
          
            [cell1 addSubview: self.headView];
            
//            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//            MyAddressModel *model = [MyAddressModel new];
//            model.receiverName = [user valueForKey:@"receiverName"];
//            model.receiverPhone = [[user valueForKey:@"receiverPhone"] integerValue];
//            model.receiverProvince = [user valueForKey:@"receiverProvince"];
//            model.receiverAddress = [user valueForKey:@"receiverAddress"];
//
//
//            if (model.receiverPhone) {
//                [self.headView configMyShippingAddressWithMyAddressModel:model];
//            }
            
            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        
        
        if (indexPath.section == 1) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            if ([[user valueForKey:@"conmmentString"] length] != 0 ) {
                self.conmmentStr = [user valueForKey:@"conmmentString"];
                cell1.textLabel.text =[ NSString stringWithFormat:@"订单备注:%@" ,self.conmmentStr] ;

            }else{
                cell1.textLabel.text = @"订单备注:";
                cell1.textLabel.textColor = RGB(51, 51, 51, 1);
            }
            
            cell1.backgroundColor = [UIColor whiteColor];
            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.section == 2){
            cell1.textLabel.text = @"商品清单";
            cell1.textLabel.textColor = RGB(51, 51, 51, 1);

            cell1.backgroundColor = [UIColor whiteColor];
            //        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        cell1.textLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
        
        return cell1;
    }
        
    
    
}

-(ConfirmOrderInfoAddressHeadView *)headView{
    if (!_headView) {
        _headView= [[ConfirmOrderInfoAddressHeadView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 65*kScale)];
    }
    return _headView;
}

#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld" ,indexPath.row);
    if (indexPath.section ==0) {
        
        
        MyAddressViewController *VC = [MyAddressViewController new];
        
        VC.myShippingAddressBlock = ^(MyAddressModel *model) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:model.receiverName forKey:@"receiverName"];
            [user setValue:[NSString stringWithFormat:@"%ld" ,model.receiverPhone] forKey:@"receiverPhone"];
            [user setValue:model.receiverProvince forKey:@"receiverProvince"];
            [user setValue:model.receiverAddress forKey:@"receiverAddress"];
            [user setValue:[NSString stringWithFormat:@"%ld" ,model.id] forKey:@"shoppingId"];
            
            [self.headView configMyShippingAddressWithMyAddressModel:model];
            
            self.shoppingId = [NSString stringWithFormat:@"%ld" ,model.id];
//            [user setValue:model forKey:@"myAddressModel"];

            DLog(@"收货地址ID=== %@" ,self.shoppingId);
        };
        VC.hidesBottomBarWhenPushed = YES;
        VC.fromConfirmVC = @"1";
        [self.navigationController pushViewController:VC animated:NO];
        
        NSLog(@"选择地址");
    }else if (indexPath.section == 1){
        ConfirmOrderCommentViewController *VC = [ConfirmOrderCommentViewController new];
        VC.conmmentStringBlcok = ^(NSString *conmmentStr) {
            DLog(@"订单备注---------== %@" ,conmmentStr);
            
            UITableViewCell *cell1 = [tableView cellForRowAtIndexPath:indexPath];
            
            cell1.textLabel.text =[ NSString stringWithFormat:@"订单备注:%@" ,conmmentStr] ;
            self.conmmentStr = conmmentStr;
        };
        VC.conmmentString = self.conmmentStr;
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    
   
    
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