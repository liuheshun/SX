//
//  PersonalPageViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/8/14.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "PersonalPageViewController.h"
#import "HomePageNavView.h"
#import "GYChangeTextView.h"
#import "XLCardSwitch.h"

#import "PersonalViewController.h"
#import "UIView+YNPageExtend.h"
#import "YNPageViewController.h"
#import "MessageCenterViewController.h"
#import "PYSearch.h"
#import "SelectAddressViewController.h"
#import "HomePageAddressNoticeView.h"

#import "RHLocation.h"
#import "DDSearchManager.h"
#import "HomePageDetailsViewController.h"
#import "HomePageOtherDetailsViewController.h"
#import "VersionUpdateView.h"
#import "HWPopTool.h"
#import "NewUserGiftView.h"

#define headViewHeight (567+18)*kScale
#define kOpenRefreshHeaderViewHeight 0

@interface PersonalPageViewController ()<UITableViewDelegate ,UITableViewDataSource ,SDCycleScrollViewDelegate ,GYChangeTextViewDelegate ,XLCardSwitchDelegate ,YNPageViewControllerDataSource, YNPageViewControllerDelegate ,RHLocationDelegate>

@property (nonatomic,strong) HomePageNavView *navView;
@property (nonatomic,strong) UITableView *tableView;

///播报数据
@property (nonatomic,strong) NSMutableArray *PlayTextDataMarray;
///轮播图数据
@property (nonatomic,strong) NSMutableArray *bannerMarray;
///套餐数据
@property (nonatomic,strong) NSMutableArray *mealMarray;

///
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;

///地址提示视图
@property (nonatomic,strong) HomePageAddressNoticeView *addressNoticeView;
///地址提示视图 0不在配送范围内显示 , 1 在配送范围内不显示
@property (nonatomic,strong) NSString *isShowNoticeView;
///热搜标签数据
@property (nonatomic,strong) NSMutableArray *hotSearchMarray;
///历史搜索数据
@property (nonatomic,strong) NSMutableArray *historySearchMarray;


///记录当前位置信息
@property (nonatomic,strong) Location *currentLocation;
@property (nonatomic,strong) NSString *currentAddressSubLocality;
///记录当前附近位置信息
@property (nonatomic,strong) NSMutableArray *otherAddressArray;
@property (nonatomic,strong) RHLocation *rhLocation;

///显示当前定位
@property (nonatomic,strong) UIButton *showCurrentAddressBtn;
@property (nonatomic,strong) UILabel *showCurrentAddressLabel;



@property (nonatomic,strong) UIView *headerView;



@end

@implementation PersonalPageViewController
{
    
    XLCardSwitch *_cardSwitch;
    
    UIImageView *_imageView;
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
            
            NSArray *localArray = [localVerson componentsSeparatedByString:@"."];
            
            NSArray *appArray = [[NSString stringWithFormat:@"%@" ,returnData[@"version"]] componentsSeparatedByString:@"."];
            
            NSInteger minArrayLength = MIN(localArray.count, appArray.count);
            
            BOOL needUpdate = NO;
            
            for(int i=0;i<minArrayLength;i++){//以最短的数组长度为遍历次数,防止数组越界
                //取出每个部分的字符串值,比较数值大小
                
                NSString *localElement = localArray[i];
                
                NSString *appElement = appArray[i];
                
                NSInteger  localValue =  localElement.integerValue;
                
                
                NSInteger  appValue = appElement.integerValue;
                
                
                
                if(localValue<appValue) {
                    
                    //从前往后比较数字大小,一旦分出大小,跳出循环
                    
                    needUpdate = YES;
                    
                    break;
                    
                }else{
                    
                    
                    
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


-(void)viewWillDisappear:(BOOL)animated{

    [GlobalHelper shareInstance].selectAddressString = self.showCurrentAddressLabel.text;

}
-(void)viewWillAppear:(BOOL)animated{
    //  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
 
    ///版本更新通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkVersionUpdate)name:@"versionUpdate" object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    self.bannerMarray = [NSMutableArray array];
    self.PlayTextDataMarray = [NSMutableArray array];
    self.hotSearchMarray = [NSMutableArray array];
    self.historySearchMarray = [NSMutableArray array];
    self.otherAddressArray = [NSMutableArray array];
    self.mealMarray = [NSMutableArray array];
    [self setupPageVC];
    [self addHeadView];
   
    [self requestLocation];//请求当前位置信息
    [self addNavigationHeadBlockAction];
    [self.headerView addSubview:self.showCurrentAddressBtn];
    
    
    [self requestStoreStatedData];
    [self requestBadNumValue];
    [self requsetHomPageBannerData];
    [self requestPlayTextData];
    [self requestHotSearchData];
    [self requestMealData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPersonData) name:@"refreshPersonData" object:nil];
  
    
}

-(void)refreshPersonData{
    [self requestStoreStatedData];
    [self requestBadNumValue];
    [self requsetHomPageBannerData];
    [self requestPlayTextData];
    [self requestHotSearchData];
    [self requestMealData];
    [self requestLocation];//请求当前位置信息

}

#pragma mark =============检验店铺是否认证

-(void)requestStoreStatedData{
    DLog(@"bb=== %@" ,baseUrl);
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
        //DLog(@"账号店铺是否登录认证hhhh= %@" ,returnData);
        
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
        
        
    } failureBlock:^(NSError *error) {
        //DLog(@"账号店铺是否登录认证= %@" ,error);
        
    } showHUD:NO];
    
    
}




