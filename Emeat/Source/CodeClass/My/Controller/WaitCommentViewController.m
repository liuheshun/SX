//
//  WaitCommentViewController.m
//  Emeat
//
//  Created by liuheshun on 2017/12/13.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "WaitCommentViewController.h"
#import "MyOrderTableViewCell.h"

@interface WaitCommentViewController ()<UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *orderListMarray;
@property (nonatomic,strong) NSMutableArray *orderImvArray;


@end

@implementation WaitCommentViewController
{
    NSInteger totalPage;//分页
    NSInteger totalPageCount;//分页总数
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    [self.view addSubview:self.tableView];
    self.orderListMarray = [NSMutableArray array];
    self.orderImvArray = [NSMutableArray array];
    [self setupRefresh];

}

-(void)viewWillAppear:(BOOL)animated{
    totalPage = 1;
    [self.tableView.mj_footer endRefreshing];
    
    [self requsetCommentsOrderDataWithTotalPage:totalPage];

}

- (void)setupRefresh{
    
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.tableView.mj_header  = header;
    header.lastUpdatedTimeLabel.hidden = YES;
    // [self.tableView.mj_header beginRefreshing];
    //上拉加载
    //    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    //    self.tableView.mj_footer.automaticallyHidden = YES;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 加载旧的数据，加载旧的未显示的数据
        [self footerRereshing];
    }];
    
}


- (void)headerRereshing{
    
    totalPage=1;
    [self requsetCommentsOrderDataWithTotalPage:totalPage];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}


#pragma mark=====================上拉加载============================

- (void)footerRereshing{
    
    totalPage++;
    if (totalPage<=totalPageCount) {
        
        [self requsetCommentsOrderDataWithTotalPage:totalPage];
        [self.tableView.mj_footer endRefreshing];
        
    }else{
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}



-(void)requsetCommentsOrderDataWithTotalPage:(NSInteger)totalPage{
    //http://beta.cyberfresh.cn/m/auth/order/query_no_evaluation
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic = [self checkoutData];
    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/order/query_no_evaluation?currentPage=%ld",baseUrl ,totalPage] params:dic successBlock:^(NSDictionary *returnData) {
        
        DLog(@"待评价订单====%@" ,returnData);
        
        NSInteger pages = [returnData[@"data"][@"pages"] integerValue];
        NSInteger pageSize = [returnData[@"data"][@"pageSize"] integerValue];
        NSInteger total = [returnData[@"data"][@"total"] integerValue];
        
        if ([returnData[@"status"] integerValue] == 200)
        {
            if (totalPage == 1) {
                [self.orderListMarray removeAllObjects];
                [self.orderImvArray removeAllObjects];
            }
            for (NSMutableDictionary *dic in returnData[@"data"][@"list"])
            {
                OrderModel *firstModel = [OrderModel yy_modelWithJSON:dic];
                firstModel.pages = pages;
                firstModel.pageSize = pageSize;
                firstModel.total = total;
                [self.orderListMarray addObject:firstModel];
                
                NSMutableArray *array  = [NSMutableArray array];
                
                for (NSMutableDictionary *dic2 in dic[@"orderItemVoList"]) {
                    
                    OrderModel *model = [OrderModel yy_modelWithJSON:dic2];
                    model.productImage = dic2[@"productImage"];
                    model.productImage = [[NSMutableArray arrayWithArray:[model.productImage componentsSeparatedByString:@","]] firstObject];
                    
                    
                    [array addObject: model.productImage];
                    
                }
                [self.orderImvArray addObject:array];
                
            }
            if (self.orderImvArray.count == 0) {
                [[GlobalHelper shareInstance] emptyViewNoticeText:@"暂无订单" NoticeImageString:@"wushangpin" viewWidth:50 viewHeight:54 UITableView:self.tableView isShowBottomBtn:NO bottomBtnTitle:@""];
            }else{
                [[GlobalHelper shareInstance] removeEmptyView];
            }
            
        }else{
            [self.orderListMarray removeAllObjects];
            [self.orderImvArray removeAllObjects];
            
            [[GlobalHelper shareInstance] emptyViewNoticeText:@"暂无订单" NoticeImageString:@"wushangpin" viewWidth:50 viewHeight:54 UITableView:self.tableView isShowBottomBtn:NO bottomBtnTitle:@""];
        }
        [self.tableView reloadData];
        
        
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}


-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-kBarHeight-44-LL_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = RGB(238, 238, 238, 1);
    }
    return _tableView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.orderListMarray.count;
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 15*kScale)];
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
    if (self.orderImvArray.count != 0) {
        MyOrderTableCellConfig *orderConfig = [MyOrderTableCellConfig myOrderTableCellConfig];
        orderConfig.orderImvArray = self.orderImvArray[indexPath.section];
        
    }
    NSString * Identifier =[NSString stringWithFormat:@"receive%ld" ,indexPath.section];
    MyOrderTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell1 == nil) {
        cell1 = [[MyOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell1.backgroundColor = [UIColor whiteColor];
        
    }
    if (self.orderImvArray.count != 0) {
        
        MyOrderTableCellConfig *orderConfig = [MyOrderTableCellConfig myOrderTableCellConfig];
        orderConfig.orderImvArray = self.orderImvArray[indexPath.section];
    }
    if (self.orderListMarray.count != 0) {
        OrderModel *model = self.orderListMarray[indexPath.section];
        totalPageCount = model.pages;
        [cell1 configWithOrderModel:model];
        
    }
    
    return cell1;
}

#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderDetailesViewController *VC = [OrderDetailesViewController new];
    OrderModel *model = self.orderListMarray[indexPath.section];
    VC.orderNo = model.orderNo;
    VC.fromWaitCommentsVC = @"1";
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
