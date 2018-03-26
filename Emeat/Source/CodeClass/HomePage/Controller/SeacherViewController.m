//
//  SeacherViewController.m
//  Emeat
//
//  Created by liuheshun on 2017/11/30.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "SeacherViewController.h"
#import "HomePageDetailsViewController.h"
@interface SeacherViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *searchDataMarray;

@end

@implementation SeacherViewController

{
    NSInteger totalPage;//分页
    NSInteger totalPageCount;//分页总数
}

-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

}

-(void)viewWillDisappear:(BOOL)animated{
    
    [[GlobalHelper shareInstance] removeEmptyView];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
    DLog(@"搜索关键词====== %@" ,self.searchText);
    totalPage = 1;
    [self requesaSeacherListData:self.searchText totalPage:totalPage];
    [self setupRefresh];

}


- (void)setupRefresh{
    //上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    self.tableView.mj_footer.automaticallyHidden = YES;
}



#pragma mark=====================上拉加载============================

- (void)footerRereshing{
    
    totalPage++;
    if (totalPage<=totalPageCount) {
        
        [self requesaSeacherListData:self.searchText totalPage:totalPage];
        [self.tableView.mj_footer endRefreshing];
        
    }else{
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}


#pragma mark = 搜索接口数据

-(void)requesaSeacherListData:(NSString*)searchText totalPage:(NSInteger)totalPage{
    if (totalPage == 1) {
        self.searchDataMarray = [NSMutableArray array];
        [self.searchDataMarray removeAllObjects];
    }
   
    NSString * urlStr ;
    
    if ([self.fromSortString isEqualToString:@"1"]) {///来自分类搜索
        urlStr = [NSString stringWithFormat:@"%@/search/searchCommodityByPosition?commodityName=%@&currentPage=%ld&position=%@" ,baseUrl,searchText ,totalPage ,self.position];
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    else
    {
        urlStr = [NSString stringWithFormat:@"%@/search/searchCommodity?commodityName=%@&currentPage=%ld" ,baseUrl,searchText ,totalPage];
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
   

    [MHNetworkManager getRequstWithURL:urlStr params:nil successBlock:^(NSDictionary *returnData) {
        DLog(@"商品搜索列表== %@" ,returnData);

        NSInteger pages = [returnData[@"data"][@"pages"] integerValue];
        NSInteger pageSize = [returnData[@"data"][@"pageSize"] integerValue];
        NSInteger total = [returnData[@"data"][@"total"] integerValue];
        
        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"])
        {
            for (NSDictionary *dic in returnData[@"data"][@"list"])
            {
                HomePageModel *model = [HomePageModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                
                if (mainImvMarray.count!=0)
                {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.pages = pages;
                model.pageSize = pageSize;
                model.total = total;
                [self.searchDataMarray addObject:model];
            }
        }
        
        if (self.searchDataMarray.count == 0) {
            [[GlobalHelper shareInstance] emptyViewNoticeText:@"没有找到您要找的商品,换一个试试吧" NoticeImageString:@"wushangpin" viewWidth:50 viewHeight:54 UITableView:self.tableView];
            
        }
        else
        {
            [[GlobalHelper shareInstance] removeEmptyView];
        }
        
        [self.tableView reloadData];

        
    } failureBlock:^(NSError *error) {
        DLog(@"商品搜索列表error== %@" ,error);

        
    } showHUD:NO];
    
    
}



-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-LL_TabbarSafeBottomMargin-kBarHeight) style:UITableViewStyleGrouped];
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
    return self.searchDataMarray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 0.01;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    view.backgroundColor = RGB(238, 238, 238, 1);
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.01)];
    view.backgroundColor = RGB(238, 238, 238, 1);
    return view;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomePageTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"search_cell"];
    if (cell1 == nil) {
        cell1 = [[HomePageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"search_cell"];
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
        cell1.backgroundColor = [UIColor whiteColor];
        
    }
    
    cell1.cartBtn.tag = indexPath.row;
    [cell1.cartBtn addTarget:self action:@selector(cartBtnAction:) forControlEvents:1];
    __weak __typeof(HomePageTableViewCell*) weakCell = cell1;
    __weak __typeof(self) weakSelf = self;
    HomePageModel *model = [HomePageModel new];
    if (self.searchDataMarray.count!=0) {
        model = self.searchDataMarray[indexPath.row];
        totalPageCount = model.pages;
        
    }
    //    后期可能会有此需求(商品首页回显加入购物车数量)

//    cell1.cartView.numAddBlock = ^{///加入购物车
//        
//        
//        DLog(@"加加");
//        [weakSelf addCartPostDataWithProductId:model.id homePageModel:model NSIndexPath:indexPath cell:weakCell isFirstClick:NO tableView:weakSelf.tableView];
//    };
//    
//    cell1.cartView.numCutBlock = ^{///减去购物车
//        DLog(@"渐渐");
//        NSInteger count = [weakCell.cartView.numberLabel.text integerValue];
//        
//        if (count>1) {
//            
//            [self cutCartPostDataWithProductId:model.id homePageModel:model NSIndexPath:indexPath cell:weakCell];///减去购物车
//            
//            
//        }else{
//            
//            
//            ///删除整个商品
//            [self deleteProductPostDataWithProductId:model.id homePageModel:model tableView:weakSelf.tableView];
//            
//        }
//        
//        
//        
//        
//        
//    };
    
    
    [cell1 configHomePageCellWithModel:model];
    
    return cell1;
}


