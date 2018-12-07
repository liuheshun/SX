//
//  HomePageViewController.m
//  Emeat
//
//  Created by liuheshun on 2017/11/6.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomePageTableViewCell.h"
#import "HomePageDetailsViewController.h"
#import "HomePageSortListViewController.h"
#import "PYSearch.h"
#import "SelectAddressViewController.h"
#import "RHLocation.h"
#import "DDSearchManager.h"
#import "HomePageModel.h"
#import "HomePageAddressNoticeView.h"
#import "HomePageOtherDetailsViewController.h"
#import "JMHoledView.h"
#import "HWPopTool.h"
#import "VersionUpdateView.h"
///////////////
#import "OneViewTableTableViewController.h"
#import "MainTouchTableTableView.h"
#import "ParentClassScrollViewController.h"
#import "WMPageController.h"
#import "HomePageHeadSortView.h"
#import "GYChangeTextView.h"
#import "MessageCenterViewController.h"

#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
#define headViewHeight 408*kScale
#import "MerchantViewController.h"


@interface HomePageViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,PYSearchViewControllerDelegate,CLLocationManagerDelegate,RHLocationDelegate ,JMHoledViewDelegate ,scrollDelegate,WMPageControllerDelegate ,GYChangeTextViewDelegate>

///导航栏视图
@property (nonatomic,strong) HomePageNavView *navView;
///商品列表数据源
@property (nonatomic,strong) NSMutableArray *dataArray;//商品列表数据源
///轮播图
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;


///记录当前位置信息
@property (nonatomic,strong) Location *currentLocation;
@property (nonatomic,strong) NSString *currentAddressSubLocality;
///记录当前附近位置信息
@property (nonatomic,strong) NSMutableArray *otherAddressArray;
@property (nonatomic,strong) RHLocation *rhLocation;



///banner轮播图数据源
@property (nonatomic,strong) NSMutableArray *bannerMarray;
///分类标签数据源字典
@property (nonatomic,strong) NSMutableArray *sortListMarray;
///地址提示视图
@property (nonatomic,strong) HomePageAddressNoticeView *addressNoticeView;
///地址提示视图 0不在配送范围内显示 , 1 在配送范围内不显示
@property (nonatomic,strong) NSString *isShowNoticeView;
///热搜标签数据
@property (nonatomic,strong) NSMutableArray *hotSearchMarray;
///历史搜索数据
@property (nonatomic,strong) NSMutableArray *historySearchMarray;
///主tableview
@property(nonatomic ,strong)MainTouchTableTableView * mainTableView;
@property(nonatomic,strong) UIScrollView * parentScrollView;
///头部背景图片
@property(nonatomic,strong)UIImageView *headImageView;
/// canScroll= yes : mainTableView 视图可以滚动，parentScrollView 禁止滚动
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveMainTableView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveParentScrollView;
///头部分类视图
@property (nonatomic,strong) HomePageHeadSortView *homePageHeadSortView;
///segment标题
@property (nonatomic,strong) NSMutableArray *segmentTitleMarray;
@property (nonatomic,strong) WMPageController *pageVC;
///首页分类数据
@property (nonatomic,strong) NSMutableArray *homePageSortDataMarray;
///播报数据
@property (nonatomic,strong) NSMutableArray *PlayTextDataMarray;

///显示当前定位
@property (nonatomic,strong) UIButton *showCurrentAddressBtn;
@property (nonatomic,strong) UILabel *showCurrentAddressLabel;


///是否已加载segment
@property (nonatomic,strong) NSString *isLoadingSeg;

///
@property (nonatomic,strong) NSString *isleaveCurrentVc;


@property (nonatomic,assign) NSInteger selectIndex;

@property (nonatomic,strong) NSString *defaultIndex;

@end

@implementation HomePageViewController
{

    NSInteger totalPage;//分页
    NSInteger totalPageCount;//分页总数
    NSInteger isFirstLoading;
}


