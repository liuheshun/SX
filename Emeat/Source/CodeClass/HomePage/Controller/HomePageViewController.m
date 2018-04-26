//
//  HomePageViewController.m
//  Emeat
//
//  Created by liuheshun on 2017/11/6.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomePageTableViewCell.h"
#import "homePageHeadView.h"
#import "HomePageDetailsViewController.h"
#import "HomePageSortListViewController.h"
#import <PYSearch.h>
#import "SelectAddressViewController.h"
#import "RHLocation.h"
#import "DDSearchManager.h"
#import "HomePageModel.h"
#import "HomePageAddressNoticeView.h"
#import "HomePageOtherDetailsViewController.h"
#import "JMHoledView.h"

#define tableViewHeadHeight (226*kScale+42+kBarHeight)


@interface HomePageViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,PYSearchViewControllerDelegate,CLLocationManagerDelegate,RHLocationDelegate ,JMHoledViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UILabel *lab;
@property (nonatomic,strong) HomePageNavView *navView;
//@property (nonatomic,strong) AddOrCutShoppingCartView *cartView;
@property (nonatomic,strong) NSMutableArray *dataArray;//商品列表数据源

///轮播图
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
///今日推荐
@property (nonatomic,strong) homePageHeadView *headTieleView;

///记录当前位置信息
@property (nonatomic,strong) Location *currentLocation;
@property (nonatomic,strong) NSString *currentAddressSubLocality;

///记录当前附近位置信息
@property (nonatomic,strong) NSMutableArray *otherAddressArray;

@property (nonatomic,strong) RHLocation *rhLocation;

@property (nonatomic,strong) SelectAddressViewController *selectAddressVC;

///banner轮播图数据源
@property (nonatomic,strong) NSMutableArray *bannerMarray;
///分类标签数据源字典
@property (nonatomic,strong) NSMutableArray *sortListMarray;
///地址提示视图
@property (nonatomic,strong) HomePageAddressNoticeView *addressNoticeView;
///地址提示视图 0不在配送范围内显示 , 1 在配送范围内不显示
@property (nonatomic,strong) NSString *isShowNoticeView;



@end

@implementation HomePageViewController
{
    NSInteger totalPage;//分页
    NSInteger totalPageCount;//分页总数
    CGFloat noticeViewHeiht;
}



-(void)viewWillAppear:(BOOL)animated{
    
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    if (status == RealStatusNotReachable)
    {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    }
    [self requestBadNumValue];


}
-(void)viewDidDisappear:(BOOL)animated{
    [GlobalHelper shareInstance].selectAddressString = self.navView.selectAddressBtn.titleLabel.text;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);

    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.sortListMarray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    self.bannerMarray = [NSMutableArray array];
    [self netWorkIsOnLine];
   
}

-(void)netWorkIsOnLine{
    
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    if (status == RealStatusNotReachable)
    {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

        [[GlobalHelper shareInstance] showErrorIView:self.view errorImageString:@"wuwangluo" errorBtnString:@"重新加载" errorCGRect:CGRectMake(0, 0, kWidth, kHeight)];
        [[GlobalHelper shareInstance].errorLoadingBtn addTarget:self action:@selector(errorLoadingBtnAction) forControlEvents:1];
        
    }else{
        
        [self setMainViewData];
        [[GlobalHelper shareInstance] removeErrorView];
    }
}



#pragma mark = 重新加载

-(void)errorLoadingBtnAction{
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    
    if (status == RealStatusNotReachable){
        
    }else{
        [self setMainViewData];
        [[GlobalHelper shareInstance] removeErrorView];
    }
}


-(void)setMainViewData{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    [self.view addSubview:self.tableView];
    [self setCycleScrollViews];
    [self.view addSubview:self.headTieleView];
    [self.view addSubview:self.navView];
    [self.navView addSubview:self.addressNoticeView];
    [self addBlockAction];
    [self setupRefresh];
    ///更新购物车数量
    [self requestBadNumValue];
    
    ////
    


    
}



#pragma mark = 添加block事件

