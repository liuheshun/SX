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

#import "MMMyCustomView.h"
#import "SliceService ViewController.h"


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
///所选切片服务服务类型
@property (nonatomic,strong) NSString *serviceType;
///所选切片名字服务服务
@property (nonatomic,strong) NSString *serviceName;


///所选切片服务费用
@property (nonatomic,strong) NSString *slicePrices;


@end

@implementation ConfirmOrderInfoViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self setBottomViewFrame];
    self.navItem.title = @"确认订单";
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:@"" forKey:@"conmmentString"];
    
    self.serviceName = @"不需要分切";
    self.serviceType = @"NO_SERVICE";
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    MMAlertViewConfig1 *alertConfig = [MMAlertViewConfig1 globalConfig1];
    alertConfig.defaultTextOK = @"确定";
    alertConfig.defaultTextCancel = @"取消";
    alertConfig.titleFontSize = 17*kScale;
    alertConfig.detailFontSize = 13*kScale;
    alertConfig.buttonFontSize = 15*kScale;
    alertConfig.buttonHeight = 40*kScale;
    alertConfig.width = 315*kScale;
    alertConfig.buttonBackgroundColor = [UIColor redColor];
    alertConfig.detailColor = RGB(136, 136, 136, 1);
    alertConfig.itemNormalColor = [UIColor whiteColor];

    alertConfig.splitColor = [UIColor whiteColor];
    
    
}






#pragma mark = =创建订单(确认订单)
-(void)makeOrderData{
    if (self.shoppingId.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择您的收货地址"];

    }else{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic = [self checkoutData];

        //[dic setValue :[user valueForKey:@"shoppingId"] forKey:@"shippingId"];
        [dic setValue:self.shoppingId forKey:@"shippingId"];
        [dic setValue:self.conmmentStr forKey:@"comment"];
        [dic setValue:mTypeIOS forKey:@"mtype"];
        [dic setValue:self.serviceType forKey:@"serviceType"];
        DLog(@"q确认订单信息 dic == %@" ,dic);
        
        [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/order/create" , baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
            DLog(@"创建确认订单=== %@   %@" ,returnData[@"msg"] , returnData);
            
            if ([returnData[@"status"] integerValue] == 200) {
                NSString *orderNo =  returnData[@"data"][@"orderNo"];
                NSInteger periodic = [returnData[@"data"][@"periodic"] integerValue];
                
                SelectPayTypeViewController *VC = [SelectPayTypeViewController new];
                VC.orderNo = orderNo;
                VC.periodic = periodic;
                VC.fromVC = @"1";
                [self.navigationController pushViewController:VC animated:YES];
                
            }else{
               

                MMMyCustomView *alertView = [[MMMyCustomView alloc] initWithConfirmTitle:@"认证提示" detail:@"您的店铺还未通过认证，请耐心等待工作人员与您联系，客服热线 4001106111。"];
                alertView.attachedView.mm_dimBackgroundBlurEnabled = NO;
                alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
                [alertView show];
                
//                MMPopupCompletionBlock completeBlock = ^(MMPopupView *popupView, BOOL finished){
//                    NSLog(@"animation complete");
//                    
//                };
//                MMPopupItemHandler block = ^(NSInteger index){
//                    NSLog(@"clickd %@ button",@(index));
//                };
//                NSArray *items =
//                @[MMItemMake(@"Done", MMItemTypeNormal, block),
//                  MMItemMake(@"Cancel", MMItemTypeNormal, block)];
//                MMMyCustomView *alertView =  [[MMMyCustomView alloc] initWithTitle:@"sss" detail:@"gsfesfs" items:items];
//                alertView.attachedView.mm_dimBackgroundBlurEnabled = NO;
//                alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
//                [alertView show];
                

            }
            
        } failureBlock:^(NSError *error) {
            DLog(@"创建确认订单err0r=== %@  " ,error);
            
        } showHUD:NO];
        
    }
   
    
}




#pragma mark ====确认订单

-(void)rightBottomBtnAction{
    self.bottomView.rightBottomBtn.enabled = NO;
    [self performSelector:@selector(changeButtonStatus) withObject:nil afterDelay:1.5f];//防止用户重复点击
    [self makeOrderData];
        NSLog(@"确认订单");
    
}
-(void)changeButtonStatus{
    self.bottomView.rightBottomBtn.enabled = YES;
}
#pragma mark = 底部视图

