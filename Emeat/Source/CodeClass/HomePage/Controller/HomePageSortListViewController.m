//
//  HomePageSortListViewController.m
//  Emeat
//
//  Created by liuheshun on 2017/11/24.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "HomePageSortListViewController.h"
#import "HomePageTableViewCell.h"
#import "SortListSegmentView.h"
#import <PYSearch.h>

#import "AF_MainScreeningViewController.h"
#import "HomePageDetailsViewController.h"
#import "AF_ScreeningViewController.h"
#import "SelectAddressViewController.h"
#import "HomePageViewController.h"
#import "AppDelegate.h"
#define offset [UIScreen mainScreen].bounds.size.width - 84*kScale

@interface HomePageSortListViewController ()<UITableViewDelegate,UITableViewDataSource ,PYSearchViewControllerDelegate , AF_ScreeningViewControllerDelegate ,UIGestureRecognizerDelegate>
{
    UIView *shadeView;
    UIWindow *window;
}

@property (nonatomic,strong) HomePageNavView *homePageNavView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *leftButtons;
@property (nonatomic,strong) SortListSegmentView *segmentView;
///列表数据源
@property (nonatomic,strong) NSMutableArray *dataArray;
///筛选数据源
@property (nonatomic,strong) NSMutableArray *checkMarray;

@property (nonatomic,strong) NSString *statusStringURL;

@property (nonatomic,strong) UITapGestureRecognizer * tap;
@property (nonatomic,strong) NSString *minPrices;
@property (nonatomic,strong) NSString *maxPrices;
@property (nonatomic,strong) NSString *counStr;
@property (nonatomic,strong) NSString *kindStr;
@property (nonatomic,strong) NSString *weightStr;


///热搜标签数据
@property (nonatomic,strong) NSMutableArray *hotSearchMarray;
///历史搜索数据
@property (nonatomic,strong) NSMutableArray *historySearchMarray;




@end

@implementation HomePageSortListViewController
{
    NSInteger totalPage;//分页
    NSInteger totalPageCount;//分页总数
}

-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    [self.view addSubview:self.homePageNavView];
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.tableView];
    [self.homePageNavView addSubview:self.leftButtons];
    [self addSortAction];
    [self addChangeStatedBlockAction];
    self.checkMarray = [NSMutableArray array];
    self.hotSearchMarray = [NSMutableArray array];
    self.historySearchMarray = [NSMutableArray array];

    [self.homePageNavView.selectAddressBtn setTitle:self.currentLocation.name forState:0];
    CGFloat imageWidth = self.homePageNavView.selectAddressBtn.imageView.bounds.size.width;
    CGFloat labelWidth = self.homePageNavView.selectAddressBtn.titleLabel.bounds.size.width;
    self.homePageNavView.selectAddressBtn.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth);
    self.homePageNavView.selectAddressBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
    
    self.statusStringURL = @"2";
    self.dataArray = [NSMutableArray array];

    [self setupRefresh];
    [self requestCheckData];
    [self requestHotSearchData];
}




- (void)setupRefresh{
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.tableView.mj_header  = header;
    //header.lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
    //上拉加载
    //MJRefreshBackNormalFooter
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    self.tableView.mj_footer.automaticallyHidden = YES;

}


