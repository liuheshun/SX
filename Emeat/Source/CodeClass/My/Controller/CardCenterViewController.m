//
//  CardCenterViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/8/15.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "CardCenterViewController.h"
#import "CardCenterTableViewCell.h"
#import "HomePageViewController.h"
#import "AppDelegate.h"
#import "CardDescViewController.h"
@interface CardCenterViewController ()<UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

///使用说明
@property (nonatomic,strong) UIButton *cardDescBtn;
///卡券数据
@property (nonatomic,strong) NSMutableArray *cardMarray;



@end

@implementation CardCenterViewController

-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //[self receiveCardData];
    
    if ([self.isFromCardCenter isEqualToString:@"1"]) {
        [self requsetCardData];
        self.navItem.title = @"卡券中心";
    }else{
        [self requsetCanUsedCardData];
        self.navItem.title = @"可用卡券";

    }

}

-(void)viewWillDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    [self.view addSubview:self.cardDescBtn];
    [self.view addSubview:self.tableView];
    self.cardMarray = [NSMutableArray array];
    
}


-(void)requsetCardData{
    [SVProgressHUD show];
    NSMutableDictionary *dic = [self checkoutData];
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/ticket/get_card_ticket_center" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        DLog(@"卡券数据 ==%@" ,returnData);
        
        if ([returnData[@"status"] integerValue] == 200)
        {
            [[GlobalHelper shareInstance] removeEmptyView];
            [self.cardMarray removeAllObjects];
            for (NSDictionary *dic in returnData[@"data"]) {
                CardModel *model = [CardModel yy_modelWithJSON:dic];
                NSString *timeString = [self returnTimeStringWithTimeStamp:model.distributeEndTime];
                
                model.desc = dic[@"description"];
                model.cardId = [dic[@"id"] integerValue];
                
                model.distributeEndTime = timeString;
                [self.cardMarray addObject:model];
            }
        }else if ([returnData[@"status"] integerValue] == 201){
            [self.cardMarray removeAllObjects];
            [[GlobalHelper shareInstance] emptyViewNoticeText:@"啊哦, 暂时没有可用的代金券" NoticeImageString:@"无卡券" viewWidth:63*kScale viewHeight:63*kScale UITableView:self.tableView isShowBottomBtn:NO bottomBtnTitle:@""];
        }
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD dismiss];

    } showHUD:NO];
    
}


#pragma mark ============可使用卡券


-(void)requsetCanUsedCardData{
    [SVProgressHUD show];
    NSMutableDictionary *dic = [self checkoutData];
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/ticket/get_approve_ticket" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        DLog(@"可以使用的卡券数据 ==%@" ,returnData);
        
        if ([returnData[@"status"] integerValue] == 200)
        {
            [[GlobalHelper shareInstance] removeEmptyView];
            [self.cardMarray removeAllObjects];
            for (NSDictionary *dic in returnData[@"data"]) {
                CardModel *model = [CardModel yy_modelWithJSON:dic];
                NSString *timeString = [self returnTimeStringWithTimeStamp:model.distributeEndTime];
                
                model.desc = dic[@"description"];
                model.cardId = [dic[@"id"] integerValue];

                model.distributeEndTime = timeString;
                [self.cardMarray addObject:model];
            }
        }else if ([returnData[@"status"] integerValue] == 201){
            [self.cardMarray removeAllObjects];
            [[GlobalHelper shareInstance] emptyViewNoticeText:@"啊哦, 暂时没有可用的代金券" NoticeImageString:@"无卡券" viewWidth:63*kScale viewHeight:63*kScale UITableView:self.tableView isShowBottomBtn:NO bottomBtnTitle:@""];
        }
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD dismiss];

    } showHUD:NO];
    
}



//
//-(void)receiveCardData{
//
//    NSMutableDictionary *dic = [self checkoutData];
//    [dic setObject:@"1" forKey:@"ticketId"];
//    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/ticket/get_card_ticket" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
//        DLog(@"领取卡券 ==%@" ,returnData);
//
//    } failureBlock:^(NSError *error) {
//
//    } showHUD:NO];
//
//}
#pragma mark ==========代金券使用说明

-(void)cardDescBtnAction{
    CardDescViewController *VC = [CardDescViewController new];
    [self.navigationController pushViewController:VC animated:YES];
}


