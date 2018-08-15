//
//  MerchantViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/8/12.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "MerchantViewController.h"
#import "SDCycleScrollView.h"
#import "MerchantOneViewController.h"
#import "GYChangeTextView.h"
#import "HomePageHeadSortView.h"
@interface MerchantViewController ()<YNPageViewControllerDataSource, YNPageViewControllerDelegate, SDCycleScrollViewDelegate ,GYChangeTextViewDelegate>
///轮播图
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;

///分类视图
@property (nonatomic,strong) HomePageHeadSortView *homePageHeadSortView;
///banner轮播图数据源
@property (nonatomic,strong) NSMutableArray *bannerMarray;
///播报数据
@property (nonatomic,strong) NSMutableArray *PlayTextDataMarray;
///一级分类数据源
@property (nonatomic,strong) NSMutableArray *segmentTitleMarray;

@end

@implementation MerchantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    self.bannerMarray = [NSMutableArray array];
    self.PlayTextDataMarray = [NSMutableArray array];
    self.segmentTitleMarray = [NSMutableArray array];
    [self setMainView];
    [self.headerView addSubview:self.homePageHeadSortView];

    [self requsetHomPageBannerData];
    [self requestPlayTextData];
    [self requestHomePageSortData];
    [self requestFirstLevelData];
    

    
}


-(void)setMainView{
    
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 408*kScale)];
    headerView.layer.contents = (id)[UIImage imageNamed:@"mine_header_bg"].CGImage;
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kWidth, 176*kScale) delegate:self placeholderImage:[UIImage imageNamed:@"banner加载"]];   //placeholder
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.cycleScrollView.showPageControl = YES;//是否显示分页控件
    self.cycleScrollView.currentPageDotColor = [UIColor orangeColor]; // 自定义分页控件小圆标颜色
    self.cycleScrollView.tag = 1;
    
    //vc.headerView = autoScrollView;
    
//    self.headerView = headerView;
    [self.headerView addSubview:self.cycleScrollView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




+ (instancetype)suspendTopPageVC {
    
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionTop;
    configration.headerViewCouldScale = YES;
    configration.showTabbar = YES;
    configration.showNavigation = YES;
    configration.scrollMenu = NO;
    configration.aligmentModeCenter = NO;
    configration.lineWidthEqualFontWidth = NO;
    configration.showBottomLine = YES;
    
    MerchantViewController *vc = [MerchantViewController pageViewControllerWithControllers:[self getArrayVCs]
                                                                            titles:[self getArrayTitles]
                                                                            config:configration];
    vc.dataSource = vc;
    vc.delegate = vc;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 408*kScale)];
    vc.headerView = headerView;
    
    // 指定默认选择index 页面
    //    vc.pageIndex = 0;
    return vc;
}


+ (NSArray *)getArrayVCs {
    
    MerchantOneViewController *vc_1 = [[MerchantOneViewController alloc] init];
    vc_1.title = @"鞋子";
    
    MerchantOneViewController *vc_2 = [[MerchantOneViewController alloc] init];
    vc_2.title = @"衣服";
    
    MerchantOneViewController *vc_3 = [[MerchantOneViewController alloc] init];
    MerchantOneViewController *vc_4 = [[MerchantOneViewController alloc] init];

//    MerchantOneViewController *vc_4 = [[MerchantOneViewController alloc] init];
//    MerchantOneViewController *vc_5 = [[MerchantOneViewController alloc] init];
//    MerchantOneViewController *vc_6 = [[MerchantOneViewController alloc] init];
//    MerchantOneViewController *vc_7 = [[MerchantOneViewController alloc] init];
//    MerchantOneViewController *vc_8 = [[MerchantOneViewController alloc] init];
//    MerchantOneViewController *vc_9 = [[MerchantOneViewController alloc] init];

//    return @[vc_1, vc_2, vc_3 ,vc_4, vc_5, vc_6,vc_7, vc_8, vc_9];
    return @[vc_1, vc_2, vc_3 ,vc_4 ];

}

+ (NSArray *)getArrayTitles {
//    return @[@"鞋子1", @"衣服2", @"帽子3",@"鞋子4", @"衣服5", @"帽子6" ,@"鞋子7", @"衣服8", @"帽子9"];
    return @[@"经常买", @"大家都在买", @"赛鲜精选" ,@"分类1"];

}


#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    DLog(@"iiiii ====== %ld" ,index);

    MerchantOneViewController *vc = pageViewController.controllersM[index];
    return [vc tableView];
}
#pragma mark - YNPageViewControllerDelegate
- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffset
                  progress:(CGFloat)progress {
        NSLog(@"--- contentOffset = %f,    progress = %f", contentOffset, progress);
}


- (void)pageViewController:(YNPageViewController *)pageViewController
        didAddButtonAction:(UIButton *)button{
    
}
- (void)pageViewController:(YNPageViewController *)pageViewController
                 didScroll:(UIScrollView *)scrollView
                  progress:(CGFloat)progress
                 formIndex:(NSInteger)fromIndex
                   toIndex:(NSInteger)toIndex{

    DLog(@"tttt==%ld" ,toIndex);
}