- (void)headerRereshing{
   
    
    totalPage=1;
    NSString *urlStr;
    if ([self.statusStringURL isEqualToString:@"0"]) {//价格
        urlStr = [NSString stringWithFormat:@"%@/m/mobile/commodity/ queryByCondition?positionId=%@&price=0&currentPage=%ld" ,baseUrl , self.ID ,totalPage];
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [self requestListData:urlStr totalPage:totalPage];

    }
    else if ([self.statusStringURL isEqualToString:@"1"])
    {
        urlStr = [NSString stringWithFormat:@"%@/m/mobile/commodity/queryByCondition?positionId=%@&price=1&currentPage=%ld" ,baseUrl , self.ID ,totalPage];
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [self requestListData:urlStr totalPage:totalPage];

    }
    else if ([self.statusStringURL isEqualToString:@"2"])//销量
    {
        urlStr = [NSString stringWithFormat:@"%@/m/mobile/commodity/queryByCondition?positionId=%@&sellNum=0&currentPage=%ld" ,baseUrl , self.ID  ,totalPage];
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [self requestListData:urlStr totalPage:totalPage];


    }
    else if ([self.statusStringURL isEqualToString:@"3"])
    {
        urlStr = [NSString stringWithFormat:@"%@/m/mobile/commodity/queryByCondition?positionId=%@&sellNum=1&currentPage=%ld" ,baseUrl , self.ID ,totalPage];
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [self requestListData:urlStr totalPage:totalPage];

    }else if ([self.statusStringURL isEqualToString:@"4"]){
        urlStr = [NSString stringWithFormat:@"%@/m/mobile/commodity/queryByCondition?currentPage=%ld",baseUrl ,totalPage];
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        [self confirmCheckAction:self.minPrices maxPrice:self.maxPrices countStr:self.counStr weightStr:self.weightStr kindStr:self.kindStr totalPage:totalPage URL:urlStr];
    }
    
    
    DLog(@"sssstssssss ===== url===== %@" ,urlStr);

    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
   
}


#pragma mark=====================上拉加载============================