-(void)viewWillAppear:(BOOL)animated{

    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    if (status == RealStatusNotReachable)
    {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
   
    
    [self requestStoreStatedData];
    [self requestBadNumValue];
    [self requestFirstLevelData];
    [self requestHomePageSortData];
    [self requestPlayTextData];
    
    [self requsetHomPageBannerData];
    [self requestHotSearchData];
    
    
   
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
    self.isLoadingSeg = @"1";
    self.isleaveCurrentVc = @"1";
//    [GlobalHelper shareInstance].selectAddressString = self.showCurrentAddressl.titleLabel.text;
    [GlobalHelper shareInstance].selectAddressString = self.showCurrentAddressLabel.text;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self requestLocation];//请求当前位置信息

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelectIndexss:)name:@"selectIndex" object:nil];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:@"0" forKey:@"selectIndex"];
    

    ///版本更新通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkVersionUpdate)name:@"versionUpdate" object:nil];

    
   // self.selectIndex = 0;
    self.isLoadingSeg = @"1";
    self.isleaveCurrentVc = @"0";
    self.defaultIndex = @"1";
    self.sortListMarray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    self.bannerMarray = [NSMutableArray array];
    self.hotSearchMarray = [NSMutableArray array];
    self.historySearchMarray = [NSMutableArray array];
    self.segmentTitleMarray = [NSMutableArray array];
    
    self.homePageSortDataMarray = [NSMutableArray array];
    self.PlayTextDataMarray = [NSMutableArray array];
    isFirstLoading = 0;

    
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.navView];
    [self.mainTableView addSubview:self.headImageView];
    [self setCycleScrollViews:self.headImageView];
    [self.headImageView addSubview:self.homePageHeadSortView];
    [self.headImageView addSubview:self.showCurrentAddressBtn];
    
    [self addSortClickAction];
    [self addNavigationHeadBlockAction];
    /*
     如果您的项目需要头部视图实现一些动效,不需要下拉刷新效果
     
     1.您需要修改demo中MainViewController ,viewDidLoad 中  设置self.mainTableView.bounces = YES;
     2.需要修改MainViewController,- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
     
     //        if (!self.canScroll){
     //支持下刷新,下拉时maintableView 没有滚动到位置 parentScrollView 不进行刷新
     //            CGFloat parentScrollViewOffsetY = self.parentScrollView.contentOffset.y;
     //            if(parentScrollViewOffsetY >0)
     //                self.parentScrollView.contentOffset = CGPointMake(0, 0);
     //        }else
     //        {
     self.parentScrollView.contentOffset = CGPointMake(0, 0);
     //        }
     }
     
     删除这段代码中注释部分,也就是else中只保留 self.parentScrollView.contentOffset = CGPointMake(0, 0);
     */
    //支持下刷新。关闭弹簧效果
    self.mainTableView.bounces =  NO;
    self.canScroll = YES;

    ///禁止右滑返回
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
   
}

-(void)changeSelectIndexss:(NSNotification*)notInfo{
    self.pageVC.selectIndex = [notInfo.object intValue];

}

#pragma mark ===========添加分类点击事件


-(void)addSortClickAction{
    __weak __typeof(self) weakSelf = self;

    self.homePageHeadSortView.returnClickSortIndex = ^(NSInteger index, NSString *sortTitle) {
        
        HomePageModel *model = weakSelf.homePageSortDataMarray[index];
        
        HomePageSortListViewController *VC = [HomePageSortListViewController new];
        VC.segmentTitleMarray = weakSelf.segmentTitleMarray;
        VC.sortId = model.bigClassifyId;
        VC.sortType = model.type;
        VC.hotSearchMarray = weakSelf.hotSearchMarray;
        if (index == 9) {
            VC.sortId = 9999;
            VC.sortType = @"STAIR";
        }
       
        VC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:VC animated:YES];
    };
}



#pragma mark ================================= 热门搜索数据
-(void)requestHotSearchData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSInteger usrId = [[user valueForKey:@"userId"] integerValue];

   
    
    [MHNetworkManager getRequstWithURL:[NSString stringWithFormat:@"%@/m/search/get_top_search_and_history_search?customerId=%ld&appVersionNumber=%@&user=%@&showType=SOGO", baseUrl,usrId ,[user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"] ] params:nil successBlock:^(NSDictionary *returnData) {

        if ([returnData[@"status"] integerValue] == 200) {
            [self.hotSearchMarray removeAllObjects];
            [self.historySearchMarray removeAllObjects];

            [self.hotSearchMarray addObjectsFromArray:returnData[@"data"][@"topSearchList"]];
            [self.historySearchMarray addObjectsFromArray:returnData[@"data"][@"historyList"]];


          //////////数据库搜索历史数据写到本地(暂时去掉)
       //  [NSKeyedArchiver archiveRootObject:self.historySearchMarray toFile:PYSEARCH_SEARCH_HISTORY_CACHE_PATH];


        }
    } failureBlock:^(NSError *error) {

    } showHUD:NO];

}

#pragma mark ============== 检查版本更新

-(void)checkVersionUpdate{

    [self requestVersionUpdateData];
}