-(UIButton *)cardDescBtn{
    if (_cardDescBtn == nil) {
        _cardDescBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cardDescBtn.frame = CGRectMake(0, kBarHeight+10*kScale, kWidth, 29*kScale);
        _cardDescBtn.backgroundColor = [UIColor whiteColor];
        [_cardDescBtn setImage:[UIImage imageNamed:@"说明"] forState:0];
        [_cardDescBtn setTitle:@"代金券使用说明" forState:0];
        _cardDescBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _cardDescBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
        _cardDescBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 15*kScale, 0, 0);
        _cardDescBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20*kScale, 0, 0);
        [_cardDescBtn setTitleColor:RGB(51, 51, 51, 1) forState:0];
        UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        enterBtn.frame = CGRectMake((kWidth-40*kScale), 0, 30, 29);
        [enterBtn setImage:[UIImage imageNamed:@"进入"] forState:0];
        [_cardDescBtn addSubview:enterBtn];
        [_cardDescBtn addTarget:self action:@selector(cardDescBtnAction) forControlEvents:1];
        [enterBtn addTarget:self action:@selector(cardDescBtnAction) forControlEvents:1];
    }
    return _cardDescBtn;
}

-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kBarHeight+40*kScale, kWidth, kHeight-kBarHeight-40*kScale-LL_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
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
    return self.cardMarray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 142*kScale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 0.0001*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.0001*kScale)];
    view.backgroundColor = RGB(238, 238, 238, 1);
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.00001*kScale)];
    view.backgroundColor = RGB(238, 238, 238, 1);
    return view;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CardCenterTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"CardCenterTableViewCell"];
    if (cell1 == nil) {
        cell1 = [[CardCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CardCenterTableViewCell"];
        
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
        cell1.backgroundColor =  RGB(238, 238, 238, 1);
        
    }
    if (self.cardMarray.count != 0) {
        CardModel *model = self.cardMarray[indexPath.row];
        [cell1 configWithModel:model];
    }
    
    return cell1;
}

#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if ([self.isFromCardCenter isEqualToString:@"1"]) {
        
        CardModel *model = self.cardMarray[indexPath.row];
        if ([model.status isEqualToString:@"未使用"]) {
            self.tabBarController.selectedIndex = 0;
            [self.navigationController popToRootViewControllerAnimated:NO];
        }

        
    }else{
        
        ///选择优惠券 返回确认订单页面
         CardModel *model = self.cardMarray[indexPath.row];
        NSMutableArray *array = [NSMutableArray array];
        //[array addObject:[NSString stringWithFormat:@"%ld" ,model.cardId]];
        [array addObject:model];
        
        if ([self respondsToSelector:@selector(selectCardPrice)]) {
            
            self.selectCardPrice(array);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
        
        
        
        
        //[self selectCardGetOrderInfoDataWithTicketId:model.cardId CardPrices:9];
        
    }
   

}



-(void)selectCardGetOrderInfoDataWithTicketId:(NSInteger)ticketId CardPrices:(NSInteger)cardPrices{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    dic = [self checkoutData];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    [dic setValue:[NSString stringWithFormat:@"%ld" ,ticketId] forKey:@"ticketId"];
    
    
    DLog(@"获取订单信息 dic == %@" ,dic);
    NSMutableArray *orderListMarray = [NSMutableArray array];
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/order/get_order_cart_product" , baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        DLog(@"获取订单信息returnData == %@" ,returnData);
        NSMutableArray *cardMarray = [NSMutableArray array];
        if ([returnData[@"status"] integerValue] == 200)
        {
            
                
                CardModel *model = [CardModel yy_modelWithJSON:returnData[@"data"][@"ticket"]];
                model.productTotalPrice = returnData[@"data"][@"productTotalPrice"];
                model.cardId = [returnData[@"data"][@"ticket"][@"id"] integerValue];
                [cardMarray addObject:model];
    

            if ([self respondsToSelector:@selector(selectCardPrice)]) {
                
                self.selectCardPrice(cardMarray);
            }
            [self.navigationController popViewControllerAnimated:YES];
            
           
            
            
            
//
//            NSString *productTotalPrice = returnData[@"data"][@"productTotalPrice"];
//
//            for (NSMutableDictionary *dic in returnData[@"data"][@"orderItemVoList"]) {
//
//                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
//                model.productTotalPrice = productTotalPrice;
//                model.needTotalPrices = productTotalPrice;
//                [orderListMarray addObject:model];
//            }
//
//            [SVProgressHUD dismiss];
//            ConfirmOrderInfoViewController *VC = [ConfirmOrderInfoViewController new];
//            VC.hidesBottomBarWhenPushed = YES;
//            VC.orderListMarray = orderListMarray;
//            [self.navigationController pushViewController:VC animated:YES];
//            NSLog(@"去结算");
//            DLog(@"获取订单信息===msg=  %@   returnData == %@" ,returnData[@"msg"] , returnData);
 }
//        else
//        {
//            [SVProgressHUD showErrorWithStatus:returnData[@"msg"]];
//        }
    } failureBlock:^(NSError *error) {
        DLog(@"获取订单信息err0r=== %@  " ,error);
        
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
