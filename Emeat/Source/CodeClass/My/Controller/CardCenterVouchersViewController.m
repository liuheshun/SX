//
//  CardCenterVouchersViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/9/20.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "CardCenterVouchersViewController.h"

#import "HomePageViewController.h"
#import "AppDelegate.h"
#import "CardDescViewController.h"
#import "CardCenterVouchersTableViewCell.h"
#import "CareCenterTwoViewController.h"

@interface CardCenterVouchersViewController ()<UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

///使用说明
@property (nonatomic,strong) UIButton *cardDescBtn;
///代金券卡券数据
@property (nonatomic,strong) NSMutableArray *cardMarray;
///满减券卡券数据
@property (nonatomic,strong) NSMutableArray *cardFullMarray;


///下一步
@property (nonatomic,strong) UIButton *nextBtn;
///
@property (nonatomic,strong) UIButton *selectedBtn;
///所选代金券ID
@property (nonatomic,strong) NSString *ticketId;



@end

@implementation CardCenterVouchersViewController

-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.ticketId = @"";
    [self requsetCanUsedCardData];

}

-(void)viewWillDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    [self.view addSubview:self.cardDescBtn];
    [self.view addSubview:self.nextBtn];
    
    [self.view addSubview:self.tableView];
    self.cardMarray = [NSMutableArray array];
    self.cardFullMarray = [NSMutableArray array];
    
}


#pragma mark ============可选择的代金券列表


-(void)requsetCanUsedCardData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

    NSMutableDictionary *dic = [self checkoutData];
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];

    [dic setValue:self.businessType forKey:@"businessType"];
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/ticket/selectVoucher" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        DLog(@"可以使用的代金券卡券数据 ==%@" ,returnData);
        [SVProgressHUD show];
        
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
//            [[GlobalHelper shareInstance] emptyViewNoticeText:@"啊哦, 暂时没有可用的代金券" NoticeImageString:@"无卡券" viewWidth:63*kScale viewHeight:63*kScale UITableView:self.tableView isShowBottomBtn:NO bottomBtnTitle:@""];
        }
        
        [self requsetFullCanUsedCardData];

        [SVProgressHUD dismiss];
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    } showHUD:NO];
    
}



#pragma mark ============可选择的满减券列表


-(void)requsetFullCanUsedCardData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

    NSMutableDictionary *dic = [self checkoutData];
    [dic setValue:self.businessType forKey:@"businessType"];
    [dic setValue:self.ticketId forKey:@"ticketId"];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    DLog(@"可以使用的满减卡券数据id ==%@" ,self.ticketId);

    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/ticket/selectFullReduction" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        DLog(@"可以使用的满减卡券数据 ==%@" ,returnData);
        [SVProgressHUD show];
        
        if ([returnData[@"status"] integerValue] == 200)
        {
            //[[GlobalHelper shareInstance] removeEmptyView];
            [self.cardFullMarray removeAllObjects];
            for (NSDictionary *dic in returnData[@"data"]) {
                CardModel *model = [CardModel yy_modelWithJSON:dic];
                NSString *timeString = [self returnTimeStringWithTimeStamp:model.distributeEndTime];
                
                model.desc = dic[@"description"];
                model.cardId = [dic[@"id"] integerValue];
                
                model.distributeEndTime = timeString;
                [self.cardFullMarray addObject:model];
            }
          
            
        }else if ([returnData[@"status"] integerValue] == 201){
            
            [self.cardFullMarray removeAllObjects];
            
            

        }

        if (self.cardFullMarray.count == 0 && self.cardMarray.count == 0) {
            
            [[GlobalHelper shareInstance] emptyViewNoticeText:@"啊哦, 暂时没有可用的卡券" NoticeImageString:@"无卡券" viewWidth:63*kScale viewHeight:63*kScale UITableView:self.tableView isShowBottomBtn:NO bottomBtnTitle:@""];
//            self.navItem.title = @"可用代金券";
            self.navItem.title = @"可用卡券";

            [self.nextBtn removeFromSuperview];
            //[self.nextBtn setTitle:@"确认用券" forState:0];
       
        }else if (self.cardMarray.count == 0 && self.cardFullMarray.count !=0){
            
//            self.navItem.title = @"可用满减券";
            self.navItem.title = @"可用卡券";

            [self.nextBtn setTitle:@"确认用券" forState:0];

            
        }else if (self.cardMarray.count != 0 && self.cardFullMarray.count ==0){
            
//            self.navItem.title = @"可用代金券";
            self.navItem.title = @"可用卡券";

            [self.nextBtn setTitle:@"确认用券" forState:0];
            
            
        }else{
//            self.navItem.title = @"可用代金券";
            self.navItem.title = @"可用卡券";

        }
        if (self.cardMarray.count == 0) {
            
        }
        
        
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    } showHUD:NO];
    
}


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
        [_cardDescBtn setTitle:@"卡券使用说明" forState:0];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kBarHeight+40*kScale, kWidth, kHeight-kBarHeight-40*kScale-44-LL_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = RGB(238, 238, 238, 1);
    }
    return _tableView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.cardMarray.count== 0 && self.cardFullMarray.count != 0) {
        return self.cardFullMarray.count;
    }
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
    
    NSString *Identifier = [NSString stringWithFormat:@"cell_%ld" ,indexPath.row];
    
    CardCenterVouchersTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell1 == nil) {
        cell1 = [[CardCenterVouchersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
        cell1.backgroundColor =  RGB(238, 238, 238, 1);
        
    }
    
    if (self.cardMarray.count== 0 && self.cardFullMarray.count != 0) {
        
        if (self.cardFullMarray.count != 0) {
            CardModel *model = self.cardFullMarray[indexPath.row];
            cell1.statusBtn.tag = indexPath.row+100;
            cell1.statusBtn.selected = NO;
            
            [cell1.statusBtn addTarget:self action:@selector(SelectCardAction:) forControlEvents:1];
            [cell1 configWithModel:model];
        }
        
    }else{
    
        if (self.cardMarray.count != 0) {
            CardModel *model = self.cardMarray[indexPath.row];
            cell1.statusBtn.tag = indexPath.row+100;
            cell1.statusBtn.selected = NO;
            
            [cell1.statusBtn addTarget:self action:@selector(SelectCardAction:) forControlEvents:1];
            [cell1 configWithModel:model];
        }
   
    
    }
    return cell1;
}


-(void)SelectCardAction:(UIButton*)btn{
    
    
    if (self.cardMarray.count== 0 && self.cardFullMarray.count != 0) {
        
        
        if (self.cardFullMarray.count != 0) {
            if (btn!= self.selectedBtn) {
                self.selectedBtn.selected = NO;
                btn.selected = YES;
                self.selectedBtn = btn;
            }else{
                if (btn.selected == YES) {
                    btn.selected = NO;
                    
                }else{
                    self.selectedBtn.selected = YES;
                }
                
            }
            
            CardModel *model = self.cardFullMarray[btn.tag -100];
            self.ticketId = [NSString stringWithFormat:@"%ld" ,model.cardId];
            
        }
        
        
    }else{
       
        if (self.cardMarray.count != 0) {
            if (btn!= self.selectedBtn) {
                self.selectedBtn.selected = NO;
                btn.selected = YES;
                self.selectedBtn = btn;
                CardModel *model = self.cardMarray[btn.tag -100];
                self.ticketId = [NSString stringWithFormat:@"%ld" ,model.cardId];
            }else{
                if (btn.selected == YES) {
                    btn.selected = NO;
                    self.ticketId = nil;
                }else{
                    self.selectedBtn.selected = YES;
                    CardModel *model = self.cardMarray[btn.tag -100];
                    self.ticketId = [NSString stringWithFormat:@"%ld" ,model.cardId];
                }
                
            }
            
           
            
        }
    }
    
   
    
  


}


#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
}