- (void)pageViewController:(YNPageViewController *)pageViewController
        didEndDecelerating:(UIScrollView *)scrollView{
    
    DLog(@"ppppppp=====%ld" ,pageViewController.pageIndex);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadIndex" object:nil userInfo:@{@"index":[NSString stringWithFormat:@"%ld" ,pageViewController.pageIndex]}];

    
}












#pragma mark ======首页分类数据 =======

-(void)requestHomePageSortData{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableArray *homePageSortDataMarray = [NSMutableArray array];
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/classify/get_home_classify?appVersionNumber=%@&user=%@" ,baseUrl ,[user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"]] params:nil successBlock:^(NSDictionary *returnData) {
        DLog(@"=首页分类数据 = %@" ,returnData);
        if ([returnData[@"status"] integerValue] == 200) {
            for (NSDictionary *dic in returnData[@"data"]) {
                HomePageModel *model = [HomePageModel yy_modelWithJSON:dic];
                
                [homePageSortDataMarray addObject:model];
            }
            ///手动添加更多分类
            HomePageModel *model = [HomePageModel new];
            model.classifyName = @"更多分类";
            [homePageSortDataMarray addObject:model];
        }
        
       // [self.homePageHeadSortView setHomePageSortUIButtions:homePageSortDataMarray];
        
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
    
}

#pragma mark ====  一级分类标签数据 ====

-(void)requestFirstLevelData{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/classify/get_classifys?appVersionNumber=%@&user=%@" ,baseUrl ,[user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"]] params:nil successBlock:^(NSDictionary *returnData) {
        DLog(@"一级分类标签数据 = %@" ,returnData);
        NSArray *titleArray = [NSArray array];
        NSMutableArray *ar = [NSMutableArray array];
        NSMutableArray *VC = [NSMutableArray array];
        if ([returnData[@"status"] integerValue] == 200) {
            for (NSDictionary *dic in returnData[@"data"]) {
                int i = 0;
                i++;
                HomePageModel *model = [HomePageModel yy_modelWithJSON:dic];
                NSString *bigClassifyId = dic[@"id"];
                model.bigClassifyId = [bigClassifyId integerValue];
                [self.segmentTitleMarray addObject:model];
                
                [ar addObject:model.classifyName];
                DLog(@"xxx=== %@" ,model.classifyName);
                MerchantOneViewController *one = [MerchantOneViewController new];
                [VC addObject:one];
            }
            titleArray = ar;
//            [self updateMenuItemTitles:ar];
//            self.titlesM = [NSMutableArray arrayWithObjects:@"1" ,@"2" ,@"3" ,@"4" ,@"5" ,@"6" ,@"7" ,@"8" ,@"9", nil];
//           // self.controllersM = VC;
//            [self reloadData];

        }
        
        
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
    
}


#pragma mark = ===================商品banner轮播图数据

-(void)requsetHomPageBannerData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [MHNetworkManager getRequstWithURL:[NSString stringWithFormat:@"%@/m/banner/queryBannerForWeb?mtype=%@&appVersionNumber=%@&user=%@" ,baseUrl ,mTypeIOS ,[user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"]] params:nil successBlock:^(NSDictionary *returnData) {
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


#pragma mark ================== 获取播报数据

-(void)requestPlayTextData{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/roll/get_roll_order?appVersionNumber=%@&user=%@" ,baseUrl, [user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"]] params:nil successBlock:^(NSDictionary *returnData) {
        
        DLog(@"获取播报数据=====%@" ,returnData);
        if ([returnData[@"status"] integerValue] == 200) {
            for (NSDictionary *dic in returnData[@"data"]) {
                HomePageModel *model = [HomePageModel yy_modelWithJSON:dic];
                [self.PlayTextDataMarray addObject:model];
                
            }
            [self addChangeTextView];
            
        }
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
    
}


#pragma mark========分类视图
-(HomePageHeadSortView *)homePageHeadSortView{
    if (_homePageHeadSortView == nil) {
        _homePageHeadSortView = [[HomePageHeadSortView alloc] initWithFrame:CGRectMake(0, 176*kScale, kWidth, 182*kScale)];
        _homePageHeadSortView.backgroundColor = [UIColor whiteColor];
        
    }
    return _homePageHeadSortView;
}


#pragma mark ===============添加播报视图view

-(void)addChangeTextView{
    UIImageView *playImage = [[UIImageView alloc] initWithFrame:CGRectMake(15*kScale, MaxY(self.homePageHeadSortView)+8*kScale, 35*kScale, 34*kScale)];
    playImage.image = [UIImage imageNamed:@"saixianbobao"];
    [self.headerView addSubview:playImage];
    GYChangeTextView *tView = [[GYChangeTextView alloc] initWithFrame:CGRectMake(MaxX(playImage)+25*kScale, MaxY(self.homePageHeadSortView), kWidth-140*kScale, 50*kScale)];
    tView.delegate = self;
    tView.backgroundColor =  RGB(238, 238, 238, 1);
    [self.headerView addSubview:tView];
    //self.tView = tView;
    NSArray * listArray = self.PlayTextDataMarray;
    [tView animationWithTexts:listArray];
    
    
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