-(void)requestVersionUpdateData{
    //http://192.168.0.200:8080/m/appversion/index.jhtml?appType=1
    
    
   
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [MHNetworkManager getRequstWithURL:[NSString stringWithFormat:@"%@/m/appversion/index.jhtml?appType=2&mtype=%@&appVersionNumber=%@&user=%@" ,baseUrl,mTypeIOS ,[user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"]] params:nil successBlock:^(NSDictionary *returnData) {

        if ([returnData[@"code"] isEqualToString:@"00"]) {
            
            
            NSString *localVerson= [[[NSBundle mainBundle]infoDictionary ]objectForKey:@"CFBundleShortVersionString"];//当前本地app版本号
            
            //将版本号按照.切割后存入数组中
            NSMutableArray *localArray = [NSMutableArray arrayWithArray:[localVerson componentsSeparatedByString:@"."]] ;
            
            NSMutableArray *appArray = [NSMutableArray arrayWithArray:[[NSString stringWithFormat:@"%@" ,returnData[@"version"]] componentsSeparatedByString:@"."]];
            
            // 补全版本信息为相同位数
            while (localArray.count < appArray.count) {
                [localArray addObject:@"0"];
            }
            while (appArray.count < localArray.count) {
                [appArray addObject:@"0"];
            }
            
            BOOL needUpdate = NO;
            
            for(NSUInteger i = 0; i < localArray.count; i++){
                
                NSInteger localversionNumber1 = [localArray[i] integerValue];
                NSInteger versionNumber2 = [appArray[i] integerValue];
                if (localversionNumber1 < versionNumber2) {
                    needUpdate = YES;
                    break;
                }
                else if (versionNumber2 < localversionNumber1){
                    needUpdate = NO;
                    break;
                }
                else{
                    needUpdate = NO;
                }
            }
 
            
            if (needUpdate) {
                
                VersionUpdateViewConfig *config = [VersionUpdateViewConfig UpdateViewConfig];
                config.imageString = @"versionUpdate";
                config.titleString = returnData[@"content"];
                config.isShowCancelBtn = returnData[@"isForce"];
                if ([returnData[@"isForce"] isEqualToString:@"true"]) {//强制更新
                    VersionUpdateView *upView = [[VersionUpdateView alloc] initWithFrame:CGRectMake((kWidth-295*kScale)/2, 150*kScale, 295*kScale, kHeight-100*kScale)];
                    [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeNone;
                    [HWPopTool sharedInstance].tapOutsideToDismiss = NO;
                    [[HWPopTool sharedInstance] showWithPresentView:upView animated:NO];
                    
                }else{//非强制更新 只出现一次
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    if ([[user valueForKey:@"isFirst"] isEqualToString:@"second"]) {
                        
                    }else{
                        VersionUpdateView *upView = [[VersionUpdateView alloc] initWithFrame:CGRectMake((kWidth-295*kScale)/2, 0, 295*kScale, kHeight-20*kScale)];
                        //                        upView.backgroundColor = [UIColor cyanColor];
                        [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeNone;
                        [HWPopTool sharedInstance].tapOutsideToDismiss = NO;
                        [[HWPopTool sharedInstance] showWithPresentView:upView animated:NO];
                        [user setValue:@"second" forKey:@"isFirst"];
                    }
                }
                
                
            }
            
            
            
            
        }

    } failureBlock:^(NSError *error) {


    } showHUD:NO];



}


#pragma mark = 添加搜索 消息 定位 点击事件

-(void)addNavigationHeadBlockAction{
    __weak __typeof(self) weakSelf = self;

    #pragma mark = 消息点击 block事件

    self.navView.sortBlock = ^{

//        MerchantViewController *VC = [MerchantViewController suspendTopPageVC];
//        VC.hidesBottomBarWhenPushed = YES;
//        [weakSelf.navigationController pushViewController:VC animated:YES];
//        DLog(@"消息");

        MessageCenterViewController *VC = [MessageCenterViewController new];
        VC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:VC animated:YES];

    };
  
#pragma mark ============================== 搜索商品


    self.navView.searchBtnBlock = ^{

        NSArray *hotSeaches = [NSArray array];
        hotSeaches =  weakSelf.hotSearchMarray;
        // 2. Create a search view controller
        [GlobalHelper shareInstance].showType= @"SOGO";

        PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"请输入商品名称搜索", @"搜索") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {


            searchViewController.searchResultShowMode = PYSearchResultShowModeEmbed;
            searchViewController.showSearchResultWhenSearchBarRefocused = YES;

            SeacherViewController *sVc = [[SeacherViewController alloc] init];

            searchViewController.searchResultController = sVc;
            sVc.fromSortString = @"0";
            sVc.showType = @"SOGO";
            sVc.searchText = searchText;

//
//            SeacherViewController *sVc = [[SeacherViewController alloc] init];
//            sVc.searchText = searchText;
//            [searchViewController.navigationController pushViewController:sVc animated:YES];


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



    };


#pragma makr ==============================  选择地址


    _navView.selectAddressBtnBlock = ^{

        SelectAddressViewController *VC = [SelectAddressViewController new];
        VC.hidesBottomBarWhenPushed = YES;

#pragma mark============================== 选择地址接收传值

        VC.selectAddressBL = ^(Location *currentLocations) {//地址传值

            weakSelf.currentLocation = currentLocations;
           // [weakSelf.showCurrentAddressBtn setTitle:currentLocations.name forState:0];
            weakSelf.showCurrentAddressLabel.text = currentLocations.name;

            if ([currentLocations.city containsString:@"上海市"] && ![currentLocations.subLocality containsString:@"崇明区"]) {
               //         DLog(@"在范围内");
                weakSelf.isShowNoticeView = @"1";
                [weakSelf.addressNoticeView removeFromSuperview];
            }else{
                //DLog(@"-------------不在");
                weakSelf.isShowNoticeView = @"0";
               [weakSelf.cycleScrollView addSubview:weakSelf.addressNoticeView];
            }
        };


        [weakSelf.navigationController pushViewController:VC animated:YES];

       // DLog(@"选择收货地址");


    };
}


#pragma mark = ===================商品banner轮播图数据

-(void)requsetHomPageBannerData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

    [MHNetworkManager getRequstWithURL:[NSString stringWithFormat:@"%@/m/banner/queryBannerForWeb?mtype=%@&appVersionNumber=%@&user=%@" ,baseUrl ,mTypeIOS ,[user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"]] params:nil successBlock:^(NSDictionary *returnData) {
      //   DLog(@"bannertu=====%@" ,returnData);

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





#pragma mark ======首页分类数据 =======

-(void)requestHomePageSortData{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [MHNetworkManager getRequstWithURL:[NSString stringWithFormat:@"%@/m/classify/get_home_classify?appVersionNumber=%@&user=%@" ,baseUrl ,[user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"]] params:nil successBlock:^(NSDictionary *returnData) {
        //DLog(@"=首页分类数据 = %@" ,returnData);
        if ([returnData[@"status"] integerValue] == 200) {
            [self.homePageSortDataMarray removeAllObjects];
            for (NSDictionary *dic in returnData[@"data"]) {
                HomePageModel *model = [HomePageModel yy_modelWithJSON:dic];

                [self.homePageSortDataMarray addObject:model];
            }
            ///手动添加更多分类
            HomePageModel *model = [HomePageModel new];
            model.classifyName = @"更多分类";
            [self.homePageSortDataMarray addObject:model];
            [self.mainTableView reloadData];
        }
        
        [self.homePageHeadSortView setHomePageSortUIButtions:self.homePageSortDataMarray];

        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
    
}

#pragma mark ====  一级分类标签数据 ====

-(void)requestFirstLevelData{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
   
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];

    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/classify/get_classifys" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
       // DLog(@"一级分类标签数据 = %@" ,returnData);
        if ([returnData[@"status"] integerValue] == 200) {
            [self.segmentTitleMarray removeAllObjects];
            ///初始数据
            NSArray *titleArray = @[@{@"classifyName":@"经常买"} ,@{@"classifyName":@"大家都在买"} ,@{@"classifyName":@"赛鲜精选"}];
            for (NSDictionary *dic in titleArray) {
                HomePageModel *model = [HomePageModel yy_modelWithJSON:dic];
                [self.segmentTitleMarray addObject:model];
            }
            
            
            for (NSDictionary *dic in returnData[@"data"]) {
                HomePageModel *model = [HomePageModel yy_modelWithJSON:dic];
                NSString *bigClassifyId = dic[@"id"];
                model.bigClassifyId = [bigClassifyId integerValue];
                [self.segmentTitleMarray addObject:model];
            }
            [self.mainTableView reloadData];
        }
        
        
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
    
}

#pragma mark ================== 获取播报数据

-(void)requestPlayTextData{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [MHNetworkManager getRequstWithURL:[NSString stringWithFormat:@"%@/m/roll/get_roll_order?appVersionNumber=%@&user=%@" ,baseUrl, [user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"]] params:nil successBlock:^(NSDictionary *returnData) {
        
       // DLog(@"获取播报数据=====%@" ,returnData);
        if ([returnData[@"status"] integerValue] == 200) {
            [self.PlayTextDataMarray removeAllObjects];
            for (NSDictionary *dic in returnData[@"data"]) {
                HomePageModel *model = [HomePageModel yy_modelWithJSON:dic];
                [self.PlayTextDataMarray addObject:model];
                
            }
            [self addChangeTextView];

            [self.mainTableView reloadData];
        }
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
    
}




#pragma mark =============检验店铺是否认证

-(void)requestStoreStatedData{
    
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
    [dic setValue:mTypeIOS forKey:@"mtype"];
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    //DLog(@"账号店铺是否登录认证= %@" ,dic);
    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/mobile/store/get_store" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
       // DLog(@"账号店铺是否登录认证hhhh= %@" ,returnData);
        
        if ([returnData[@"code"]  isEqualToString:@"0404"] || [returnData[@"code"]  isEqualToString:@"04"]) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:@"0" forKey:@"isLoginState"];
            [user setValue:@"2" forKey:@"approve"];

        }
        
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic = returnData[@"data"];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        if (dic) {
            [user setValue:[NSString stringWithFormat:@"%ld" ,[dic[@"isApprove"] integerValue]] forKey:@"approve"];
        }else{
            [user setValue:@"2" forKey:@"approve"];
            
        }
        
        [self.mainTableView reloadData];

    } failureBlock:^(NSError *error) {
       // DLog(@"账号店铺是否登录认证= %@" ,error);
        
    } showHUD:NO];
    
    
}



/////////////////////////
///
/////////
///////////////////////
#pragma mark = 提前请求当前定位位置信息

-(void)requestLocation{
    
    [[GlobalHelper shareInstance] openLocationServiceWithBlock:^(BOOL isOpen) {
        if (isOpen == YES) {
            [self setLocations];
            
        }else{
            //            DLog(@"----------无定位权限-------------");
            //            [SVProgressHUD showErrorWithStatus:@"请开启定位权限"];
            
            [self.addressNoticeView removeFromSuperview];
        }
        
    }];
    
    
}
#pragma mark = =========================定位

-(void)setLocations{
    self.rhLocation = [[RHLocation alloc] init];
    self.rhLocation.delegate = self;
    [self.rhLocation beginUpdatingLocation];
}

- (void)locationDidEndUpdatingLocation:(Location *)location{
    self.currentAddressSubLocality = location.subLocality;

    self.currentLocation = location;

   // [self.showCurrentAddressBtn setTitle:location.name forState:0];
    self.showCurrentAddressLabel.text = location.name;
    [self getAddresspoiWithLocation:location];

    ///判断当前地址是否在配送范围内
    if ([location.city isEqualToString:@"上海市"] && ![location.subLocality isEqualToString:@"崇明区"]) {
        //DLog(@"请求在范围内");
        [self.addressNoticeView removeFromSuperview];
        self.isShowNoticeView = @"1";


    }else{
        //DLog(@"请求不在");
        self.isShowNoticeView = @"0";
        [self.cycleScrollView addSubview:self.addressNoticeView];

    }


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
                locat.administrativeArea = self.currentLocation.administrativeArea;

//                locat.administrativeArea = poi.province;
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




#pragma scrollDelegate
-(void)scrollViewLeaveAtTheTop:(UIScrollView *)scrollView
{
    self.parentScrollView = scrollView;
    
    //离开顶部 主View 可以滑动
    self.canScroll = YES;
}

-(void)scrollViewChangeTab:(UIScrollView *)scrollView
{
    self.parentScrollView = scrollView;
    /*
     * 如果已经离开顶端 切换tab parentScrollView的contentOffset 应该初始化位置
     * 这一规则 仿简书
     */
    if (self.canScroll) {
        self.parentScrollView.contentOffset = CGPointMake(0, 0);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    /*
     *  处理联动事件
     */
    
    //获取滚动视图y值的偏移量
    CGFloat tabOffsetY = 0;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY >=headViewHeight) {
        
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        offsetY = tabOffsetY;
    }
    
    self.isTopIsCanNotMoveParentScrollView = self.isTopIsCanNotMoveMainTableView;
    
    
    if (offsetY>=tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        self.isTopIsCanNotMoveMainTableView = YES;
    }else{
        self.isTopIsCanNotMoveMainTableView = NO;
    }
    
    if (self.isTopIsCanNotMoveMainTableView != self.isTopIsCanNotMoveParentScrollView) {
        if (!self.isTopIsCanNotMoveParentScrollView && self.isTopIsCanNotMoveMainTableView) {
            //滑动到顶端
            self.canScroll = NO;
        }
        
        if(self.isTopIsCanNotMoveParentScrollView && !self.isTopIsCanNotMoveMainTableView){
            //离开顶端
            if (!self.canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }else{
                self.parentScrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }else{
        if (!self.canScroll){
            //支持下刷新,下拉时maintableView 没有滚动到位置 parentScrollView 不进行刷新
            CGFloat parentScrollViewOffsetY = self.parentScrollView.contentOffset.y;
            if(parentScrollViewOffsetY >0)
                self.parentScrollView.contentOffset = CGPointMake(0, 0);
        }else
        {
            self.parentScrollView.contentOffset = CGPointMake(0, 0);
        }
    }
    
   // DLog(@"offsetY=== %f     " ,offsetY );
    
    if (offsetY >= -220*kScale) {
        [UIView animateWithDuration:0.4  animations:^{
            self.showCurrentAddressBtn.hidden = YES;
            self.navView.selectAddressBtn.hidden = NO;
            CGRect rect = self.navView.searchBtn.frame;
            rect.origin.x = MaxX(self.navView.selectAddressBtn)+10*kScale;
            rect.size.width = 210*kScale;
            self.navView.searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, kWidth-190*kScale, 0, 0);
            [self.navView.selectAddressBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:5*kScale];
            
            self.navView.searchBtn.frame = rect;
            
        }];
       
        
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.showCurrentAddressBtn.hidden = NO;
            self.navView.selectAddressBtn.hidden = YES;
            CGRect rect = self.navView.searchBtn.frame;
            
           // CGRectMake(60*kScale,kStatusBarHeight+5, kWidth-110*kScale, 30*kScale);
            
            rect.origin.x = 60*kScale;
            rect.origin.y = kStatusBarHeight+5;
            rect.size.height = 30*kScale;
            rect.size.width = kWidth-110*kScale;
            self.navView.searchBtn.frame = rect;
            self.navView.searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, kWidth-140*kScale, 0, 0);
            
        }];
        

        
    }
    
  
}






#pragma mark --tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Main_Screen_Height-64;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return <#expression#>
//}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 200)];
//    view.backgroundColor = [UIColor redColor];
//    return view;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /* 添加pageView
     * 这里可以任意替换你喜欢的pageView
     *作者这里使用一款github较多人使用的 WMPageController 地址https://github.com/wangmchn/WMPageController
     */
  
    [cell.contentView addSubview:self.pageVC.view];

    return cell;
}


#pragma mark -- setter/getter


-(WMPageController *)pageVC{
    if (_pageVC == nil) {
        
        NSMutableArray *viewControllers = [NSMutableArray array];
        if (self.segmentTitleMarray.count >3) {
            for (int i =0; i<self.segmentTitleMarray.count; i++) {
                OneViewTableTableViewController * oneVc  = [OneViewTableTableViewController new];
                oneVc.delegate = self;
                oneVc.titleModelMarray = self.segmentTitleMarray;
                if (i == 0) {
                    oneVc.isFirsrEnter = 1;
                    oneVc.isLoading = 1;
                }
                [viewControllers addObject:oneVc];
                
            }
            NSMutableArray *titleMarray = [NSMutableArray array];
            NSMutableArray *widthMarray = [NSMutableArray array];
            for (HomePageModel*model in self.segmentTitleMarray) {
                [titleMarray addObject:model.classifyName];
                
                ///计算文字宽度
                CGSize textSize1 = [model.classifyName sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15*kScale]}];
                [widthMarray addObject:[NSString stringWithFormat:@"%f" ,textSize1.width]];
            }
            
            self.pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titleMarray];
            [self.pageVC setViewFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
            self.pageVC.delegate = self;
            //self.pageVC.menuItemWidth = 100;
            self.pageVC.itemsWidths = widthMarray;
            self.pageVC.menuHeight = 44;
            //self.pageVC.menuViewBottomSpace = 10;
            self.pageVC.postNotification = YES;
            self.pageVC.bounces = YES;
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//
//            self.pageVC.selectIndex = [[user valueForKey:@"selectIndex"] intValue];
            self.pageVC.selectIndex = 0;
                _pageVC.title = @"Line";
                _pageVC.menuViewStyle = WMMenuViewStyleLine;
                _pageVC.titleSizeSelected = 15*kScale;
                _pageVC.titleSizeNormal = 15*kScale;
                _pageVC.menuBGColor = [UIColor whiteColor];
                _pageVC.titleColorSelected = RGB(231, 35, 36, 1);
                _pageVC.titleColorNormal = RGB(136, 136, 136, 1);
                _pageVC.progressColor = RGB(231, 35, 36, 1);
                //_pageVC.menuViewContentMargin = 15;
                _pageVC.itemMargin = 15;
            
                [self addChildViewController:self.pageVC];
                [self.pageVC didMoveToParentViewController:self];

            
    }
    }

        return _pageVC;
}


-(void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{
    ///发送通知给子控制器
    if ([info[@"index"] intValue] == 0) {
        if ([self.isleaveCurrentVc isEqualToString:@"1"]) {
           // NSLog(@"显示显示 %@  === %@ ",viewController ,info);
            self.isleaveCurrentVc = @"0";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"sortRefresh" object:@"one" userInfo:info];
            //NSLog(@"显示显示 %@  === %@ ",viewController ,info);
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:info[@"index"] forKey:@"selectIndex"];
            self.isLoadingSeg = @"0";
        }else{
        if ([self.isLoadingSeg isEqualToString:@"1"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"sortRefresh" object:@"one" userInfo:info];
           // NSLog(@"显示显示 %@  === %@ ",viewController ,info);
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:info[@"index"] forKey:@"selectIndex"];
            self.isLoadingSeg = @"0";
        }
            
        }
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sortRefresh" object:@"one" userInfo:info];
        //NSLog(@"显示显示 %@  === %@ ",viewController ,info);
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setValue:info[@"index"] forKey:@"selectIndex"];
        self.isLoadingSeg = @"1";

    }
}

- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
   
}

- (void)pageController:(WMPageController *)pageController lazyLoadViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{
    if ([self.defaultIndex isEqualToString:@"1"]) {
        self.pageVC.selectIndex = 1;
        self.defaultIndex = @"2";
    }

    
}



#pragma mark ===============添加播报视图view

-(void)addChangeTextView{
    UIImageView *playImage = [[UIImageView alloc] initWithFrame:CGRectMake(15*kScale, MaxY(self.homePageHeadSortView)+8*kScale, 35*kScale, 34*kScale)];
    playImage.image = [UIImage imageNamed:@"saixianbobao"];
    [self.headImageView addSubview:playImage];
    GYChangeTextView *tView = [[GYChangeTextView alloc] initWithFrame:CGRectMake(MaxX(playImage)+25*kScale, MaxY(self.homePageHeadSortView), kWidth-140*kScale, 50*kScale)];
    tView.delegate = self;
    tView.backgroundColor =  RGB(238, 238, 238, 1);
    [self.headImageView addSubview:tView];
    //self.tView = tView;
    NSArray * listArray = self.PlayTextDataMarray;
    [tView animationWithTexts:listArray];
    
    
}



-(UIImageView *)headImageView
{
    if (_headImageView == nil)
    {
        _headImageView= [[UIImageView alloc] init];
        _headImageView.frame=CGRectMake(0, -headViewHeight ,Main_Screen_Width,headViewHeight);
        _headImageView.userInteractionEnabled = YES;
        
        
    }
    return _headImageView;
}



