//
//  InvoiceListViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/6/21.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "InvoiceListViewController.h"
#import "InvoiceListTableViewCell.h"
#import "InvoiceListBottomView.h"
#import "SelectInvoiceTypesViewController.h"
#import "InvoiceListModel.h"
#import "InvoiceDetailsModel.h"
#import "InvoiceHistoryViewController.h"

@interface InvoiceListViewController ()<UITableViewDelegate , UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) InvoiceListBottomView *bottomView;
@property (nonatomic,strong) NSMutableArray *invoiceListMarray;
@property (nonatomic,strong) NSMutableArray *invoiceImageListMarray;
///选中ID数组
@property (nonatomic,strong) NSMutableArray *idMarray ;
///所选订单字符串ID
@property (nonatomic,strong) NSString *selectOrderIdString;

///发票总金额
@property (nonatomic,strong) NSString *invoiceTotalPrice;

///保存要回显的发票信息
@property (nonatomic,strong) NSMutableArray *invoiceShowMarray;

@property (nonatomic,strong) NSMutableArray *secionMarray;


@end

@implementation InvoiceListViewController
{
    NSInteger totalPage;//分页
    NSInteger totalPageCount;//分页总数
    //是否全选
    BOOL isSelect;
    //已选的商品集合
    //NSMutableArray *selectGoods;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navItem.title = @"按订单开票";
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(50*kScale));
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-LL_TabbarSafeBottomMargin);
    }];
    
    self.invoiceListMarray = [NSMutableArray array];
    self.invoiceImageListMarray = [NSMutableArray array];
    self.idMarray = [NSMutableArray array];
    self.invoiceShowMarray = [NSMutableArray array];
    self.secionMarray = [NSMutableArray array];
    [self showNavBarItemRight];

}

-(void)viewWillAppear:(BOOL)animated{
    [self setupRefresh];
    self.bottomView.priceLabel.text = @"¥:0.00";
    [self.idMarray removeAllObjects];

}


- (void)setupRefresh{
    
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.tableView.mj_header  = header;
    header.lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
    //上拉加载
    //self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 加载旧的数据，加载旧的未显示的数据
        [self footerRereshing];
    }];
    
    
    
   // self.tableView.mj_footer.automaticallyHidden = YES;
}


- (void)headerRereshing{
    
    totalPage=1;
    [self requestListData:totalPage];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}


#pragma mark=====================上拉加载============================

- (void)footerRereshing{
    
    totalPage++;
    if (totalPage<=totalPageCount) {
        
        [self requestListData:totalPage];
        [self.tableView.mj_footer endRefreshing];
        
    }else{
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}





#pragma mark = 待开发票列表数据

-(void)requestListData:(NSInteger)currentPage{


    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [self checkoutData];
    [dic setValue:[user valueForKey:@"userId"] forKey:@"customerId"];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    [dic setValue:[NSString stringWithFormat:@"%ld" ,(long)currentPage] forKey:@"currentPage"];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];

    [MHAsiNetworkHandler startMonitoring];
    [MHNetworkManager getRequstWithURL:[NSString stringWithFormat:@"%@/m/auth/appInvoice/queryNoInvoiceOrders" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        

        if ([returnData[@"status"] integerValue] == 200) {
            
            if ([returnData[@"data"][@"list"] isKindOfClass:[NSArray class]]) {
                
                if ([returnData[@"data"][@"list"] count] == 0) {
                    
                     [[GlobalHelper shareInstance] emptyViewNoticeText:@"暂无已完成订单" NoticeImageString:@"wushangpin" viewWidth:50 viewHeight:54 UITableView:self.tableView isShowBottomBtn:NO bottomBtnTitle:@""];
                }else{
                    if (currentPage == 1) {
                        [self.invoiceListMarray removeAllObjects];
                        [self.invoiceImageListMarray removeAllObjects];

                    }
                    
                    NSInteger pages = [returnData[@"data"][@"page"][@"totalPage"] integerValue];
                    NSInteger pageSize = [returnData[@"data"][@"page"][@"pageSize"] integerValue];
                    NSInteger total = [returnData[@"data"][@"page"][@"totalRecords"] integerValue];

                    for (NSDictionary *dic in returnData[@"data"][@"list"]) {
                        
                        InvoiceListModel *firstModel = [InvoiceListModel yy_modelWithJSON:dic];
                        //1.截取字符串
                        
                        NSString *string = firstModel.createTime;
                        NSString *str1 = [string substringToIndex:7];//截取掉下标5之前的字符串
                       // NSLog(@"截取的值为：%@",str1);
                        NSString *str2 = [str1 substringFromIndex:5];//截取掉下标3之后的字符串
                        //NSLog(@"截取的值为：%@",str2);
                        
                        NSString *Id = dic[@"id"];
                        NSString *netPrice = dic[@"orderMoney"][@"netPrice"];
                        firstModel.Id = Id;
                        firstModel.netPrice = [netPrice integerValue];
//                        firstModel.checkStated = 0;
                        
                        firstModel.pages = pages;
                        firstModel.pageSize = pageSize;
                        firstModel.total = total;
                        firstModel.sectionString = str2;
                        [self.invoiceListMarray addObject:firstModel];
                        
                       
                        
                        NSMutableArray *Marray = [NSMutableArray array];
                        for (NSDictionary *dicDetails in dic[@"orderItem"]) {
                            
                            InvoiceListModel *model = [InvoiceListModel yy_modelWithJSON:dicDetails];
                            
                            NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.productImage componentsSeparatedByString:@","]];
                            
                            if (mainImvMarray.count!=0) {
                                model.productImage = [mainImvMarray firstObject];
                            }
                            
                            //model.pages = pages;
                            //model.pageSize = pageSize;
                            //model.total = total;
                            [Marray addObject:model.productImage];
                        }
                        [self.invoiceImageListMarray addObject:Marray];

                    }
                    
 
                    [[GlobalHelper shareInstance] removeEmptyView];
                    [self.tableView reloadData];
                //
                }
            }
          
        }
        
    
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
    
    
}