-(void)addBlockAction{
    
    __weak __typeof(self) weakSelf = self;
    
    #pragma mark = 分类列表点击 block事件
    
    self.navView.sortBlock = ^{
    
        
        [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.navView.shadeBtn];
        
        [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.navView.tableView];
        
        weakSelf.navView.HomeArray = weakSelf.sortListMarray;
        
    };
    
    
    ///点击分类标签进入分类列表
    
    
    self.navView.selectSortIndexBlock = ^(NSInteger selectIndex) {
        
        [weakSelf.navView.tableView removeFromSuperview];
        
        [weakSelf.navView.shadeBtn removeFromSuperview];
        
        HomePageSortListViewController *VC = [HomePageSortListViewController new];
        
        VC.selelctSortLable = weakSelf.sortListMarray[selectIndex][@"dataName"];
        
        VC.ID = weakSelf.sortListMarray[selectIndex][@"id"];
        
        VC.sortListMarray = weakSelf.sortListMarray;
    
        
        VC.currentLocation = weakSelf.currentLocation;
        
        ///记录当前附近位置信息
    
        
        VC.otherAddressArray = weakSelf.otherAddressArray;
    
        
        [weakSelf.navigationController pushViewController:VC animated:YES];
    
        
    };
   
#pragma mark = 搜索商品
    
    
    self.navView.searchBtnBlock = ^{
    
        
        NSArray *hotSeaches = @[@""];
        
        // 2. Create a search view controller
        
        PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"请输入商品名称搜索", @"搜索") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
    

            searchViewController.searchResultShowMode = PYSearchResultShowModeEmbed;
            searchViewController.showSearchResultWhenSearchBarRefocused = YES;

            SeacherViewController *sVc = [[SeacherViewController alloc] init];

            searchViewController.searchResultController = sVc;

            sVc.searchText = searchText;
            
//   
//            SeacherViewController *sVc = [[SeacherViewController alloc] init];
//            sVc.searchText = searchText;
//            [searchViewController.navigationController pushViewController:sVc animated:YES];

            
        }];
        searchViewController.searchResultShowMode = PYSearchResultShowModeEmbed;

        searchViewController.showSearchHistory = NO;

        searchViewController.showHotSearch = NO;


        searchViewController.delegate = weakSelf;
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        
        // 5. Present a navigation controller
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
        
        [weakSelf presentViewController:nav animated:YES completion:nil];
    
        
        DLog(@"sousuo");
        
    };
    
    
#pragma makr = 选择地址
    
    
    _navView.selectAddressBtnBlock = ^{
    
    
        SelectAddressViewController *VC = [SelectAddressViewController new];
        
        VC.hidesBottomBarWhenPushed = YES;
    //            VC.currentLocation = weakSelf.currentLocation;
    //            VC.otherAddressArray = weakSelf.otherAddressArray;
    //
    
#pragma mark= 选择地址接收传值

        VC.selectAddressBL = ^(Location *currentLocations) {//地址传值
        
            weakSelf.currentLocation = currentLocations;
            
            DLog(@"区域=== %@" ,currentLocations.name);
            
            [weakSelf.navView.selectAddressBtn setTitle:currentLocations.name forState:0];
    
            
            CGFloat imageWidth = weakSelf.navView.selectAddressBtn.imageView.bounds.size.width;
    
            
            CGFloat labelWidth = weakSelf.navView.selectAddressBtn.titleLabel.bounds.size.width;
            
            weakSelf.navView.selectAddressBtn.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth);
            
            weakSelf.navView.selectAddressBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
            
            DLog(@"--------------选择地址block返回---------------------------------------")
            CGFloat y = weakSelf.tableView.contentOffset.y;

            if ([currentLocations.city containsString:@"上海市"] && ![currentLocations.subLocality containsString:@"崇明区"]) {
                        DLog(@"在范围内");
            
                weakSelf.isShowNoticeView = @"1";
                noticeViewHeiht = 0;
                [weakSelf.addressNoticeView removeFromSuperview];
                DLog(@"uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu============%f" , y);

                [weakSelf scrollViewDidScroll:weakSelf.tableView];    
                
            }else{
                DLog(@"-------------不在");
                weakSelf.isShowNoticeView = @"0";
                noticeViewHeiht = 29;
                [weakSelf.navView addSubview:weakSelf.addressNoticeView];
                [weakSelf scrollViewDidScroll:weakSelf.tableView];


            }
            
            [weakSelf.tableView reloadData];
            
        };
    
        
        [weakSelf.navigationController pushViewController:VC animated:YES];
        
        DLog(@"选择收货地址");
        
    
    };
}

- (void)setupRefresh{
    
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.tableView.mj_header  = header;
    header.lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
    //上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        self.tableView.mj_footer.automaticallyHidden = YES;
}