- (void)footerRereshing{
    
    totalPage++;
    if (totalPage<=totalPageCount) {
        
        NSString *urlStr;
        if ([self.statusStringURL isEqualToString:@"0"]) {//价格
            urlStr = [NSString stringWithFormat:@"%@/m/mobile/commodity/ queryByCondition?positionId=%@&price=0&currentPage=%ld" ,baseUrl , self.ID ,totalPage];
            urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [self requestListData:urlStr totalPage:totalPage];

        }
        else if ([self.statusStringURL isEqualToString:@"1"])
        {
            urlStr = [NSString stringWithFormat:@"%@/m/mobile/commodity/queryByCondition?positionId=%@&price=1&currentPage=%ld" ,baseUrl , self.ID ,totalPage];
            urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [self requestListData:urlStr totalPage:totalPage];

        }
        else if ([self.statusStringURL isEqualToString:@"2"])//销量
        {
            urlStr = [NSString stringWithFormat:@"%@/m/mobile/commodity/queryByCondition?positionId=%@&sellNum=0&currentPage=%ld" ,baseUrl , self.ID  ,totalPage];
            urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [self requestListData:urlStr totalPage:totalPage];

            
        }
        else if ([self.statusStringURL isEqualToString:@"3"])
        {
            urlStr = [NSString stringWithFormat:@"%@/m/mobile/commodity/queryByCondition?positionId=%@&sellNum=1&currentPage=%ld" ,baseUrl , self.ID ,totalPage];
            urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [self requestListData:urlStr totalPage:totalPage];

        }else if ([self.statusStringURL isEqualToString:@"4"]){
            urlStr = [NSString stringWithFormat:@"%@/m/mobile/commodity/queryByCondition?currentPage=%ld",baseUrl ,totalPage];
            urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            
            [self confirmCheckAction:self.minPrices maxPrice:self.maxPrices countStr:self.counStr weightStr:self.weightStr kindStr:self.kindStr totalPage:totalPage URL:urlStr];
            
            
        }
        
        

        [self.tableView.mj_footer endRefreshing];
        
    }else{
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}











#pragma mark = 请求分类列表数据

-(void)requestListData:(NSString*)strURL totalPage:(NSInteger)totalPage{
    if (totalPage == 1) {
        [self.dataArray removeAllObjects];
    }
    
    //[MHAsiNetworkHandler startMonitoring];
    DLog(@"分类列表strURL==== %@" ,strURL);

    
    [MHNetworkManager postReqeustWithURL:strURL params:nil successBlock:^(NSDictionary *returnData) {
    
        
        DLog(@"分类列表===== %@" ,returnData);
        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"])
        {
            NSInteger pages = [returnData[@"data"][@"page"][@"totalPage"] integerValue];
            NSInteger pageSize = [returnData[@"data"][@"page"][@"pageSize"] integerValue];
            NSInteger total = [returnData[@"data"][@"page"][@"totalRecords"] integerValue];

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
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        }
        
        
        
    } failureBlock:^(NSError *error) {
        
        DLog(@"分类列表error===== %@" ,error);

    } showHUD:NO];
    
    
}

#pragma mark = 请求筛选标签数据

-(void)requestCheckData{
    NSMutableArray *countryMarray = [NSMutableArray array];
    NSMutableArray *weightMarray = [NSMutableArray array];
    NSMutableArray *kindMarray = [NSMutableArray array];
    [MHNetworkManager getRequstWithURL:[NSString stringWithFormat:@"%@/m/weightOriginVarieties?mtype=%@" ,baseUrl,mTypeIOS] params:nil successBlock:^(NSDictionary *returnData) {
        
        DLog(@"returnData筛选== %@" ,returnData);
        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"]) {
            ///品种parentId=5 原产地parentId=1 重量规格parentId=10

            for (NSDictionary *dic in returnData[@"data"]) {
                
                if ([dic[@"parentId"] integerValue] == 1) {;
                    
                    [countryMarray addObject:dic];
                    
                }else if ([dic[@"parentId"] integerValue] == 10){
                    
                    [weightMarray addObject:dic];

                }else if ([dic[@"parentId"] integerValue] == 5){
                    
                    [kindMarray addObject:dic];
                    
                }
            }
            self.checkMarray = [NSMutableArray arrayWithObjects:countryMarray , weightMarray , kindMarray, nil];

            [self.tableView reloadData];
        }
        
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
    
    
}



#pragma mark ================================= 热门搜索数据
-(void)requestHotSearchData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSInteger usrId = [[user valueForKey:@"userId"] integerValue];
    DLog(@"sous ==== url=== %@" , [NSString stringWithFormat:@"%@/m/search/get_top_search_and_history_search?customerId=%ld",baseUrl,usrId]);
    
    [MHNetworkManager getRequstWithURL:[NSString stringWithFormat:@"%@/m/search/get_top_search_and_history_search?customerId=%ld", baseUrl,usrId] params:nil successBlock:^(NSDictionary *returnData) {
        
        if ([returnData[@"status"] integerValue] == 200) {
            [self.hotSearchMarray addObjectsFromArray:returnData[@"data"][@"topSearchList"]];
            [self.historySearchMarray addObjectsFromArray:returnData[@"data"][@"historyList"]];
            DLog(@"====sss===== hotSearchMarray=== %@  historySearchMarray=%@" , returnData[@"data"][@"topSearchList"] , self.historySearchMarray);
            
            
            //////////数据库搜索历史数据写到本地(暂时去掉)
            //  [NSKeyedArchiver archiveRootObject:self.historySearchMarray toFile:PYSEARCH_SEARCH_HISTORY_CACHE_PATH];
            
            
        }
    } failureBlock:^(NSError *error) {
        
        DLog(@"%@" ,error);
    } showHUD:NO];
    
}


-(void)addSortAction{
    
    __weak __typeof(self) weakSelf = self;
    self.homePageNavView.sortBlock = ^{
        
        [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.homePageNavView.shadeBtn];
        [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.homePageNavView.tableView];
        weakSelf.homePageNavView.HomeArray = weakSelf.sortListMarray;

    };
    
    self.homePageNavView.selectSortIndexBlock = ^(NSInteger selectIndex) {
        [weakSelf.homePageNavView.tableView removeFromSuperview];
        [weakSelf.homePageNavView.shadeBtn removeFromSuperview];
        
        HomePageSortListViewController *VC = [HomePageSortListViewController new];
        DLog(@"%@" ,weakSelf.sortListMarray[selectIndex]);
        VC.selelctSortLable = weakSelf.sortListMarray[selectIndex][@"dataName"];
        VC.ID = weakSelf.sortListMarray[selectIndex][@"id"];
        VC.sortListMarray = weakSelf.sortListMarray;
        
        ///记录当前附近位置信息
        VC.currentLocation = weakSelf.currentLocation;
        VC.otherAddressArray = weakSelf.otherAddressArray;

        [weakSelf.navigationController pushViewController:VC animated:YES];
    };
    
#pragma mark ===============================搜索
    self.homePageNavView.searchBtnBlock = ^{
        NSArray *hotSeaches = [NSArray array];
        hotSeaches =  weakSelf.hotSearchMarray;
        // 2. Create a search view controller
        PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"请输入商品名称搜索", @"搜索") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
            // Called when search begain.
            // eg：Push to a temp view controller
            
            searchViewController.searchResultShowMode = PYSearchResultShowModeEmbed;
            searchViewController.showSearchResultWhenSearchBarRefocused = YES;

            SeacherViewController *sVc = [[SeacherViewController alloc] init];
            searchViewController.searchResultController = sVc;
            sVc.searchText = searchText;
            sVc.fromSortString = @"1";
            sVc.position = weakSelf.ID;
            
//            SeacherViewController *sVc = [[SeacherViewController alloc] init];
//            sVc.searchText = searchText;
//            sVc.fromSortString = @"1";
//            sVc.position = weakSelf.ID;
//
//            [searchViewController.navigationController pushViewController:sVc animated:YES];
//
//
            
            
        }];
        searchViewController.searchResultShowMode = PYSearchResultShowModeEmbed;
        
        searchViewController.showSearchHistory = YES;
        searchViewController.searchHistoryStyle = PYSearchHistoryStyleBorderTag;
        searchViewController.showHotSearch = YES;
        //        searchViewController.searchHistories = weakSelf.hotSearchMarray;
        searchViewController.delegate = weakSelf;
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        
        // 5. Present a navigation controller
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
        [weakSelf presentViewController:nav animated:YES completion:nil];
        
        
        
        DLog(@"搜索");
    };
    
    
    