#pragma mark = 加入购物车


-(void)cartBtnAction:(UIButton*)btn{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user valueForKey:@"isLoginState"]) {
        [GlobalHelper shareInstance].isLoginState = [user valueForKey:@"isLoginState"];
    }
    if ([[GlobalHelper shareInstance].isLoginState isEqualToString:@"0"])
    {
        LoginViewController *VC = [LoginViewController new];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        
    }else
    {
        
        NSIndexPath *myIndex=[self.tableView indexPathForCell:(HomePageTableViewCell*)[btn superview]];
        HomePageTableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:myIndex.section]];
        ///后期回显要加上这句
       // [cell1.cartBtn removeFromSuperview];
        
        if (self.searchDataMarray.count != 0)
        {
            HomePageModel *model = self.searchDataMarray[myIndex.row];
            
            [self addCartPostDataWithProductId:model.id homePageModel:model NSIndexPath:myIndex cell:cell1 isFirstClick:YES tableView:self.tableView];
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:myIndex.row inSection:myIndex.section];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
        }
        
    }
    
}


#pragma mark = 从购物车减去

-(void)cutCartPostDataWithProductId:(NSInteger)productId{
    
    //http://localhost:8085/cart/update?userId=7&productId=111&quatity=10
    //   http://localhost:8085/cart/delete_product?userId=7&productIds=111
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *ticket = [user valueForKey:@"ticket"];
    NSString *secret = @"UHnyKzP5sNmh2EV0Dflgl4VfzbaWc4crQ7JElfw1cuNCbcJUau";
    NSString *nonce = [self ret32bitString];//随机数
    NSString *curTime = [self dateTransformToTimeSp];
    NSString *checkSum = [self sha1:[NSString stringWithFormat:@"%@%@%@" ,secret ,  nonce ,curTime]];
    
    [dic setObject:secret forKey:@"secret"];
    [dic setObject:nonce forKey:@"nonce"];
    [dic setObject:curTime forKey:@"curTime"];
    [dic setObject:checkSum forKey:@"checkSum"];
    [dic setObject:ticket forKey:@"ticket"];
    
    [dic setObject:[NSString stringWithFormat:@"%ld" , productId] forKey:@"commodityId"];
    [dic setObject:@"1" forKey:@"quatity"];
    
    [MHNetworkManager  postReqeustWithURL:[NSString stringWithFormat:@"%@/auth/cart/update" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
        DLog(@"减去购物车==  %@" ,returnData);
    } failureBlock:^(NSError *error) {
        
        DLog(@"减去购物车error==  %@" ,error);
        
    } showHUD:NO];
    
    
}





#pragma mark = 加入购物车

-(void)addCartPostDataWithProductId:(NSInteger)productId homePageModel:(HomePageModel*)model NSIndexPath:(NSIndexPath*)indexPath cell:(HomePageTableViewCell*)weakCell{

    [SVProgressHUD show];
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
    
#pragma mark---------------------------------需要更改productID--------------------------------
    
    //[dic setObject:[NSString stringWithFormat:@"%ld" ,productId] forKey:@"productId"];
    [dic setValue:[NSString stringWithFormat:@"%ld" ,productId] forKey:@"commodityId"];
    
    [dic setObject:@"1" forKey:@"quatity"];
    DLog(@"加入购物车 ==== %@" , dic);
    [MHNetworkManager  postReqeustWithURL:[NSString stringWithFormat:@"%@/auth/cart/add",baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        if ([returnData[@"status"] integerValue] == 200) {
//            SVProgressHUD.minimumDismissTimeInterval = 1;
//            SVProgressHUD.maximumDismissTimeInterval = ;
            
            NSInteger count = [weakCell.cartView.numberLabel.text integerValue];
            count++;
            weakCell.cartView.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)count];;
            model.number = count ;

            
            [[GlobalHelper shareInstance].addShoppingCartMarray addObject:model];
            
            if ([[GlobalHelper shareInstance].addShoppingCartMarray containsObject:model]) {
                [[GlobalHelper shareInstance].addShoppingCartMarray removeObject:model];
                [[GlobalHelper shareInstance].addShoppingCartMarray addObject:model];
            }
            
            DLog(@"ssss====  %ld " ,[GlobalHelper shareInstance].addShoppingCartMarray.count);
            
            
            [GlobalHelper shareInstance].shoppingCartBadgeValue += 1;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shoppingCart" object:nil userInfo:nil];
            [SVProgressHUD dismiss];

        }
        else
        {
            SVProgressHUD.minimumDismissTimeInterval = 1;
            SVProgressHUD.maximumDismissTimeInterval = 3;
            [SVProgressHUD showErrorWithStatus:returnData[@"msg"]];
        }
        [self.tableView reloadData];
        DLog(@"首页加入购物车== id=== %ld  %@" ,productId,returnData);
    } failureBlock:^(NSError *error) {
        
        DLog(@"首页加入购物车error ========== id= %ld  %@" ,productId,error);
        
    } showHUD:NO];
    
}









#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //隐藏tabBar
    HomePageDetailsViewController *VC = [HomePageDetailsViewController new];
    VC.hidesBottomBarWhenPushed = YES;
    if (self.searchDataMarray.count != 0) {
        HomePageModel *model = self.searchDataMarray[indexPath.row];
        VC.detailsId = [NSString stringWithFormat:@"%ld" ,model.id];
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