#pragma mark = ===================商品banner轮播图数据

-(void)requsetHomPageBannerData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [MHNetworkManager getRequstWithURL:[NSString stringWithFormat:@"%@/m/banner/queryBannerForWeb?mtype=%@&appVersionNumber=%@&user=%@&showType=PERSON" ,baseUrl ,mTypeIOS ,[user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"]] params:nil successBlock:^(NSDictionary *returnData) {
        //DLog(@"个人专区轮播图=====%@" ,returnData);
        
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
           // self.cycleScrollView.imageURLStringsGroup = mArray;
            
            [self addSDCycleScrollViewWithImageURLArray:mArray ParentView:self.headerView];

            
        }else{
            
        }
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
    
}


#pragma mark ================== 获取播报数据

-(void)requestPlayTextData{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/roll/get_roll_order?appVersionNumber=%@&user=%@" ,baseUrl, [user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"]] params:nil successBlock:^(NSDictionary *returnData) {
        
        //DLog(@"获取播报数据=====%@" ,returnData);
        if ([returnData[@"status"] integerValue] == 200) {
            [self.PlayTextDataMarray removeAllObjects];
            for (NSDictionary *dic in returnData[@"data"]) {
                HomePageModel *model = [HomePageModel yy_modelWithJSON:dic];
                [self.PlayTextDataMarray addObject:model];
                
            }
            [self addChangeTextViewToHeadView:self.headerView];

        }
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
    
}



#pragma mark ==================个人专区商品套餐数据

-(void)requestMealData{
    
    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/mobile/commodity/get_commodity_meal_list" ,baseUrl] params:nil successBlock:^(NSDictionary *returnData) {
        
        DLog(@"套餐=====%@" ,returnData);
        if ([returnData[@"status"] integerValue] == 200) {
            [self.mealMarray removeAllObjects];
            for (NSDictionary *dic in returnData[@"data"]) {
                HomePageModel *model = [HomePageModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                [self.mealMarray addObject:model];
                
            }
            
            [self addCardSwitch:self.headerView MealData:self.mealMarray];
        }
        
    } failureBlock:^(NSError *error) {
       // DLog(@"套餐error=====%@" ,error);

    } showHUD:NO];
    
}




#pragma mark ================================= 热门搜索数据
-(void)requestHotSearchData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSInteger usrId = [[user valueForKey:@"userId"] integerValue];
    
    
    
    [MHNetworkManager getRequstWithURL:[NSString stringWithFormat:@"%@/m/search/get_top_search_and_history_search?customerId=%ld&&appVersionNumber=%@&user=%@&showType=PERSON", baseUrl,usrId ,[user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"] ] params:nil successBlock:^(NSDictionary *returnData) {
        
        if ([returnData[@"status"] integerValue] == 200) {
            [self.hotSearchMarray removeAllObjects];
            [self.historySearchMarray removeAllObjects];
            
            [self.hotSearchMarray addObjectsFromArray:returnData[@"data"][@"topSearchList"]];
            [self.historySearchMarray addObjectsFromArray:returnData[@"data"][@"historyList"]];
            //DLog(@"====sss===== hotSearchMarray=== %@  historySearchMarray=%@" , returnData[@"data"][@"topSearchList"] , self.historySearchMarray);
            
            
            //////////数据库搜索历史数据写到本地(暂时去掉)
            //  [NSKeyedArchiver archiveRootObject:self.historySearchMarray toFile:PYSEARCH_SEARCH_HISTORY_CACHE_PATH];
            
            
        }
    } failureBlock:^(NSError *error) {
        
       // DLog(@"sous ==== url===error %@" ,error);
    } showHUD:NO];
    
}