-(ConfirmOrderInfoBottomView*)bottomView{
    if (!_bottomView) {
        _bottomView = [[ConfirmOrderInfoBottomView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_bottomView.rightBottomBtn addTarget:self action:@selector(rightBottomBtnAction) forControlEvents:1];
    
    }
    return _bottomView;
}

-(void)setBottomViewFrame{
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@45);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-LL_TabbarSafeBottomMargin);
    }];
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
    
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 4){
        return self.orderListMarray.count;
    }
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1){
        return 40*kScale;
    }else if (indexPath.section == 2){
        return 40*kScale;
    }else if (indexPath.section == 3){
        return 40*kScale;
    }else if (indexPath.section == 4){
        return 30*kScale;
    }
    return 65*kScale;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 10*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 10*kScale)];
    view.backgroundColor = RGB(238, 238, 238, 1);
    if (section == 4) {
        view.backgroundColor = [UIColor whiteColor];

    }
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 4) {
        return 120*kScale;
    }
    return 0.1;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 4) {
        ConfirmOrderInfoFootView *view = [[ConfirmOrderInfoFootView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 80*kScale)];
        if (self.orderListMarray.count != 0) {
            ShoppingCartModel *model = [self.orderListMarray firstObject];
            model.slicePrices = self.slicePrices;
            [view configFootViewWithShoppingModel:model];
            
            [self.bottomView.rightBottomBtn setTitle:@"确认订单" forState:0];
            [self.bottomView.leftBottomBtn setTitle:[NSString stringWithFormat:@"需支付:¥ %@" ,model.needTotalPrices] forState:0];
        }
        view.backgroundColor = [UIColor whiteColor];
        return view;
        
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 10*kScale)];
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     if (indexPath.section == 4){
        
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
         
    }else{
        NSString *s = [NSString stringWithFormat:@"%ld_listcell" ,indexPath.section];
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:s];
        if (cell1 == nil) {
            cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:s];
            
            [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
            cell1.backgroundColor = [UIColor whiteColor];
            
        }
        if (indexPath.section == 0) {//我的收货地址
          
            [cell1 addSubview: self.headView];
            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.section == 1) {

          cell1.textLabel.text = [NSString stringWithFormat:@"切片服务:%@" ,self.serviceName];
                cell1.textLabel.textColor = RGB(51, 51, 51, 1);
            cell1.backgroundColor = [UIColor whiteColor];
            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.section == 2) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            if ([[user valueForKey:@"conmmentString"] length] != 0 ) {
                self.conmmentStr = [user valueForKey:@"conmmentString"];
                cell1.textLabel.text = [ NSString stringWithFormat:@"订单备注:%@" ,self.conmmentStr] ;

            }else{
                cell1.textLabel.text = @"订单备注:";
                cell1.textLabel.textColor = RGB(51, 51, 51, 1);
            }
            
            cell1.backgroundColor = [UIColor whiteColor];
            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.section == 3){
            cell1.textLabel.text = @"商品清单";
            cell1.textLabel.textColor = RGB(51, 51, 51, 1);

            cell1.backgroundColor = [UIColor whiteColor];
            
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
    } else if (indexPath.section == 1){
        SliceService_ViewController *VC = [SliceService_ViewController new];
        __weak __typeof(self) weakSelf = self;

        VC.returnSelectSliceBlock = ^(NSString *SliceStr, NSString *serviceType, NSString *slicePices, NSString *totalPrice) {
            
        
            
            
            DLog(@"所选服务---------== %@" ,totalPrice);
            
            ShoppingCartModel *model = [self.orderListMarray firstObject];
            
            model.needTotalPrices = [NSString stringWithFormat:@"%.2f" ,(CGFloat) [totalPrice integerValue]/100] ;
//            [self.orderListMarray removeAllObjects];
//            [self.orderListMarray addObject:model];
//
            weakSelf.serviceName = SliceStr;
            weakSelf.serviceType = serviceType;
            weakSelf.slicePrices = slicePices;
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    
    
    else if (indexPath.section == 2){
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