#pragma makr = 选择地址
    
    self.homePageNavView.selectAddressBtnBlock = ^{
        
        SelectAddressViewController *VC = [SelectAddressViewController new];
        VC.hidesBottomBarWhenPushed = YES;
        VC.currentLocation = weakSelf.currentLocation;
        VC.otherAddressArray = weakSelf.otherAddressArray;
        
#pragma mark= 选择地址接收传值
        VC.selectAddressBL = ^(Location *currentLocations) {//地址传值
            DLog(@"区域=== %@" ,currentLocations.subLocality);
            weakSelf.currentLocation = currentLocations;

            [weakSelf.homePageNavView.selectAddressBtn setTitle:currentLocations.name forState:0];
            CGFloat imageWidth = weakSelf.homePageNavView.selectAddressBtn.imageView.bounds.size.width;
            CGFloat labelWidth = weakSelf.homePageNavView.selectAddressBtn.titleLabel.bounds.size.width;
            weakSelf.homePageNavView.selectAddressBtn.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth);
            weakSelf.homePageNavView.selectAddressBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
//
//            if ([currentLocations.city isEqualToString:@"上海市"] && ![currentLocations.subLocality isEqualToString:@"崇明区"]) {
//                DLog(@"在范围内");
//                weakSelf.isShowNoticeView = @"1";
//                [weakSelf.addressNoticeView removeFromSuperview];
//
//            }else{
//                DLog(@"-------------不在");
//                weakSelf.isShowNoticeView = @"0";
//                [weakSelf isShowNoticeViewFrame];
//            }
        };
        
        [weakSelf.navigationController pushViewController:VC animated:YES];
        DLog(@"选择收货地址");
    };
    
    
    
}





#pragma mark = segment点击事件
-(void)addChangeStatedBlockAction{
    __weak __typeof(self) weakSelf = self;
#pragma mark = 销量点击事件
    self.segmentView.countStatedBlock = ^(NSInteger sortNum) {
        [weakSelf.segmentView.checkBtn setTitleColor:RGB(138, 138, 138, 1) forState:0];
        weakSelf.tableView.bounces = YES;

        if (sortNum == 0)
        {
            weakSelf.statusStringURL = @"2";
        }else if (sortNum == 1)
        {
            weakSelf.statusStringURL = @"3";
        }
        if (weakSelf.tableView.mj_header.state == MJRefreshStateIdle) {
            [weakSelf setupRefresh];

        }
        
        
    };
#pragma mark = 价格点击事件

    self.segmentView.priceStatedBlock = ^(NSInteger sortNum) {
        [weakSelf.segmentView.checkBtn setTitleColor:RGB(138, 138, 138, 1) forState:0];
        weakSelf.tableView.bounces = YES;

        DLog(@"priceStatedBlock");
        if (sortNum == 0)
        {
            weakSelf.statusStringURL = @"0";
     
        }else if (sortNum == 1)
        {
            weakSelf.statusStringURL = @"1";

        }
        if (weakSelf.tableView.mj_header.state == MJRefreshStateIdle) {
            [weakSelf setupRefresh];
            
        }
        
    };
    
#pragma mark = 筛选点击事件

    self.segmentView.checkStatedBlock = ^(NSInteger sortNum) {
        
        
        DLog(@"checkStatedBlock");
        if (self.checkMarray.count != 0) {
            [weakSelf requestCheckData];
            [weakSelf requestHotSearchData];

            [weakSelf setCheckMainFrame];
        }
        weakSelf.statusStringURL = @"4";
    };
    
    
    
    
}

