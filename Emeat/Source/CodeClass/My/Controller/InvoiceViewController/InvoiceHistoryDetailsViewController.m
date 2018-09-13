//
//  InvoiceHistoryDetailsViewController.m
//  
//
//  Created by liuheshun on 2018/6/26.
//

#import "InvoiceHistoryDetailsViewController.h"
#import "SelectInvoiceTypesReceiveAddressTableViewCell.h"
#import "SpecialInvoiceTableViewCell.h"
#import "InvoiceHistoryCheckOrderViewController.h"
#import "InvoiceDetailsModel.h"
@interface InvoiceHistoryDetailsViewController ()<UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *addressMarray;
@property (nonatomic,strong) NSMutableArray *invoiceInfoMarray;
///开票状态
@property (nonatomic,assign) NSInteger invoiceStated;

///发票拒绝原因
@property (nonatomic,strong) NSString *invoiceReason;

///发票包含的订单数量
@property (nonatomic,strong) NSString *orderCount;


@end

@implementation InvoiceHistoryDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    self.navItem.title = @"开票详情";
    self.addressMarray = [NSMutableArray array];
    self.invoiceInfoMarray = [NSMutableArray array];
    
    [self requestInvoiceHistoryDetails:self.invoiceId];
    
    [self requestInvoiceHistoryOrderCount:self.invoiceId];
    
}


#pragma mark===开票历史详情

-(void)requestInvoiceHistoryDetails:(NSString*)InvoiceHistoryDetailsId{
    
    NSDictionary *dic = [self checkoutData];
    [dic setValue:self.invoiceId forKey:@"invoiceId"];
    [dic setValue:mTypeIOS forKey:@"mtype"];

    
    
    [MHAsiNetworkHandler startMonitoring];
    [MHNetworkManager getRequstWithURL:[NSString stringWithFormat:@"%@/m/auth/appInvoice/queryInvoiceById" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
        if ([returnData[@"status"] integerValue] == 200) {
            if ([returnData[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                InvoiceDetailsModel *model = [InvoiceDetailsModel yy_modelWithJSON:returnData[@"data"]];

                NSString *string = model.invoiceReceiverAddress;
                
                NSArray *array = [string componentsSeparatedByString:@","];
                model.invoiceReceiverAddress = [array firstObject];
                model.invoiceReceiverDetailsAddress = [array lastObject];
                self.invoiceStated = model.invoiceStatus;
                self.invoiceReason = model.invoiceRefuseReason;
                ///
                [self.invoiceInfoMarray addObject:model];
                [self.view addSubview:self.tableView];
                
            }
            [self.tableView reloadData];

        }
        
        
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
    
    
}




#pragma mark===开票订单数量

-(void)requestInvoiceHistoryOrderCount:(NSString*)InvoiceHistoryDetailsId{
    
    NSDictionary *dic = [self checkoutData];
    [dic setValue:self.invoiceId forKey:@"invoiceId"];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    
    
    [MHAsiNetworkHandler startMonitoring];
    [MHNetworkManager getRequstWithURL:[NSString stringWithFormat:@"%@/m/auth/appInvoice/queryOrderNumByInoviceId" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
        if ([returnData[@"status"] integerValue] == 200) {
            
            self.orderCount = returnData[@"data"];
            [self.tableView reloadData];
        }
        
        //[self.tableView reloadData];
        
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
    
    
}



-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kBarHeight, kWidth, kHeight-kBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 160*kScale;
    }else if (indexPath.section ==1){
        return 410*kScale;
    }
    return 180*kScale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.invoiceStated == 43) {
            return 100*kScale;
        }else{
        return 75*kScale;
        }
    }
    return 30*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 75*kScale)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *invoiceStated = [[UILabel alloc] initWithFrame:CGRectMake(15*kScale, 0, kWidth-30*kScale, 45*kScale)];
        invoiceStated.font = [UIFont systemFontOfSize:15.0f*kScale];
//        WaitedTicket(41,"待开票"),
//        FinishedTicket(42,"已开票"),
//        RefusedTicket(43,"开票拒绝");
        if (self.invoiceStated == 41) {
            invoiceStated.text = @"纸质发票待开票";

        }else if (self.invoiceStated == 42){
            invoiceStated.text = @"纸质发票已开票";

        }else if (self.invoiceStated == 43){
            invoiceStated.text = @"纸质发票开票拒绝";
            
            UILabel *jujueReasonLab = [[UILabel alloc] initWithFrame:CGRectMake(15*kScale, MaxY(invoiceStated), kWidth-30*kScale, 35*kScale)];
            jujueReasonLab.text = self.invoiceReason;
            jujueReasonLab.font = [UIFont systemFontOfSize:12.0f*kScale];
            [view addSubview:jujueReasonLab];
        }
        
        [view addSubview:invoiceStated];
        
        UILabel *addressLab = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(invoiceStated), kWidth, 30*kScale)];
        addressLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        addressLab.textColor = RGB(136, 136, 136, 1);
        addressLab.backgroundColor = RGB(238, 238, 238, 1);

        addressLab.text = @"    接收信息";
        [view addSubview:addressLab];
        
        return view;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30*kScale)];
        view.backgroundColor = RGB(238, 238, 238, 1);
        UILabel *addressLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30*kScale)];
        addressLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        addressLab.textColor = RGB(136, 136, 136, 1);
        addressLab.text = @"    发票信息";
        [view addSubview:addressLab];
        return view;
    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 100*kScale;
    }
    return 0.1*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 80*kScale)];
        view.backgroundColor = RGB(238, 238, 238, 1);
        UILabel *invoiceCountLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 15*kScale, kWidth, 40*kScale)];
        invoiceCountLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        invoiceCountLab.backgroundColor = [UIColor whiteColor];
        invoiceCountLab.text = [NSString stringWithFormat:@"    1张发票,含%@个订单" ,self.orderCount];
        [view addSubview:invoiceCountLab];
        UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom ];
        checkBtn.frame = CGRectMake(kWidth -75*kScale, 15*kScale, 60*kScale, 40*kScale);
        checkBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        [checkBtn setTitle:@"查看" forState:0];
        [checkBtn setTitleColor:RGB(236, 31, 35, 1) forState:0];
        [view addSubview:checkBtn];
        [checkBtn addTarget:self action:@selector(checkBtnAction) forControlEvents:1];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kWidth-56*kScale, 44*kScale, 22*kScale, 1)];
        lineView.backgroundColor = RGB(236, 31, 35, 1);
        [view addSubview:lineView];
        
        UIButton *kfBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        kfBtn.frame = CGRectMake(0, MaxY(checkBtn), kWidth, 45*kScale);
        [kfBtn setTitle:@"客服热线: 4001 1001 1066" forState:0];
        [kfBtn setTitleColor:RGB(136, 136, 136, 1) forState:0];
        kfBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        [kfBtn addTarget:self action:@selector(kfBtnAction) forControlEvents:1];
        [view addSubview:kfBtn];
        
        
        return view;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 15*kScale)];
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}