-(UIButton *)nextBtn{
    if (_nextBtn == nil) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.frame = CGRectMake(0, kHeight-44-LL_TabbarSafeBottomMargin, kWidth, 44);
        _nextBtn.backgroundColor = RGB(231, 35, 36, 1);
        [_nextBtn setTitle:@"下一步" forState:0];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        [_nextBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:1];
    }
    return _nextBtn;
}

#pragma mark ===========下一步 或确认用券
-(void)nextBtnAction{
    
    
    if (self.cardFullMarray.count == 0 && self.cardMarray.count != 0) {///没有满减券
        
        [self postCardData];
        
        
    }else if (self.cardMarray.count== 0 && self.cardFullMarray.count != 0) {
        
        [self postCardData];
        
    }else if (self.cardMarray.count== 0 && self.cardFullMarray.count == 0) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        [self requsetAgainFullCanUsedCardData];
        
       
    }
  
    
    
}



-(void)requsetAgainFullCanUsedCardData{
    
    NSMutableDictionary *dic = [self checkoutData];
    [dic setValue:self.businessType forKey:@"businessType"];
    [dic setValue:self.ticketId forKey:@"ticketId"];
    DLog(@"again可以使用的满减卡券数据id ==%@" ,self.ticketId);
    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/ticket/selectFullReduction" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        DLog(@"again可以使用的满减卡券数据 ==%@" ,returnData);
        [SVProgressHUD show];
        
        if ([returnData[@"status"] integerValue] == 200)
        {
         
            CareCenterTwoViewController *VC = [CareCenterTwoViewController new];
            VC.businessType = self.businessType;
            VC.ticketId = self.ticketId;
            
            [self.navigationController pushViewController:VC animated:YES];
            
            
        }else if ([returnData[@"status"] integerValue] == 201){
            
            [self postCardData];

            
        }
        
        
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    } showHUD:NO];
    
}


#pragma makr===========确认用券
-(void)postCardData{
    
    NSMutableDictionary *dic = [self checkoutData];
    [dic setValue:self.businessType forKey:@"businessType"];
    [dic setValue:[NSString stringWithFormat:@"%@" ,self.ticketId] forKey:@"ticketId"];
    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/ticket/submitTicketIds" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        DLog(@"可以使用的满减卡券数据 ==%@" ,returnData);
        [SVProgressHUD show];
        
        if ([returnData[@"status"] integerValue] == 200){
            ///选择优惠券 返回确认订单页面
            
            
            NSString *tickets = [NSString stringWithFormat:@"%@" ,self.ticketId ];
            
//            if ([self respondsToSelector:@selector(selectCardPrice)]) {
//
//                self.selectCardPrice(tickets);
//            }
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:tickets forKey:@"ticketsCard"];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }else if ([returnData[@"status"] integerValue] == 201){
            
        }
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    } showHUD:NO];
    
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