- (void)headerRereshing{
    
    totalPage=1;
    [self requestLocation];//请求当前位置信息
    [self requsetHomPageBannerData];
    [self requestListData:totalPage];
    [self requestSortListData];
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



#pragma mark = 商品banner数据

-(void)requsetHomPageBannerData{
    
    [MHNetworkManager getRequstWithURL:[NSString stringWithFormat:@"%@/banner/queryBannerForWeb" ,baseUrl] params:nil successBlock:^(NSDictionary *returnData) {        
         DLog(@"bannertu=====%@" ,returnData);

        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"]) {
            [self.bannerMarray removeAllObjects];
            for (NSDictionary *dic in returnData[@"data"]) {
                  HomePageModel *bannerModel = [HomePageModel yy_modelWithJSON:dic];
                [self.bannerMarray addObject:bannerModel];
            }

            NSMutableArray *mArray = [NSMutableArray array];
            if (self.bannerMarray.count!=0) {
                for (HomePageModel *bannerModel in self.bannerMarray) {
                    [mArray addObject:bannerModel.bannerImage];
                }
            }
            self.cycleScrollView.imageURLStringsGroup = mArray;
        
        
        
        
        }else{
            
        }
      

        
    } failureBlock:^(NSError *error) {

        
    } showHUD:NO];
    
   
    
}


#pragma mark = 商品列表数据
-(void)requestListData:(NSInteger)currentPage{
  
    [MHAsiNetworkHandler startMonitoring];
    
    [MHNetworkManager getRequstWithURL:[NSString stringWithFormat:@"%@/mobile/commodity/commodityShow?currentPage=%ld" , baseUrl , currentPage] params:nil successBlock:^(NSDictionary *returnData) {
        DLog(@"商品列表== %@" ,returnData);
       
        NSInteger pages = [returnData[@"data"][@"page"][@"totalPage"] integerValue];
        NSInteger pageSize = [returnData[@"data"][@"page"][@"pageSize"] integerValue];
        NSInteger total = [returnData[@"data"][@"page"][@"totalRecords"] integerValue];


        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"]) {
            
            
            if (currentPage == 1) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *dic in returnData[@"data"][@"list"]) {
                HomePageModel *model = [HomePageModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }                
                model.pages = pages;
                model.pageSize = pageSize;
                model.total = total;
                [self.dataArray addObject:model];
            }

            [self.tableView reloadData];
        }
        
        
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
  
    
}


#pragma mark = 分类列表标签数据

-(void)requestSortListData{
    //[MHAsiNetworkHandler startMonitoring];

    [MHNetworkManager getRequstWithURL:[NSString stringWithFormat:@"%@/rightBanner" , baseUrl] params:nil successBlock:^(NSDictionary *returnData) {
        DLog(@"标签=== %@" ,returnData);
        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"]) {
            [self.sortListMarray removeAllObjects];

            for (NSDictionary *dic in returnData[@"data"]) {
                [self.sortListMarray addObject:dic];
            }
            [self.tableView reloadData];
        }
        
        
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
    
    
}






-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-kBottomBarHeight) style:UITableViewStyleGrouped];
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
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135*kScale;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.1)];
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//    }
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"homePage_cell";//以indexPath来唯一确定cell

    HomePageTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell1 == nil) {
        cell1 = [[HomePageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell1.backgroundColor = [UIColor whiteColor];
    }
    cell1.cartBtn.tag = indexPath.row;
    [cell1.cartBtn addTarget:self action:@selector(cartBtnAction:) forControlEvents:1];
    __weak __typeof(HomePageTableViewCell*) weakCell = cell1;
    __weak __typeof(self) weakSelf = self;
    HomePageModel *model = [HomePageModel new];
    if (self.dataArray.count!=0) {
        model = self.dataArray[indexPath.row];
        totalPageCount = model.pages;
    }
    
    //    后期可能会有此需求(商品首页回显加入购物车数量)

//     cell1.cartView.numAddBlock = ^{///加入购物车
//            DLog(@"加加");
//        [weakSelf addCartPostDataWithProductId:model.id homePageModel:model NSIndexPath:indexPath cell:weakCell isFirstClick:NO tableView:weakSelf.tableView];
//        };
//
//        cell1.cartView.numCutBlock = ^{///减去购物车
//            DLog(@"渐渐");
//            NSInteger count = [weakCell.cartView.numberLabel.text integerValue];
//
//            if (count>1) {
//
//                [self cutCartPostDataWithProductId:model.id homePageModel:model NSIndexPath:indexPath cell:weakCell];///减去购物车
//
//
//            }else{
//
//
//                ///删除整个商品
//                [self deleteProductPostDataWithProductId:model.id homePageModel:model tableView:weakSelf.tableView];
//
//            }
//
//        };
  
    
    [cell1 configHomePageCellWithModel:model];
    
    return cell1;
}

#pragma mark = 加入购物车按钮


-(void)cartBtnAction:(UIButton*)btn{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user valueForKey:@"isLoginState"]) {
        [GlobalHelper shareInstance].isLoginState = [user valueForKey:@"isLoginState"];
    }
    if ([[GlobalHelper shareInstance].isLoginState isEqualToString:@"1"])
    {
        
        NSIndexPath *myIndex=[self.tableView indexPathForCell:(HomePageTableViewCell*)[btn superview]];
        HomePageTableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:myIndex.section]];
        
        //后期可能会有此需求(商品首页回显加入购物车数量)下面一行需要删掉
        // [cell1.cartBtn removeFromSuperview];
        
        if (self.dataArray.count != 0)
        {
            HomePageModel *model = self.dataArray[myIndex.row];
            
            [self addCartPostDataWithProductId:model.id homePageModel:model NSIndexPath:myIndex cell:cell1 isFirstClick:YES tableView:self.tableView];
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:myIndex.row inSection:myIndex.section];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
        }
      
    }else
    {
        LoginViewController *VC = [LoginViewController new];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        
   
    }
}




