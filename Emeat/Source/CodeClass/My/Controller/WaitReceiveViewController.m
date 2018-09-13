//
//  WaitReceiveViewController.m
//  Emeat
//
//  Created by liuheshun on 2017/12/13.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "WaitReceiveViewController.h"
#import "MyOrderTableViewCell.h"

@interface WaitReceiveViewController ()<UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *orderImvArray;
@property (nonatomic,strong) NSMutableArray *orderListMarray;



@end

@implementation WaitReceiveViewController
{
    NSInteger totalPage;//分页
    NSInteger totalPageCount;//分页总数
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    self.orderImvArray = [NSMutableArray array];
    self.orderListMarray = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self setupRefresh];

}

-(void)viewWillAppear:(BOOL)animated{
    totalPage = 1;
    [self.tableView.mj_footer endRefreshing];

    [self requestDataWithTotalPage:totalPage];

}



- (void)setupRefresh{
    
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.tableView.mj_header  = header;
    header.lastUpdatedTimeLabel.hidden = YES;
    //[self.tableView.mj_header beginRefreshing];
    //上拉加载
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 加载旧的数据，加载旧的未显示的数据
        [self footerRereshing];
    }];
    
}


- (void)headerRereshing{
    
    totalPage=1;
    [self requestDataWithTotalPage:totalPage];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}


#pragma mark=====================上拉加载============================

- (void)footerRereshing{
    
    totalPage++;
    if (totalPage<=totalPageCount) {
        
        [self requestDataWithTotalPage:totalPage];
        [self.tableView.mj_footer endRefreshing];
        
    }else{
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}



-(void)requestDataWithTotalPage:(NSInteger)totalPage{
    
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
    [dic setValue:@"60" forKey:@"status"];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];

    [MHAsiNetworkHandler startMonitoring];

    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/order/queryByStatus?currentPage=%ld" , baseUrl ,(long)totalPage] params:dic successBlock:^(NSDictionary *returnData) {
        
        
        NSInteger pages = [returnData[@"data"][@"pages"] integerValue];
        NSInteger pageSize = [returnData[@"data"][@"pageSize"] integerValue];
        NSInteger total = [returnData[@"data"][@"total"] integerValue];

        if ([returnData[@"status"] integerValue] == 200) {
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