-(MainTouchTableTableView *)mainTableView
{
    if (_mainTableView == nil)
    {
        _mainTableView= [[MainTouchTableTableView alloc]initWithFrame:CGRectMake(0,kBarHeight,Main_Screen_Width,Main_Screen_Height-kBarHeight)];
        _mainTableView.delegate=self;
        _mainTableView.dataSource=self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.contentInset = UIEdgeInsetsMake(headViewHeight,0, 0, 0);
        _mainTableView.backgroundColor = [UIColor clearColor];
    }
    return _mainTableView;
}








#pragma mark ==========================首页轮播图

- (void )setCycleScrollViews:(UIImageView*)headImageview{
    
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kWidth, 176*kScale) delegate:self placeholderImage:[UIImage imageNamed:@"banner加载"]];   //placeholder
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.cycleScrollView.showPageControl = YES;//是否显示分页控件
    self.cycleScrollView.currentPageDotColor = [UIColor orangeColor]; // 自定义分页控件小圆标颜色
    self.cycleScrollView.tag = 1;
    
    [headImageview addSubview:self.cycleScrollView];
}


#pragma mark ===================== 轮播图点击事件

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{

    HomePageDetailsViewController *VC = [HomePageDetailsViewController new];
    VC.hidesBottomBarWhenPushed = YES;

    HomePageOtherDetailsViewController *otherVC = [HomePageOtherDetailsViewController new];
    otherVC.hidesBottomBarWhenPushed = YES;


    if (self.bannerMarray.count!=0) {
        HomePageModel *model = self.bannerMarray[index];

      //  DLog(@"轮播图详情页======= %@" ,model.bannerUrl);

        if ([model.bannerUrl containsString:@"SP"]) {
            VC.fromBaner = @"1";
            VC.detailsId = model.bannerUrl;
            VC.isFromBORC = @"b";

            [self.navigationController pushViewController:VC animated:YES];
        }
        else
        {
            if ([model.bannerUrl containsString:@"get_coupon"]) {
                otherVC.detailsURL = [NSString stringWithFormat:@"%@/breaf/get_coupon_ios.html" ,baseUrl];
            }else{
                otherVC.detailsURL = model.bannerUrl;
            }
          //  DLog(@"轮播图详情页外部外部链接======= %@" ,otherVC.detailsURL);
            [self.navigationController pushViewController:otherVC animated:YES];

        }

    }


}