#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomePageDetailsViewController *VC = [HomePageDetailsViewController new];
    VC.hidesBottomBarWhenPushed = YES;
    if (self.dataArray.count != 0) {
        HomePageModel *model = self.dataArray[indexPath.row];
        VC.detailsId = [NSString stringWithFormat:@"%ld" ,(long)model.id];
        [self.navigationController pushViewController:VC animated:YES];
    }
  
}

#pragma mark = 轮播图点击事件

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    HomePageDetailsViewController *VC = [HomePageDetailsViewController new];
    VC.hidesBottomBarWhenPushed = YES;
    
    HomePageOtherDetailsViewController *otherVC = [HomePageOtherDetailsViewController new];
    otherVC.hidesBottomBarWhenPushed = YES;


    if (self.bannerMarray.count!=0) {
        HomePageModel *model = self.bannerMarray[index];
        
        DLog(@"轮播图详情页======= %@" ,model.bannerUrl);

        
        if ([model.bannerUrl containsString:@"SP"]) {
            VC.fromBaner = @"1";
            VC.detailsId = model.bannerUrl;
            [self.navigationController pushViewController:VC animated:YES];
        }
        else
        {
            otherVC.detailsURL = model.bannerUrl;
            DLog(@"轮播图详情页外部外部链接======= %@" ,otherVC.detailsURL);
            [self.navigationController pushViewController:otherVC animated:YES];

        }
        
    }
   
    
}







#pragma mark = 提前请求当前定位位置信息