#pragma mark ===隐藏筛选视图
-(void)dismissWindow{
    //设置视图偏移
    [UIView animateWithDuration:.3 animations:^{
        CGRect rect = window.frame;
        rect.origin.x += (0);
        window.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    } completion:^(BOOL finished) {
        window.hidden = NO;
        window = nil;

        [shadeView removeFromSuperview];
        [self dismissViewControllerAnimated:NO completion:nil];
        

    }];
}

- (void)setCheckMainFrame {
    // Do any additional setup after loading the view.
    
    /** 点击视图关闭window */
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissWindow)];
    self.tap.delegate = self;
    shadeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 84*kScale, kHeight)];
    shadeView.backgroundColor = RGB(0, 0, 0, 0.4);
    [[UIApplication sharedApplication].keyWindow addSubview:shadeView];
    [shadeView addGestureRecognizer:self.tap];
    
    /** 加载window */
    window = [[UIWindow alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, offset, [UIScreen mainScreen].bounds.size.height)];
    //window.windowLevel =  UIWindowLevelStatusBar + 1;//此设置遮蔽状态栏
    window.hidden = NO;
    AF_ScreeningViewController * rvc = [[AF_ScreeningViewController alloc] init];
    rvc.width = offset;
    rvc.delegate = self;
    
    rvc.headTieleMarray = [NSMutableArray arrayWithObjects:@"价格区间"
                           ,@"原产地"
                           ,@"重量规格"
                           ,@"品种"
                           , nil];
    rvc.itemButtonMarray = self.checkMarray;
    window.rootViewController = rvc;
    //设置视图偏移
    [UIView animateWithDuration:.3 animations:^{
        CGRect rect = window.frame;
        rect.origin.x -= (offset);
        window.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (window) {
        return YES;
    }
    return NO;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press {
    if (window) {
        return YES;
    }
    return NO;
}


#pragma mark - AF_ScreeningViewController 代理
#pragma mark = 确定筛选 按钮事件

- (void)determineButtonTouchEvent:(NSString *)minPrices maxPrice:(NSString *)maxPrices countStr:(NSString *)couStr weightStr:(NSString *)weightStr kindStr:(NSString *)kindStr
{
    [self dismissWindow];

    self.tableView.bounces = NO;
    [self.tableView.mj_footer setHidden:YES];

    [self.segmentView.checkBtn setTitleColor:RGB(231, 35, 36, 1) forState:0];
    [self.segmentView.countBtn setImage:[UIImage imageNamed:@"huise"] forState:0];
    [self.segmentView.priceBtn setImage:[UIImage imageNamed:@"huise"] forState:0];
    
    self.minPrices = minPrices;
    self.maxPrices = maxPrices;
    self.counStr = couStr;
    self.weightStr = weightStr;
    self.kindStr = kindStr;
    totalPage = 1;
    NSString * urlStr = [NSString stringWithFormat:@"%@/m/mobile/commodity/queryByCondition?currentPage=%ld",baseUrl ,totalPage];
    [self confirmCheckAction:minPrices maxPrice:maxPrices countStr:couStr weightStr:weightStr kindStr:kindStr totalPage:totalPage URL:urlStr];
}

#pragma mark = 筛选请求=====

-(void)confirmCheckAction:(NSString *)minPrices maxPrice:(NSString *)maxPrices countStr:(NSString *)couStr weightStr:(NSString *)weightStr kindStr:(NSString *)kindStr totalPage:(NSInteger)total URL:(NSString*)urlStr{
   

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:couStr forKey:@"origin"];
    [dic setValue:weightStr forKey:@"size"];
    [dic setValue:kindStr forKey:@"breed"];
    [dic setValue:self.ID forKey:@"positionId"];
    [dic setValue:minPrices forKey:@"minPrice"];
    [dic setValue:maxPrices forKey:@"maxPrice"];


  
    DLog(@"筛选 列表dic== %@" ,dic);

    [MHNetworkManager postReqeustWithURL:urlStr params:dic successBlock:^(NSDictionary *returnData) {
        DLog(@"筛选 列表returnData== %@" ,returnData);

        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"]) {
            if (totalPage == 1) {
                [self.dataArray removeAllObjects];
            }
            NSInteger pages = [returnData[@"data"][@"page"][@"totalPage"] integerValue];
            NSInteger pageSize = [returnData[@"data"][@"page"][@"pageSize"] integerValue];
            NSInteger total = [returnData[@"data"][@"page"][@"totalRecords"] integerValue];

            for (NSDictionary *dic in returnData[@"data"][@"list"]) {
                HomePageModel *model = [HomePageModel yy_modelWithJSON:dic];
                DLog(@"筛选 列表== %@" ,model.mainImage);
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                
                if (mainImvMarray.count!=0)
                {
                    model.mainImage = [mainImvMarray firstObject];
                } 
                self.tableView.bounces = YES;

                model.pages = pages;
                model.pageSize = pageSize;
                model.total = total;
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        }
        
        
        
    } failureBlock:^(NSError *error) {
        DLog(@"筛选 列表error== %@" ,error);

        
    } showHUD:NO];
    
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    //    NSRange range = {0,jsonString.length};
    
    
    
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+ "];
    NSString * hmutStr = [[mutStr componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
    
    NSLog(@"humStr is %@",hmutStr);
    
    return hmutStr;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}







-(void)leftItemActions{

//        HomePageViewController *VC = [[HomePageViewController alloc] init];
//        [self.navigationController pushViewController:VC animated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
    
}


-(UIButton*)leftButtons{
    if (!_leftButtons) {
        _leftButtons = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButtons.frame = CGRectMake(0, kStatusBarHeight, kTopBarHeight, kTopBarHeight);
        [_leftButtons setImage:[UIImage imageNamed:@"fanhui_white"] forState:0];
        [_leftButtons addTarget:self action:@selector(leftItemActions) forControlEvents:1];
    }
        return _leftButtons;
}


-(HomePageNavView*)homePageNavView{
    if (!_homePageNavView) {
        _homePageNavView = [[HomePageNavView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kBarHeight+42)];
        _homePageNavView.backgroundColor = RGB(236, 31, 35, 1);
    }
    return _homePageNavView;
}

-(SortListSegmentView*)segmentView{
    if (!_segmentView) {
        _segmentView = [[SortListSegmentView alloc] initWithFrame:CGRectMake(0, MaxY(self.homePageNavView), kWidth, 40)];
        _segmentView.backgroundColor = [UIColor whiteColor];

    }
    return _segmentView;
}


-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MaxY(self.homePageNavView)+40, kWidth, kHeight-kBarHeight- 82-kBottomBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tag = 100;
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
    return 135;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.01;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.01)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.01)];
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomePageTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"sortList_cell"];
    if (cell1 == nil) {
        cell1 = [[HomePageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sortList_cell"];
        
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
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
//            [weakSelf cutCartPostDataWithProductId:model.id homePageModel:model NSIndexPath:indexPath cell:weakCell];///减去购物车
//            
//            
//        }else{
//            
//            
//            ///删除整个商品
//            [weakSelf deleteProductPostDataWithProductId:model.id homePageModel:model tableView:weakSelf.tableView];
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




#pragma mark = 加入购物车按钮


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
        ///[cell1.cartBtn removeFromSuperview];
        
        if (self.dataArray.count != 0)
        {
            HomePageModel *model = self.dataArray[myIndex.row];
            
            [self addCartPostDataWithProductId:model.id homePageModel:model NSIndexPath:myIndex cell:cell1 isFirstClick:YES tableView:self.tableView];
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:myIndex.row inSection:myIndex.section];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
        }
        
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