#pragma mark========分类视图
-(HomePageHeadSortView *)homePageHeadSortView{
    if (_homePageHeadSortView == nil) {
        _homePageHeadSortView = [[HomePageHeadSortView alloc] initWithFrame:CGRectMake(0, 176*kScale, kWidth, 182*kScale)];
        _homePageHeadSortView.backgroundColor = [UIColor whiteColor];
        
    }
    return _homePageHeadSortView;
}



#pragma mark ================== navigation视图

-(HomePageNavView*)navView{
    if (!_navView) {
        _navView = [[HomePageNavView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kBarHeight)];
        _navView.backgroundColor = RGB(236, 31, 35, 1);
    }
    return _navView;
}
#pragma mark ================== 不在配送范围内提示视图
-(HomePageAddressNoticeView*)addressNoticeView{
    if (!_addressNoticeView) {
        _addressNoticeView = [[HomePageAddressNoticeView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 29*kScale)];
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
       // [self.navView.selectAddressBtn setTitle:currentLocations.name forState:0];
       // [self.showCurrentAddressBtn setTitle:currentLocations.name forState:0];
        self.showCurrentAddressLabel.text = currentLocations.name;
        
        if ([currentLocations.city containsString:@"上海市"] && ![currentLocations.subLocality containsString:@"崇明区"]) {
           // DLog(@"在范围内");
            
            weakSelf.isShowNoticeView = @"1";
            [weakSelf.addressNoticeView removeFromSuperview];
            
            
            
            
        }else{
            
           // DLog(@"-------------不在");
            
            weakSelf.isShowNoticeView = @"0";
            
            [self.cycleScrollView addSubview:self.addressNoticeView];

        }
        
    };
    
    [self.navigationController pushViewController:VC animated:YES];
}