#pragma mark =========================购物车数量
-(void)requestBadNumValue{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic = [self checkoutData];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    [MHNetworkManager  postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/cart/get_cart_product_count" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
        if ([returnData[@"code"]  isEqualToString:@"0404"] || [returnData[@"code"]  isEqualToString:@"04"]) {
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:@"0" forKey:@"isLoginState"];
            [GlobalHelper shareInstance].shoppingCartBadgeValue = 0;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shoppingCart" object:nil userInfo:nil];
        }
        
        if ([returnData[@"status"] integerValue] == 200)
        {
            [GlobalHelper shareInstance].shoppingCartBadgeValue = [returnData[@"data"] integerValue];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shoppingCart" object:nil userInfo:nil];
        }
        
       // DLog(@"购物车数量==  %@" ,returnData);
    } failureBlock:^(NSError *error) {
        
        //DLog(@"购物车数量error==  %@" ,error);
        
    } showHUD:NO];
}



#pragma mark ==========设置子控制器

- (void)setupPageVC {
    
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionTop;
    configration.headerViewCouldScale = YES;
    /// 控制tabbar 和 nav
    configration.showTabbar = YES;
    configration.showNavigation = YES;
    configration.aligmentModeCenter = NO;
    configration.lineWidthEqualFontWidth = NO;
    configration.showBottomLine = YES;
    configration.scrollMenu = YES;
    configration.aligmentModeCenter = NO;
    configration.menuHeight = 30*kScale;
    configration.showBottomLine = NO;
    configration.showScrollLine = NO;
    configration.selectedItemColor = [UIColor whiteColor];
    configration.selectedItemFont = [UIFont systemFontOfSize:17*kScale weight:0.7];
    configration.itemFont = [UIFont systemFontOfSize:17*kScale];

    
    NSMutableArray *buttonArrayM = @[].mutableCopy;
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"anniuxuanzhong"] forState:UIControlStateSelected];
        
        /// seTitle -> sizeToFit -> 自行调整位置
        /// button.imageEdgeInsets = UIEdgeInsetsMake(0, 100, 0, 0);
        [buttonArrayM addObject:button];
    }
    configration.buttonArray = buttonArrayM;
    
    
    
//    configration.contentHeight
    /// 设置悬浮停顿偏移量
    configration.suspenOffsetY = -kBarHeight;
    
    
    YNPageViewController *vc = [YNPageViewController pageViewControllerWithControllers:self.getArrayVCs
                                                                                titles:[self getArrayTitles]
                                                                                config:configration];
    vc.dataSource = self;
    vc.delegate = self;
   
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, (567+18)*kScale)];
    self.headerView.backgroundColor = RGB(238, 238, 238, 1);

    ///底部白条
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 567*kScale, kWidth, 18*kScale)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:whiteView];
    
    vc.headerView = self.headerView;
    /// 指定默认选择index 页面
    vc.pageIndex = 1;
    
    
//    __weak typeof(YNPageViewController *) weakVC = vc;
//    
//    vc.bgScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//        NSInteger refreshPage = weakVC.pageIndex;
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            /// 取到之前的页面进行刷新 pageIndex 是当前页面
//            PersonalViewController *vc2 = weakVC.controllersM[refreshPage];
//            [vc2.tableView reloadData];
//            
//            if (kOpenRefreshHeaderViewHeight) {
//                weakVC.headerView.yn_height = 300;
//                [weakVC.bgScrollView.mj_header endRefreshing];
//                [weakVC reloadSuspendHeaderViewFrame];
//            } else {
//                [weakVC.bgScrollView.mj_header endRefreshing];
//            }
//        });
//    }];
//    
//    
//    
    
    
    
    
    
    /// 作为自控制器加入到当前控制器
    [vc addSelfToParentViewController:self];
    /// 如果隐藏了导航条可以 适当改y值
    vc.view.yn_y = kBarHeight;
    [self.view addSubview:self.navView];
    
}


-(void)addHeadView{
    
    
    
}


- (NSArray *)getArrayVCs {
    
    PersonalViewController *vc_1 = [[PersonalViewController alloc] init];
    
    PersonalViewController *vc_2 = [[PersonalViewController alloc] init];
    
   
    
    return @[vc_1, vc_2];
}