#pragma mark ===客服
-(void)kfBtnAction{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4001106111"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];


}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        
        SpecialInvoiceTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"SpecialInvoiceTableViewCell"];
        if (cell1 == nil) {
            cell1 = [[SpecialInvoiceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SpecialInvoiceTableViewCell"];
            
            [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
            cell1.backgroundColor = [UIColor whiteColor];
            
        }
        if (self.invoiceInfoMarray.count !=0 ) {
            InvoiceDetailsModel *model = [self.invoiceInfoMarray firstObject];
            [cell1 configWithModel:model];
        }
        cell1.invoiceLookUpTextField.enabled = NO;
        cell1.enioTextField.enabled = NO;
        cell1.companyPhoneNumTextField.enabled = NO;
        cell1.companyAddressTextField.enabled = NO;
        cell1.bankTextField.enabled = NO;
        cell1.bankAccountTextField.enabled = NO;
        cell1.noteTextField.enabled = NO;
        cell1.lookUpType.font = [UIFont systemFontOfSize:12.0f*kScale];
        [cell1.lookUpTypeBtn1 setImage:[UIImage imageNamed:@""] forState:0];
        
        [cell1.lookUpTypeBtn1 setTitle:@"增值税专用发票" forState:0];

        return cell1;
    }
    SelectInvoiceTypesReceiveAddressTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"SelectInvoiceTypesReceiveAddressTableViewCell"];
    if (cell1 == nil) {
        cell1 = [[SelectInvoiceTypesReceiveAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectInvoiceTypesReceiveAddressTableViewCell"];
        
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
        cell1.backgroundColor = [UIColor whiteColor];
        
    }
    cell1.recerEmailLabel.hidden = YES;
    cell1.receiverEmailTextField.hidden = YES;
    cell1.sendFreeTextField.hidden = YES;
    cell1.sendFreeLabel.hidden = YES;
    UIView *lineView = [cell1 viewWithTag:3];
    [lineView removeFromSuperview];
    UIView *lineView1 = [cell1 viewWithTag:4];
    [lineView1 removeFromSuperview];

    cell1.receiverTextField.enabled = NO;
    cell1.receiverPhoneNumTextField.enabled = NO;
    cell1.receiverAddressTextField.enabled = NO;
    cell1.receiverDetailsAddressTextField.enabled = NO;

    
    if (self.invoiceInfoMarray.count !=0 ) {
        InvoiceDetailsModel *model = [self.invoiceInfoMarray firstObject];
        [cell1 configAddressCellWithModel:model];
    }
  
    
    return cell1;
}

#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //隐藏tabBar
    
}


#pragma mark = 查看发票订单

-(void)checkBtnAction{
    
    if (self.invoiceInfoMarray.count != 0) {
        
        InvoiceDetailsModel *model = [self.invoiceInfoMarray firstObject];
        
        InvoiceHistoryCheckOrderViewController  *Vc = [InvoiceHistoryCheckOrderViewController new];
        Vc.invoiceId = model.id;
        [self.navigationController pushViewController:Vc animated:YES];
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