#pragma mark = 选择下一步开具发票
-(void)requestNextInvoiceInfoData:(NSString*)orderIdStr{
    NSDictionary *dic = [self checkoutData];
    [dic setValue:orderIdStr forKey:@"orderIdStr"];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];

    
    [MHAsiNetworkHandler startMonitoring];
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/appInvoice/transOidsAndRecInv" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {

        if ([returnData[@"status"] integerValue] == 200) {
            NSDictionary *dic = returnData[@"data"];
            
            if ([dic count]) {
                    [self.invoiceShowMarray removeAllObjects];
                    InvoiceDetailsModel *model = [InvoiceDetailsModel yy_modelWithJSON:returnData[@"data"]];
//                    model.invoiceAmount = self.invoiceTotalPrice;
                    [self.invoiceShowMarray addObject:model];
                    
                
               
            }
            
            SelectInvoiceTypesViewController *VC = [SelectInvoiceTypesViewController new];
            VC.invoiceShowMarray = self.invoiceShowMarray;
            VC.invoiceTotalPrices = self.invoiceTotalPrice;
            VC.invoiceIdString = self.selectOrderIdString;
            [self.navigationController pushViewController:VC animated:YES];
           
            
        }
  
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
    
    
}

#pragma mark ==计算发票金额
-(void)countTotalInvoicePrices{
    self.bottomView.priceLabel.text = [NSString stringWithFormat:@"%ld个订单,共%@元" ,self.idMarray.count ,self.invoiceTotalPrice];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.bottomView.priceLabel.text];
    NSRange range1 = [[str string] rangeOfString:[NSString stringWithFormat:@"%ld" ,self.idMarray.count]];
    [str addAttribute:NSForegroundColorAttributeName value:RGB(236, 31, 35, 1) range:range1];
    NSRange range2 = [[str string] rangeOfString:self.invoiceTotalPrice];
    [str addAttribute:NSForegroundColorAttributeName value:RGB(236, 31, 35, 1) range:range2];
    self.bottomView.priceLabel.attributedText = str;
    
}

#pragma mark = 选择要开发票的订单

-(void)requestSelectInvoiceData:(NSString*)orderIdStr{
   
    NSDictionary *dic = [self checkoutData];
    [dic setValue:orderIdStr forKey:@"orderIdStr"];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    
    [MHAsiNetworkHandler startMonitoring];
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/appInvoice/countMoney" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
      

        if ([returnData[@"status"] integerValue] == 200) {
           
            NSInteger invoiceTotalPrice = [returnData[@"data"] integerValue];
            self.invoiceTotalPrice = [NSString stringWithFormat:@"%.2f" ,(CGFloat)invoiceTotalPrice/100];
            [self countTotalInvoicePrices];
        }
        
        [self.tableView reloadData];
        
        
        
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
    
    
}


#pragma mark===全选请求

-(void)requestSelectAllOrder:(NSString*)string{
    
    NSDictionary *dic = [self checkoutData];
    [dic setValue:string forKey:@"checkNum"];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    [MHAsiNetworkHandler startMonitoring];
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/appInvoice/countAllMoney" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
        if ([returnData[@"status"] integerValue] == 200) {
            
            NSInteger invoiceTotalPrice = [returnData[@"data"] integerValue];
            self.invoiceTotalPrice = [NSString stringWithFormat:@"%.2f" ,(CGFloat)invoiceTotalPrice/100];
            
            [self countTotalInvoicePrices];
            
            if (self.idMarray.count !=0) {
                _bottomView.PayBtn.backgroundColor = RGB(236, 31, 35, 1);
                _bottomView.PayBtn.userInteractionEnabled = YES;
            }else{
                _bottomView.PayBtn.backgroundColor = RGB(220, 220, 220, 1);
                _bottomView.PayBtn.userInteractionEnabled = NO;
            }
            
            

        }
        
        [self.tableView reloadData];
        
        
        
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
    
    
}


#pragma mark ========全选按钮点击事件