- (NSArray *)getArrayTitles {
    return @[@"经常买", @"赛鲜精选"];
}



#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    PersonalViewController *vc = pageViewController.controllersM[index];
//    if ([vc isKindOfClass:[BaseTableViewVC class]]) {
//        return [(BaseTableViewVC *)vc tableView];
//    } else {
//        return [(BaseCollectionViewVC *)vc collectionView];
//    }
    return [vc tableView];
}
#pragma mark - YNPageViewControllerDelegate
- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffset
                  progress:(CGFloat)progress {
    
    
}


#pragma mark - SDCycleScrollViewDelegate

#pragma mark ===================== 轮播图点击事件

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    HomePageDetailsViewController *VC = [HomePageDetailsViewController new];
    VC.hidesBottomBarWhenPushed = YES;
    
    HomePageOtherDetailsViewController *otherVC = [HomePageOtherDetailsViewController new];
    otherVC.hidesBottomBarWhenPushed = YES;
    
    
    if (self.bannerMarray.count!=0) {
        HomePageModel *model = self.bannerMarray[index];
        
        //DLog(@"轮播图详情页======= %@" ,model.bannerUrl);
        
        if ([model.bannerUrl containsString:@"SP"]) {
            VC.fromBaner = @"1";
            VC.isFromBORC = @"c";

            VC.detailsId = model.bannerUrl;
            [self.navigationController pushViewController:VC animated:YES];
        }else{///外部链接
            
            if ([model.bannerUrl containsString:@"get_coupon"]) {
                
                otherVC.detailsURL = [NSString stringWithFormat:@"%@/breaf/get_coupon_ios.html" ,baseUrl];
            }else if ([model.bannerUrl containsString:@"collect_stamp.html"]){
                otherVC.detailsURL = [NSString stringWithFormat:@"%@/breaf/collect_stamp_iOS.html" ,baseUrl];
            }else if ([model.bannerUrl containsString:@"new_users_exclusive_package.html"]){///新用户套餐
                otherVC.detailsURL = [NSString stringWithFormat:@"%@/breaf/new_users_exclusive_package_iOS.html" ,baseUrl];
            }else if ([model.bannerUrl containsString:@"new_user_gift_pack.html"]){///新用户大礼包
                otherVC.detailsURL = [NSString stringWithFormat:@"%@/breaf/new_user_gift_pack_iOS.html" ,baseUrl];
            }else{
                otherVC.detailsURL = model.bannerUrl;
            }
            //DLog(@"轮播图详情页外部外部链接======= %@" ,otherVC.detailsURL);
            [self.navigationController pushViewController:otherVC animated:YES];
            
        }
        
    }
    
    
}





#pragma mark ===============添加播报视图view

-(void)addChangeTextViewToHeadView:(UIView*)headView{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 176*kScale, kWidth, 91*kScale)];
    bgView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:bgView];

    UIView *smallbgView = [[UIView alloc] initWithFrame:CGRectMake(0, 27*kScale, kWidth, 50*kScale)];
    smallbgView.backgroundColor =  RGB(238, 238, 238, 1);
    [bgView addSubview:smallbgView];
    
    
    
    UIImageView *playImage = [[UIImageView alloc] initWithFrame:CGRectMake(15*kScale, 6*kScale, 35*kScale, 34*kScale)];
    playImage.image = [UIImage imageNamed:@"saixianbobao"];
    [smallbgView addSubview:playImage];

    GYChangeTextView *tView = [[GYChangeTextView alloc] initWithFrame:CGRectMake(MaxX(playImage)+25*kScale, 0*kScale, kWidth-140*kScale, 50*kScale)];
    tView.delegate = self;
//    tView.backgroundColor =  [UIColorcl];
    [smallbgView addSubview:tView];
    //self.tView = tView;
    NSArray * listArray = self.PlayTextDataMarray;
    [tView animationWithTexts:listArray];
    [self.headerView bringSubviewToFront:self.showCurrentAddressBtn];


}





#pragma mark ===============设置轮播图

-(void)addSDCycleScrollViewWithImageURLArray:(NSMutableArray*)imageURLArray  ParentView:(UIView*)parentView{
    if (self.cycleScrollView) {
        self.cycleScrollView.imageURLStringsGroup = imageURLArray;

    }else{
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kWidth, 176*kScale) delegate:self placeholderImage:[UIImage imageNamed:@"banner加载"]];   //placeholder
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.cycleScrollView.showPageControl = YES;//是否显示分页控件
    self.cycleScrollView.currentPageDotColor = [UIColor orangeColor]; // 自定义分页控件小圆标颜色
    self.cycleScrollView.tag = 1;
    self.cycleScrollView.imageURLStringsGroup = imageURLArray;

    [parentView addSubview:self.cycleScrollView];
    
    [self.headerView bringSubviewToFront:self.showCurrentAddressBtn];
    }

}