-(void)requestLocation{
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{

        [self setLocations];
        
//    });
    
}



-(HomePageNavView*)navView{
    if (!_navView) {
        _navView = [[HomePageNavView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kBarHeight+42+noticeViewHeiht)];
        _navView.backgroundColor = RGB(236, 31, 35, 1);
        //_navView.HomeArray = @[@"1" ,@"2"];///////////////
    }
    return _navView;
}


-(HomePageAddressNoticeView*)addressNoticeView{
    if (!_addressNoticeView) {
        _addressNoticeView = [[HomePageAddressNoticeView alloc] initWithFrame:CGRectMake(0, kBarHeight+42, kWidth, noticeViewHeiht)];
    }
    [_addressNoticeView.noticeBtn addTarget:self action:@selector(enterBtnAction) forControlEvents:1];
    
    [_addressNoticeView.enterBtn addTarget:self action:@selector(enterBtnAction) forControlEvents:1];

    return _addressNoticeView;
}

-(void)enterBtnAction{
    SelectAddressViewController *VC = [SelectAddressViewController new];
    VC.hidesBottomBarWhenPushed = YES;
    VC.currentLocation = self.currentLocation;
    VC.otherAddressArray = self.otherAddressArray;
    
#pragma mark= 选择地址接收传值
    __weak __typeof(self) weakSelf = self;

    VC.selectAddressBL = ^(Location *currentLocations) {//地址传值
//        DLog(@"区域=== %@" ,currentLocations.subLocality);
        [self.navView.selectAddressBtn setTitle:currentLocations.name forState:0];
        CGFloat imageWidth = self.navView.selectAddressBtn.imageView.bounds.size.width;
        CGFloat labelWidth = self.navView.selectAddressBtn.titleLabel.bounds.size.width;
        self.navView.selectAddressBtn.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth);
        self.navView.selectAddressBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);

        
        if ([currentLocations.city containsString:@"上海市"] && ![currentLocations.subLocality containsString:@"崇明区"]) {
            DLog(@"在范围内");
            
            weakSelf.isShowNoticeView = @"1";
            noticeViewHeiht = 0;
            [weakSelf.addressNoticeView removeFromSuperview];
            
            [weakSelf scrollViewDidScroll:weakSelf.tableView];
            
            
            
        }else{
            
            DLog(@"-------------不在");
            
            weakSelf.isShowNoticeView = @"0";
            noticeViewHeiht = 29;
            [weakSelf scrollViewDidScroll:weakSelf.tableView];
            
            
        }
        [weakSelf.tableView reloadData];

    };
    
    [self.navigationController pushViewController:VC animated:YES];
    DLog(@"选择收货地址");
}


-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
   
    
    // 保证是我们的tableivew
    if (scrollView == self.tableView) {
        // 保证我们是垂直方向滚动，而不是水平滚动
        if (scrollView.contentOffset.x == 0) {
          
            CGFloat tableViewoffsetY = scrollView.contentOffset.y;
//            DLog(@"偏移量========= %f " ,tableViewoffsetY );
            CGFloat tempY = tableViewoffsetY;
            
            if ( tableViewoffsetY>=0 ) {
                CGRect rect = self.navView.frame;
                rect.origin.y = 0;
                if (tempY > 42) {
                    tempY = 42;
                }
                
                rect.size.height = kBarHeight+42-tempY+noticeViewHeiht;
                self.navView.frame = rect;
                self.cycleScrollView.frame = CGRectMake(0, kBarHeight+42+noticeViewHeiht-tableViewoffsetY, kWidth, 176*kScale);
                self.headTieleView.frame = CGRectMake(0, kBarHeight+42+noticeViewHeiht+176*kScale-tableViewoffsetY, kWidth, 50*kScale);
                self.addressNoticeView.frame = CGRectMake(0, kBarHeight+42-tempY, kWidth, noticeViewHeiht);
                
                if (tableViewoffsetY >= 12) {

                    [UIView animateWithDuration:0.5 animations:^{
                        self.navView.searchBtn.backgroundColor = [UIColor clearColor];
                        self.navView.searchBtn.frame = CGRectMake(MaxX(self.navView.selectAddressBtn)+15, kStatusBarHeight, kTopBarHeight, kTopBarHeight);

//                        rectSearch.origin.x = MaxX(self.navView.selectAddressBtn)+15;
//                        rectSearch.origin.y = kStatusBarHeight;
//                        rectSearch.size.height = kTopBarHeight;
//                        rectSearch.size.width = kTopBarHeight;
//                        self.navView.searchBtn.frame = rectSearch;
                        [self.navView.searchBtn setImage:[UIImage imageNamed:@"search"] forState:0];
                        [self.navView.searchBtn setTitle:@"" forState:0];
                        
                    }];
                   
                }else{

                    [UIView animateWithDuration:0.5 animations:^{
                        self.navView.searchBtn.frame = CGRectMake(30, MaxY(self.navView.selectAddressBtn), kWidth -60, 30);
                        self.navView.searchBtn.backgroundColor = [UIColor whiteColor];
                        [self.navView.searchBtn setImage:[UIImage imageNamed:@"sousuo"] forState:0];
                        [self.navView.searchBtn setTitle:@"请输入商品名称" forState:0];
                        
                        //self.addressNoticeView.frame = CGRectMake(0, kBarHeight+42, kWidth, noticeViewHeiht);
                        
                        
                    }];
                    
                }

            }else if (tableViewoffsetY < 0){
                
                self.navView.frame = CGRectMake(0, 0-tableViewoffsetY, kWidth, kBarHeight+42+noticeViewHeiht);
                self.cycleScrollView.frame = CGRectMake(0, kBarHeight+42+noticeViewHeiht-tableViewoffsetY, kWidth, 176*kScale);
               // self.navView.searchBtn.frame = CGRectMake(30, MaxY(self.navView.selectAddressBtn), kWidth-60, 30);
                
                //self.addressNoticeView.frame = CGRectMake(0, kBarHeight+42-tableViewoffsetY, kWidth, noticeViewHeiht);
               
                self.headTieleView.frame = CGRectMake(0, kBarHeight+42+noticeViewHeiht+176*kScale-tableViewoffsetY, kWidth, 50*kScale);
                
            }
            
            
            
        }
    }
}