-(void)invoiceSelectAllBtnClick:(UIButton*)button{
    
    if (self.invoiceListMarray.count != 0) {
        button.selected = !button.selected;
        isSelect = button.selected;
        if (isSelect)
        {
            [self.idMarray removeAllObjects];

            for (InvoiceListModel *model in self.invoiceListMarray) {
                model.checkStated = 1;
                [self.idMarray addObject:model.Id];
            }

            [self requestSelectAllOrder:@"1"];

            
        }else{
            for (InvoiceListModel *model in self.invoiceListMarray) {
                model.checkStated = 0;
            }
            [self requestSelectAllOrder:@"0"];
            [self.idMarray removeAllObjects];
        }
        
         [self.tableView reloadData];
    }
    
}

#pragma mark =下一步开具发票
-(void)nextBtnClick{
    if ([self.invoiceTotalPrice floatValue] == 0) {
        [SVProgressHUD showErrorWithStatus:@"开票金额需大于0元"];
    }else{
    [self requestNextInvoiceInfoData:self.selectOrderIdString];
    }
}


#pragma mark === 右边按钮开票历史点击事件
-(void)invoiceHistoryAction{

    InvoiceHistoryViewController *VC = [InvoiceHistoryViewController new];
    [self.navigationController pushViewController:VC animated:YES];
   
}

#pragma mark === 右边按钮客服点击事件

-(void)kefuAction{

    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4001106111"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}


#pragma mark === 创建一个右边按钮

-(void)showNavBarItemRight{

    UIButton *rightButton1 = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-90,0,30,30)];
    [rightButton1 setImage:[UIImage imageNamed:@"历史"]forState:UIControlStateNormal];
    
    [rightButton1 addTarget:self action:@selector(invoiceHistoryAction)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem1 = [[UIBarButtonItem alloc]initWithCustomView:rightButton1];
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-40,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"kefu"]forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(kefuAction)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navItem.rightBarButtonItems= @[rightItem1 ,rightItem ];
    
    
    
    
}





-(InvoiceListBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[InvoiceListBottomView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        [_bottomView.selectAll addTarget:self action:@selector(invoiceSelectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.PayBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _bottomView.PayBtn.userInteractionEnabled = NO;
        _bottomView.PayBtn.backgroundColor = RGB(220, 220, 220, 1);

    }
    return _bottomView;
}



-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kBarHeight, kWidth, kHeight-kBarHeight-50*kScale-LL_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
    return 140*kScale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1*kScale;
    }
    return 15*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30*kScale)];
    view.backgroundColor = RGB(238, 238, 238, 1);
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.1*kScale)];
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ///底部是否全选
    if (self.idMarray.count == self.invoiceListMarray.count) {
        self.bottomView.selectAll.selected = YES;
    }else{
        self.bottomView.selectAll.selected = NO;
    }
    
    
    if (self.invoiceImageListMarray.count != 0) {
        InvoiceTableCellConfig *orderConfig = [InvoiceTableCellConfig myOrderTableCellConfig];
        orderConfig.orderImvArray = self.invoiceImageListMarray[indexPath.section];

    }
    
    NSString *s = [NSString stringWithFormat:@"%ldcell",indexPath.section];
    InvoiceListTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:s];
    if (cell1 == nil) {
        cell1 = [[InvoiceListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:s];
        
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果

        cell1.backgroundColor = [UIColor whiteColor];
        
    }
    cell1.isSelected = isSelect;
    cell1.selectBtn.tag = indexPath.section;
    
    //选择回调
    cell1.cartBlock = ^(BOOL isSelec){
        if (isSelec) {
            
            InvoiceListModel *invoiceListModel = self.invoiceListMarray[indexPath.section];
            invoiceListModel.checkStated = 1;
            [self.idMarray addObject:invoiceListModel.Id];
            _bottomView.PayBtn.backgroundColor = RGB(236, 31, 35, 1);
            _bottomView.PayBtn.userInteractionEnabled = YES;
            
        }else{
#pragma mark ========取消选中发票
            
            InvoiceListModel *invoiceListModel = self.invoiceListMarray[indexPath.section];
            invoiceListModel.checkStated = 0;

            [self.idMarray removeObject:invoiceListModel.Id];
            if (self.idMarray.count == 0) {
                _bottomView.PayBtn.backgroundColor = RGB(220, 220, 220, 1);
                _bottomView.PayBtn.userInteractionEnabled = NO;
            }
            
            
        }
        self.selectOrderIdString = [self.idMarray componentsJoinedByString:@","];
        [self requestSelectInvoiceData:self.selectOrderIdString];

        
    };
    
   
    if (self.invoiceListMarray.count !=0) {
        InvoiceListModel *model = self.invoiceListMarray[indexPath.section];
        [cell1 configWithOrderModel:model];
        totalPageCount = model.pages;
    }
   

    return cell1;
}

#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //隐藏tabBar
    
    OrderDetailesViewController *VC = [OrderDetailesViewController new];
    InvoiceListModel *model = self.invoiceListMarray[indexPath.section];
    VC.orderNo = model.orderNo;
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