#pragma mark ================初始化套餐

- (void)addCardSwitch:(UIView*)headView MealData:(NSMutableArray*)items{
    //初始化数据源
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DataPropertyList" ofType:@"plist"];
//    NSArray *arr = [NSArray arrayWithContentsOfFile:filePath];
//    //NSArray *arr = @[@"1" ,@"2" ,@"3" ,@"4"];
//    NSMutableArray *items = [NSMutableArray new];
//    for (NSDictionary *dic in arr) {
//        HomePageModel *item = [[HomePageModel alloc] init];
//        [item setValuesForKeysWithDictionary:dic];
//        [items addObject:item];
//    }
    if (_cardSwitch == nil) {
        //设置卡片浏览器
        _cardSwitch = [[XLCardSwitch alloc] initWithFrame:CGRectMake(0, (176+91+22)*kScale, self.view.bounds.size.width, 250*kScale)];
        _cardSwitch.backgroundColor = [UIColor clearColor];
        _cardSwitch.items = items;
        _cardSwitch.delegate = self;
        //分页切换
        _cardSwitch.pagingEnabled = YES;
        //设置初始位置，默认为0
        //_cardSwitch.selectedIndex = 0;
        [headView addSubview:_cardSwitch];
        
        ///点击加入购物车按钮
        __weak __typeof(self) weakSelf = self;
#pragma mark =============套餐购物车按钮点击事件

        ///购物车按钮
        _cardSwitch.selectCardAddShoppingIndex = ^(NSInteger addShoppingIndex) {
            //DLog(@"addShoppingIndex === %ld" ,addShoppingIndex);
            [weakSelf mealAddShoppingCardIndex:addShoppingIndex];
        };
        
#pragma mark =============套餐点击事件
        _cardSwitch.selectCellIndex = ^(NSInteger cellIndex) {
            
            HomePageDetailsViewController *VC = [HomePageDetailsViewController new];
            VC.hidesBottomBarWhenPushed = YES;
            HomePageModel *model = weakSelf.mealMarray[cellIndex];
            VC.detailsId = [NSString stringWithFormat:@"%ld" ,(long)model.id];
            ///标记详情页 显示C端详情
            VC.isFromBORC = @"c";
            VC.isPackage = @"1";
            [weakSelf.navigationController pushViewController:VC animated:YES];
            
            
        };
        
        
        
    }else{
        _cardSwitch.items = items;

    }
   
}

#pragma mark -
#pragma mark CardSwitchDelegate

- (void)XLCardSwitchDidSelectedAt:(NSInteger)index {

    
    
    
//    //更新背景图
//    HomePageModel *item = _cardSwitch.items[index];
//    [_imageView sd_setImageWithURL:[NSURL URLWithString:item.mainImage]];
}




- (void)switchPrevious {

    NSInteger index = _cardSwitch.selectedIndex - 1;
    index = index < 0 ? 0 : index;
    [_cardSwitch switchToIndex:index animated:true];
}

- (void)switchNext {
    NSInteger index = _cardSwitch.selectedIndex + 1;
    index = index > _cardSwitch.items.count - 1 ? _cardSwitch.items.count - 1 : index;
    [_cardSwitch switchToIndex:index animated:true];
}

#pragma mark =========套餐加入购物车点击事件

-(void)mealAddShoppingCardIndex:(NSInteger)index{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user valueForKey:@"isLoginState"]) {
        [GlobalHelper shareInstance].isLoginState = [user valueForKey:@"isLoginState"];
    }
    if ([[GlobalHelper shareInstance].isLoginState isEqualToString:@"1"])
    {
        
       
        
        if (self.mealMarray.count != 0)
        {
            HomePageModel *model = self.mealMarray[index];
            
            [self addShoppingCardWithProductId:model.id Model:model];
            
        }
        
    }else
    {
        LoginViewController *VC = [LoginViewController new];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        
        
    }
    
}

#pragma mark ====================套餐加入购物车