#pragma mark = 定位

-(void)setLocations{
    self.rhLocation = [[RHLocation alloc] init];
    self.rhLocation.delegate = self;
    [self.rhLocation beginUpdatingLocation];
}

- (void)locationDidEndUpdatingLocation:(Location *)location{
    self.currentAddressSubLocality = location.subLocality;
    
    self.currentLocation = location;
    
    [self.navView.selectAddressBtn setTitle:location.name forState:0];
    CGFloat imageWidth = self.navView.selectAddressBtn.imageView.bounds.size.width;
    CGFloat labelWidth = self.navView.selectAddressBtn.titleLabel.bounds.size.width;
    self.navView.selectAddressBtn.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth);
    self.navView.selectAddressBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
    [self getAddresspoiWithLocation:location];
    
    ///判断当前地址是否在配送范围内
    if ([location.city isEqualToString:@"上海市"] && ![location.subLocality isEqualToString:@"崇明区"]) {
        DLog(@"请求在范围内");
        [self.addressNoticeView removeFromSuperview];
        self.isShowNoticeView = @"1";
        noticeViewHeiht = 0;
        [self scrollViewDidScroll:self.tableView];

    }else{
        DLog(@"----------ssss---请求不在");
        self.isShowNoticeView = @"0";
        noticeViewHeiht = 29;
        [self.navView addSubview:self.addressNoticeView];

        [self scrollViewDidScroll:self.tableView];
    }
   
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, tableViewHeadHeight+noticeViewHeiht)];
    tableHeaderView.backgroundColor = [UIColor whiteColor];
    
   // _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(tableViewHeadHeight+noticeViewHeiht, 0, 0, 0);
    _tableView.tableHeaderView = tableHeaderView;
    [self.tableView reloadData];
    
}




-(void)getAddresspoiWithLocation:(Location*)location{
    self.otherAddressArray = [NSMutableArray array];
    [self.otherAddressArray removeAllObjects];
    //逆地理编码，请求附近兴趣点数据
    [[DDSearchManager sharedManager] poiReGeocode:CLLocationCoordinate2DMake(location.latitude,location.longitude) returnBlock:^(NSArray<__kindof DDSearchPoi *> *pois) {
    
        
        for (DDSearchPoi *poi in pois) {
            poi.district = self.currentAddressSubLocality;
            if (![self.otherAddressArray containsObject:poi]) {
//                DLog(@"qu==== %@  %@" ,poi.district , poi.province)
                Location *locat = [Location new];
      
                locat.administrativeArea = poi.province;
                locat.city = poi.city;
                locat.subLocality = poi.district;
                locat.longitude = poi.coordinate.longitude;
                locat.latitude = poi.coordinate.latitude;
                locat.name = poi.name;

                [self.otherAddressArray addObject:locat];
            }
        }
        
        
        
        
    }];
    
}

#pragma mark = 首页轮播图

- (void )setCycleScrollViews{
    
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, kBarHeight+42+noticeViewHeiht, kWidth, 176*kScale) delegate:self placeholderImage:[UIImage imageNamed:@"banner加载"]];   //placeholder
    
    
   
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.showPageControl = YES;//是否显示分页控件
    _cycleScrollView.currentPageDotColor = [UIColor orangeColor]; // 自定义分页控件小圆标颜色
    _cycleScrollView.tag = 1;
    
    [self.view addSubview:self.cycleScrollView];
}

-(homePageHeadView *)headTieleView{
    if (!_headTieleView) {
        _headTieleView = [[homePageHeadView alloc] initWithFrame:CGRectMake(0, MaxY(self.cycleScrollView), kWidth, 50*kScale)];
        _headTieleView.backgroundColor = [UIColor whiteColor];
        
    }
    return _headTieleView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
