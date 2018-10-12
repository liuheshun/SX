//
//  CareCenterTwoViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/9/19.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "CareCenterTwoViewController.h"

#import "HomePageViewController.h"
#import "AppDelegate.h"
#import "CardDescViewController.h"
#import "CardCenterVouchersTableViewCell.h"
#import "ConfirmOrderInfoViewController.h"

@interface CareCenterTwoViewController ()<UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

///使用说明
@property (nonatomic,strong) UIButton *cardDescBtn;
///卡券数据
@property (nonatomic,strong) NSMutableArray *cardMarray;

@property (nonatomic,strong) UIButton *selectedBtn;

//
@property (nonatomic,strong) NSString *fullTicketId;

@property (nonatomic,strong) UIButton *confirmBtn;


@end

@implementation CareCenterTwoViewController

-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    
    [self requsetCanUsedCardData];
    self.navItem.title = @"可用满减券";
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    [self.view addSubview:self.cardDescBtn];
    [self.view addSubview:self.confirmBtn];
    [self.view addSubview:self.tableView];
    self.cardMarray = [NSMutableArray array];
    
}


#pragma mark ============可选择的满减券列表


-(void)requsetCanUsedCardData{
    
    NSMutableDictionary *dic = [self checkoutData];
    [dic setValue:self.businessType forKey:@"businessType"];
    [dic setValue:self.ticketId forKey:@"ticketId"];
    DLog(@"可以使用的满减卡id ==%@" ,self.ticketId);

    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/ticket/selectFullReduction" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        DLog(@"可以使用的满减卡券数据 ==%@" ,returnData);
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
            [[GlobalHelper shareInstance] emptyViewNoticeText:@"啊哦, 暂时没有可用的卡券" NoticeImageString:@"无卡券" viewWidth:63*kScale viewHeight:63*kScale UITableView:self.tableView isShowBottomBtn:NO bottomBtnTitle:@""];
        }
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    } showHUD:NO];
    
}



#pragma mark ==========卡券使用说明

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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kBarHeight+40*kScale, kWidth, kHeight-kBarHeight-40*kScale-LL_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
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
    if (self.cardMarray.count != 0) {
        CardModel *model = self.cardMarray[indexPath.row];
        cell1.statusBtn.tag = indexPath.row+100;
        cell1.statusBtn.selected = NO;
        
        [cell1.statusBtn addTarget:self action:@selector(SelectCardAction:) forControlEvents:1];
        [cell1 configWithModel:model];
    }
    
    return cell1;
}


-(void)SelectCardAction:(UIButton*)btn{
    
    if (self.cardMarray.count != 0) {
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
        
        CardModel *model = self.cardMarray[btn.tag -100];
        self.fullTicketId =[NSString stringWithFormat:@"%ld" , model.cardId];
        
    }
    
    
    
}


#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}


-(UIButton *)confirmBtn{
    if (_confirmBtn == nil) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.frame = CGRectMake(kWidth-100*kScale, kStatusBarHeight, 80*kScale, 44);
        _confirmBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//        _confirmBtn.backgroundColor = RGB(231, 35, 36, 1);
        [_confirmBtn setTitleColor:RGB(51, 51, 51, 1) forState:0];
        [_confirmBtn setTitle:@"确认用券" forState:0];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
        [_confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:1];
    }
    return _confirmBtn;
}

#pragma mark ==========确认用券

-(void)confirmBtnAction{
   
    [self postCardData];
   
    
}




-(void)postCardData{
    
    NSMutableDictionary *dic = [self checkoutData];
    [dic setValue:self.businessType forKey:@"businessType"];
    
    if (self.ticketId.length == 0 && self.fullTicketId.length != 0) {
        [dic setValue:self.fullTicketId forKey:@"ticketId"];
    }else if (self.ticketId.length != 0 && self.fullTicketId.length == 0){
        [dic setValue:self.ticketId forKey:@"ticketId"];
    }else if (self.ticketId.length != 0 && self.fullTicketId.length != 0){
        [dic setValue:[NSString stringWithFormat:@"%@,%@" ,self.ticketId,self.fullTicketId] forKey:@"ticketId"];

    }else{
        
    }
    
    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/ticket/submitTicketIds" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        DLog(@"可以使用的满减卡券数据 ==%@" ,returnData);
        [SVProgressHUD show];
        
        if ([returnData[@"status"] integerValue] == 200){
            ///选择优惠券 返回确认订单页面
            NSString *tickets;
            if (self.ticketId.length == 0 && self.fullTicketId.length != 0) {
               
                tickets = self.fullTicketId;

            }else if (self.ticketId.length != 0 && self.fullTicketId.length == 0){
                
                tickets = self.ticketId;

            }else if (self.ticketId.length != 0 && self.fullTicketId.length != 0){
                tickets = [NSString stringWithFormat:@"%@,%@" ,self.ticketId ,self.fullTicketId];

            }else{
                
            }
            
            for(UIViewController *controller in self.navigationController.viewControllers) {
                
                if([controller isKindOfClass:[ConfirmOrderInfoViewController class]]) {
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    [user setValue:tickets forKey:@"ticketsCard"];
                    
                    [self.navigationController popToViewController:controller animated:YES];
                    
                }
                
            }
            
          
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