-(UIButton *)showCurrentAddressBtn{
    if (_showCurrentAddressBtn == nil) {
        _showCurrentAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _showCurrentAddressBtn.frame = CGRectMake((kWidth-150*kScale)/2, 163*kScale, 150*kScale, 26*kScale);
        _showCurrentAddressBtn.layer.cornerRadius = 13*kScale;
        _showCurrentAddressBtn.layer.borderColor = RGB(231, 35, 36, 1).CGColor;
        _showCurrentAddressBtn.layer.borderWidth = 1;
        _showCurrentAddressBtn.titleLabel.font = [UIFont systemFontOfSize:11.0*kScale];
        _showCurrentAddressBtn.backgroundColor = [UIColor whiteColor];
      //  [_showCurrentAddressBtn setImage:[UIImage imageNamed:@"dingwei_red"] forState:0];
        [_showCurrentAddressBtn setTitleColor:RGB(51, 51, 51, 1) forState:0];
        _showCurrentAddressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        //_showCurrentAddressBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10*kScale, 0, 0);
        UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(5*kScale, 5*kScale, 14*kScale, 16*kScale)];
       // imv.backgroundColor = [UIColor cyanColor];
        imv.image = [UIImage imageNamed:@"dingwei_red"];
        [_showCurrentAddressBtn addSubview:imv];
        
        self.showCurrentAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(imv)+5, 0, 150-38, 26)];
        //self.showCurrentAddressLabel.backgroundColor = [UIColor redColor];
        self.showCurrentAddressLabel.font = [UIFont systemFontOfSize:13.0f*kScale];
        self.showCurrentAddressLabel.textColor = RGB(51, 51, 51, 1);
        self.showCurrentAddressLabel.textAlignment = NSTextAlignmentCenter;
        self.showCurrentAddressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;    //中间的内容以……方式省略，显示头尾的文字内容。

        [_showCurrentAddressBtn addSubview:self.showCurrentAddressLabel];
        
        
        _showCurrentAddressBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 21*kScale, 0, 0);
       
        
        [_showCurrentAddressBtn addTarget:self action:@selector(enterBtnAction) forControlEvents:1];
    }
    return _showCurrentAddressBtn;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