-(void)addShoppingCardWithProductId:(NSInteger)productId Model:(HomePageModel*)model{
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
    [dic setValue:[NSString stringWithFormat:@"%ld" ,(long)productId] forKey:@"commodityId"];
    
    [dic setObject:@"1" forKey:@"quatity"];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    
    if ([[user valueForKey:@"approve"] isEqualToString:@"0"] || [[user valueForKey:@"approve"] isEqualToString:@"2"]) {
        
        [dic setValue:@"PERSON" forKey:@"showType"];
        
    }else if ([[user valueForKey:@"approve"] isEqualToString:@"1"]){
        
        [dic setValue:@"SOGO" forKey:@"showType"];
        
    }
   // DLog(@"加入购物车 ==== %@" , dic);
    [MHNetworkManager  postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/cart/add",baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
       
        if ([returnData[@"code"]  isEqualToString:@"0404"] || [returnData[@"code"]  isEqualToString:@"04"]) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:@"0" forKey:@"isLoginState"];
            LoginViewController *VC = [LoginViewController new];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
        }
        
        
        
        if ([returnData[@"status"] integerValue] == 200){
    
          
            [[GlobalHelper shareInstance].addShoppingCartMarray addObject:model];
            
            if ([[GlobalHelper shareInstance].addShoppingCartMarray containsObject:model]) {
                [[GlobalHelper shareInstance].addShoppingCartMarray removeObject:model];
                [[GlobalHelper shareInstance].addShoppingCartMarray addObject:model];
            }
            
            [GlobalHelper shareInstance].shoppingCartBadgeValue += 1;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shoppingCart" object:nil userInfo:nil];
            [SVProgressHUD showSuccessWithStatus:@"加入购物车成功"];
        }else {
            //            model.number = 0;
            
            SVProgressHUD.minimumDismissTimeInterval = 0.5;
            SVProgressHUD.maximumDismissTimeInterval = 2;
            [SVProgressHUD showErrorWithStatus:returnData[@"msg"]];
        }
       // DLog(@"首页加入购物车== id=== %ld  %@" ,productId,returnData);
    } failureBlock:^(NSError *error) {
        
      //  DLog(@"首页加入购物车error ========== id= %ld  %@" ,productId,error);
        
    } showHUD:NO];
    
    
}



#pragma mark ==========自定义导航栏

- (UIView *)navView {
    if (!_navView) {
        _navView = [[HomePageNavView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kBarHeight)];
        _navView.backgroundColor = [UIColor redColor];
    }
    return _navView;
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
       // DLog(@"消息");
        
    };
    
#pragma mark ============================== 搜索商品
    
    
    self.navView.searchBtnBlock = ^{
        
        NSArray *hotSeaches = [NSArray array];
        hotSeaches =  weakSelf.hotSearchMarray;
        // 2. Create a search view controller
        [GlobalHelper shareInstance].showType= @"PERSON";
        
        PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"请输入商品名称搜索", @"搜索") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
            
            
            searchViewController.searchResultShowMode = PYSearchResultShowModeEmbed;
            searchViewController.showSearchResultWhenSearchBarRefocused = YES;
            
            SeacherViewController *sVc = [[SeacherViewController alloc] init];
            
            searchViewController.searchResultController = sVc;
            sVc.fromSortString = @"0";
            sVc.showType = @"PERSON";
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
            
            if (([currentLocations.city containsString:@"上海市"] && ![currentLocations.subLocality containsString:@"崇明区"]) || [currentLocations.administrativeArea containsString:@"浙江省"] || [currentLocations.administrativeArea containsString:@"江苏省"]) {
                
                //DLog(@"在范围内");
                weakSelf.isShowNoticeView = @"1";
                [weakSelf.addressNoticeView removeFromSuperview];
            }else{
                //DLog(@"-------------不在");
                weakSelf.isShowNoticeView = @"0";
                [weakSelf.cycleScrollView addSubview:weakSelf.addressNoticeView];
            }
        };
        
        
        [weakSelf.navigationController pushViewController:VC animated:YES];
        
        DLog(@"选择收货地址");
        
        
    };
}


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
    if (([location.city isEqualToString:@"上海市"] && ![location.subLocality isEqualToString:@"崇明区"]) || [location.administrativeArea isEqualToString:@"浙江省"] || [location.administrativeArea isEqualToString:@"江苏省"]) {
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
        
        if (([currentLocations.city containsString:@"上海市"] && ![currentLocations.subLocality containsString:@"崇明区"]) || [currentLocations.administrativeArea containsString:@"浙江省"] || [currentLocations.administrativeArea containsString:@"江苏省"]) {
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
    //DLog(@"选择收货地址");
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
