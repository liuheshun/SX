//
//  InvoiceHistoryViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/6/26.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "InvoiceHistoryViewController.h"
#import "InvoiceHistoryTableViewCell.h"
#import "InvoiceHistoryDetailsViewController.h"
#import "InvoiceDetailsModel.h"
@interface InvoiceHistoryViewController ()<UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *invoiceHistoryMarray;

@end

@implementation InvoiceHistoryViewController
{
    NSInteger totalPage;//分页
    NSInteger totalPageCount;//分页总数
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navItem.title = @"开票历史";
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    [self.view addSubview:self.tableView];
    self.invoiceHistoryMarray = [NSMutableArray array];
    [self setupRefresh];
    
}


- (void)setupRefresh{
    
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.tableView.mj_header  = header;
    header.lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
    //上拉加载
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 加载旧的数据，加载旧的未显示的数据
        [self footerRereshing];
    }];
    
}


- (void)headerRereshing{
    
    totalPage=1;
    [self requestInvoiceHistory:totalPage];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}


#pragma mark=====================上拉加载============================

- (void)footerRereshing{
    
    totalPage++;
    if (totalPage<=totalPageCount) {
        
        [self requestInvoiceHistory:totalPage];
        [self.tableView.mj_footer endRefreshing];
        
    }else{
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}



#pragma mark===开票历史数据

-(void)requestInvoiceHistory:(NSInteger)currentPage{
    
    NSDictionary *dic = [self checkoutData];
    [dic setValue:[NSString stringWithFormat:@"%ld" , currentPage] forKey:@"currentPage"];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    DLog(@"开票历史数据== %@" ,dic );
    [MHAsiNetworkHandler startMonitoring];
    [MHNetworkManager getRequstWithURL:[NSString stringWithFormat:@"%@/m/auth/appInvoice/queryInvoices" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
        if ([returnData[@"status"] integerValue] == 200) {
            
            NSInteger pages = [returnData[@"data"][@"page"][@"totalPage"] integerValue];
            NSInteger pageSize = [returnData[@"data"][@"page"][@"pageSize"] integerValue];
            NSInteger total = [returnData[@"data"][@"page"][@"totalRecords"] integerValue];

            if ([returnData[@"data"][@"list"] isKindOfClass:[NSArray class]]) {
                if (currentPage == 1) {
                    [self.invoiceHistoryMarray removeAllObjects];
                }
                
                
                
                NSArray *arr = returnData[@"data"][@"list"];
                
                if (arr.count !=0) {
                    for (NSDictionary *dic in returnData[@"data"][@"list"]) {
                        
                        InvoiceDetailsModel *model = [InvoiceDetailsModel yy_modelWithJSON:dic];
                        model.pages = pages;
                        model.pageSize = pageSize;
                        model.total = total;
                        [self.invoiceHistoryMarray addObject:model];
                    }
                    
                     [[GlobalHelper shareInstance] removeEmptyView];
                }else{//空状态
                    
                     [[GlobalHelper shareInstance] emptyViewNoticeText:@"暂无开票订单" NoticeImageString:@"wushangpin" viewWidth:50 viewHeight:54 UITableView:self.tableView isShowBottomBtn:NO bottomBtnTitle:@""];
                }
    
                
            }
          
        }
        
        [self.tableView reloadData];
        
        DLog(@"开票历史数据== jeikou == %@ " ,returnData);
        
        
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
    
    
}







-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kBarHeight, kWidth, kHeight-kBarHeight-LL_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.invoiceHistoryMarray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105*kScale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  
    UILabel*monthLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30*kScale)];
    monthLab.textColor = RGB(136, 136, 136, 1);
    monthLab.backgroundColor = RGB(238, 238, 238, 1);
    monthLab.textAlignment = NSTextAlignmentLeft;
    monthLab.font = [UIFont systemFontOfSize:12*kScale];
//    monthLab.text = @"    6月";
    return monthLab;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.1*kScale)];
    view.backgroundColor = RGB(238, 238, 238, 1);
    
    return view;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    InvoiceHistoryTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"InvoiceHistoryTableViewCell"];
    if (cell1 == nil) {
        cell1 = [[InvoiceHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InvoiceHistoryTableViewCell"];
        
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell1.backgroundColor = [UIColor whiteColor];
    }
    
    if (self.invoiceHistoryMarray.count != 0) {
        InvoiceDetailsModel *model = self.invoiceHistoryMarray[indexPath.row];
        totalPageCount = model.pages;
        [cell1 configCell:model];
    }
    

    
    return cell1;
}

#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //隐藏tabBar
    if (self.invoiceHistoryMarray.count!=0) {
        InvoiceDetailsModel *model = self.invoiceHistoryMarray[indexPath.row];
        
        InvoiceHistoryDetailsViewController *VC = [InvoiceHistoryDetailsViewController new];
        VC.invoiceId = model.id;
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
