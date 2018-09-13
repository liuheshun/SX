//
//  MerchantOneViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/8/12.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "MerchantOneViewController.h"
#import "UIViewController+YNPageExtend.h"
#import "HomePageDetailsViewController.h"
#import "MJRefresh.h"
/// 开启刷新头部高度
#define kOpenRefreshHeaderViewHeight 1

#define kCellHeight 135


#import "HomePageSortTableViewCell.h"
#import "HomePageSortListTableViewCell.h"
#import <CommonCrypto/CommonDigest.h>



@interface MerchantOneViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
/// 占位cell高度
@property (nonatomic, assign) CGFloat placeHolderCellHeight;

///接口地址
@property (nonatomic,strong) NSString *baseURLString;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,strong) UITableView *secondTableView;

@property (nonatomic,strong) NSMutableArray *secondaryMarray;

@property (nonatomic,strong) NSMutableArray *titleModelMarray;

@property (nonatomic,assign) NSInteger secondId;

@end

@implementation MerchantOneViewController
{
    NSInteger totalPage;//分页
    NSInteger totalPageCount;//分页总数
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
   // [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"id"];
    self.titleModelMarray = [NSMutableArray array];
    self.secondaryMarray = [NSMutableArray array];
    
    [self.view addSubview:self.tableView];
   
    _dataArray = @[].mutableCopy;
    /// 加载数据
    
    totalPage = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notInfo:) name:@"reloadIndex" object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)notInfo:(NSNotification*)info{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadIndex" object:nil];

    NSInteger index = [info.userInfo[@"index"] integerValue];
   // DLog(@"通知========%ld" ,index);
    
    self.index = index;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    if (self.index >=3) {
//        _secondTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,85,self.view.frame.size.height-kBarHeight-kBottomBarHeight-44)];
//        _secondTableView.delegate = self;
//        _secondTableView.dataSource = self;
//        _secondTableView.showsVerticalScrollIndicator = NO;
//        _secondTableView.showsHorizontalScrollIndicator = NO;
//        _secondTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _secondTableView.backgroundColor = RGB(238, 238, 28, 1);
//        [self.view addSubview:self.secondTableView];
//        
//    }
    if (self.index == 0) {
        ///经常买
        self.baseURLString = [NSString stringWithFormat:@"%@/m/auth/user/get_often_commodity" , baseUrl];
        [self requestOftenListData:totalPage BaseURLString:self.baseURLString totalPage:1];
    }else if (self.index == 1){
        ///大家都在买
        self.baseURLString = [NSString stringWithFormat:@"%@/m/mobile/commodity/get_other_buy?mtype=%@&appVersionNumber=%@&user=%@" , baseUrl,mTypeIOS ,[user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"]];
        [self requestALLPeopleDataBaseURLString:self.baseURLString];
        
        
    }else if (self.index == 2){
        ///赛鲜精选
        self.baseURLString = [NSString stringWithFormat:@"%@/m/mobile/guess/guesslike?mtype=%@&promotionId=2&appVersionNumber=%@&user=%@" , baseUrl,mTypeIOS ,[user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"]];
        [self requesSaiXianDataBaseURLString:self.baseURLString];
        
    }else if (self.index >= 3){
        
        [self requestFirstLevelData];
        ///一级分类请求数据
    //    HomePageModel *model = self.titleModelMarray[self.index];
//        if ([self.isReloadLeftTableView isEqualToString:@"1"]) {
        //    [self requestFirstSortDataWithBigClassId:model.bigClassifyId totalPage:totalPage];
            
//        }else if ([self.isReloadLeftTableView isEqualToString:@"0"]){
//            [self requestGoodsListDataWithBigClassId:model.bigClassifyId secondId:self.secondId totalPage:totalPage];
//
//        }
        
        
    }
    
    [self addTableViewRefresh];

}
///sha1加密方式

- (NSString *) sha1:(NSString *)input
{
    //const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    //NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

//1970获取当前时间转为时间戳
- (NSString *)dateTransformToTimeSp{
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%llu",recordTime];
    return timeSp;
}

///随机数

-(NSString *)ret32bitString

{
    
    char data[32];
    
    for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
    
}


#pragma mark ====  一级分类标签数据 ====

-(void)requestFirstLevelData{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/classify/get_classifys?appVersionNumber=%@&user=%@" ,baseUrl ,[user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"]] params:nil successBlock:^(NSDictionary *returnData) {
        //DLog(@"一级分类标签数据 = %@" ,returnData);
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
                [self.titleModelMarray addObject:model];
                
                [ar addObject:model.classifyName];
                //DLog(@"xxx=== %@" ,model.classifyName);
                MerchantOneViewController *one = [MerchantOneViewController new];
                [VC addObject:one];
            }
            
            
            HomePageModel *model = self.titleModelMarray[self.index];
            //        if ([self.isReloadLeftTableView isEqualToString:@"1"]) {
            [self requestFirstSortDataWithBigClassId:model.bigClassifyId totalPage:totalPage];
            
            
            titleArray = ar;
            //            [self updateMenuItemTitles:ar];
            //            self.titlesM = [NSMutableArray arrayWithObjects:@"1" ,@"2" ,@"3" ,@"4" ,@"5" ,@"6" ,@"7" ,@"8" ,@"9", nil];
            //           // self.controllersM = VC;
            //            [self reloadData];
            
        }
        
        
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
    
}



#pragma mark  =====根据一级分类id 查询数据(二级分类,商品数据(默认选中的二级分类商品))
-(void)requestFirstSortDataWithBigClassId:(NSInteger)bigClassId totalPage:(NSInteger)totalPage{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSString stringWithFormat:@"%ld" ,bigClassId] forKey:@"bigClassId"];
    [dic setValue:[NSString stringWithFormat:@"%ld" ,totalPage] forKey:@"currentPage"];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    //DLog(@"根据一级分类id 查询数据 == %@" ,dic);
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/classify/get_classify_list" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
       // DLog(@"根据一级分类id 查询数据=== %@" ,returnData);
        if ([returnData[@"status"] integerValue] == 200) {
            [self.dataArray removeAllObjects];
            
            NSInteger pages = [returnData[@"data"][@"result"][@"page"][@"totalPage"] integerValue];
            
            for (NSDictionary *dic in returnData[@"data"][@"result"][@"list"]) {
                HomePageModel *model = [HomePageModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.pages = pages;
                [self.dataArray addObject:model];
            }
            
            ///二级分类
            [self.secondaryMarray removeAllObjects];
            for (NSDictionary *dic2 in returnData[@"data"][@"sons"]) {
                HomePageModel *model = [HomePageModel yy_modelWithJSON:dic2];
                
                [self.secondaryMarray addObject:model];
            }
            HomePageModel *smodel = [self.secondaryMarray firstObject];
            self.secondId = smodel.id;
            
//            if ([self.isReloadLeftTableView isEqualToString:@"1"]) {
//                [self.secondTableView reloadData];
//
//            }
        }
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
}


#pragma mark ==================== 经常买 数据

-(void)requestOftenListData:(NSInteger)currentPage BaseURLString:(NSString*)BaseURLString totalPage:(NSInteger)totalPage{
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
    [dic setValue:[NSString stringWithFormat:@"%ld" ,totalPage] forKey:@"currentPage"];
    
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    //DLog(@"经常买1111= %@" ,dic);
    
    [MHAsiNetworkHandler startMonitoring];
    [MHNetworkManager postReqeustWithURL:BaseURLString params:dic successBlock:^(NSDictionary *returnData) {
        //DLog(@"经常买=sssssd= %@" ,returnData);
        [[GlobalHelper shareInstance] removeEmptyView];
        
        if ([[NSString stringWithFormat:@"%@" ,returnData[@"code"]] isEqualToString:@"0404"] || [[NSString stringWithFormat:@"%@" ,returnData[@"code"]] isEqualToString:@"04"]) {
           //DLog(@"未登录");
            
            
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
            [[GlobalHelper shareInstance] emptyViewNoticeText:@"如需查看购买过的商品记录,请先登录" NoticeImageString:@"未登录" viewWidth:50 viewHeight:54 UITableView:self.tableView isShowBottomBtn:YES bottomBtnTitle:@"点击登录"];
            [[GlobalHelper shareInstance].bottomBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:1];
            
            
            
        }
        NSInteger pages = [returnData[@"data"][@"page"][@"totalPage"] integerValue];
        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"]) {
            [[GlobalHelper shareInstance] removeEmptyView];
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
                [self.dataArray addObject:model];
            }
            
            [self.tableView reloadData];
//            self.isLoading = 2;
        }else if ([[returnData[@"status"] stringValue] isEqualToString:@"201"]){
            [self.dataArray removeAllObjects];
            [[GlobalHelper shareInstance] removeEmptyView];
            
            [[GlobalHelper shareInstance] emptyViewNoticeText:@"您还未购买过任何商品,看看大家都买了啥!" NoticeImageString:@"未购买" viewWidth:50 viewHeight:54 UITableView:self.tableView isShowBottomBtn:YES bottomBtnTitle:@"瞧一瞧"];
            [[GlobalHelper shareInstance].bottomBtn addTarget:self action:@selector(showOther) forControlEvents:1];
            //            [loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:1];
            [self.tableView reloadData];
            
        }
        
        
        
    } failureBlock:^(NSError *error) {
        //DLog(@"经常买=error=%@" ,error);
        
    } showHUD:NO];
    
    
}

#pragma mark ==============点击登陆
-(void)loginBtnAction{
    LoginViewController *VC = [LoginViewController new];
    VC.hidesBottomBarWhenPushed = YES;
    [GlobalHelper shareInstance].isMerchantsIsLoginEnter = @"2";
    [self.navigationController pushViewController:VC animated:YES];
    // merchantsIsLogin
}



#pragma mark =====大家都在买 数据===

-(void)requestALLPeopleDataBaseURLString:(NSString*)BaseURLString{
    
    [MHNetworkManager getRequstWithURL:BaseURLString params:nil successBlock:^(NSDictionary *returnData) {
        //DLog(@"大家都在买 数据=sssssd= %@" ,returnData);
        
        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"]) {
            [self.dataArray removeAllObjects];
            
            for (NSDictionary *dic in returnData[@"data"][@"list"]) {
                HomePageModel *model = [HomePageModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                [self.dataArray addObject:model];
            }
            
            [self.tableView reloadData];
        }
        //[self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}

#pragma mark =====赛鲜精选 数据===

-(void)requesSaiXianDataBaseURLString:(NSString*)BaseURLString{
    
    [MHNetworkManager getRequstWithURL:BaseURLString params:nil successBlock:^(NSDictionary *returnData) {
        //DLog(@"赛鲜精选数据=sssssd= %@" ,returnData);
        [[GlobalHelper shareInstance] removeEmptyView];
        
        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"]) {
            [self.dataArray removeAllObjects];
            for (NSDictionary *dic in returnData[@"data"][@"commodity"]) {
                HomePageModel *model = [HomePageModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                [self.dataArray addObject:model];
            }
            
            [self.tableView reloadData];
        }else if ([[returnData[@"status"] stringValue] isEqualToString:@"201"]){
            [self.dataArray removeAllObjects];
            [[GlobalHelper shareInstance] removeEmptyView];
            
            [[GlobalHelper shareInstance] emptyViewNoticeText:@"暂无商品" NoticeImageString:@"未购买" viewWidth:50 viewHeight:54 UITableView:self.tableView isShowBottomBtn:NO bottomBtnTitle:@""];
            [[GlobalHelper shareInstance].bottomBtn addTarget:self action:@selector(showOther) forControlEvents:1];
            //            [loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:1];
            [self.tableView reloadData];
            
        }
        
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}



-(void)addTableViewRefresh {
    
    __weak typeof (self) weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (self.index == 0) {
                ///经常买
                self.baseURLString = [NSString stringWithFormat:@"%@/m/auth/user/get_often_commodity" , baseUrl];
                [self requestOftenListData:totalPage BaseURLString:self.baseURLString totalPage:1];
            }else if (self.index == 1){
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                ///大家都在买
                self.baseURLString = [NSString stringWithFormat:@"%@/m/mobile/commodity/get_other_buy?mtype=%@&appVersionNumber=%@&user=%@" , baseUrl,mTypeIOS ,[user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"]];
                [self requestALLPeopleDataBaseURLString:self.baseURLString];
                
                
            }
            
            
            
            if (kOpenRefreshHeaderViewHeight) {
                [weakSelf suspendTopReloadHeaderViewHeight];
            } else {
                [weakSelf.tableView.mj_header endRefreshing];
            }
        });
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            totalPage++;
            if (totalPage<=totalPageCount) {
                if (self.index == 0) {
                    [self requestOftenListData:totalPage BaseURLString:self.baseURLString totalPage:totalPage];
                    
                }
                
//                if (self.index >=3){
//                    ///一级分类请求数据
//                    HomePageModel *model = self.titleModelMarray[self.indexs];
//
//                    [self requestFirstSortDataWithBigClassId:model.bigClassifyId totalPage:totalPage];
//                }
                
                
                
                [self.tableView.mj_footer endRefreshing];
                
            }else{
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            
//            [weakSelf.tableView.mj_footer endRefreshing];
        });
    }];
    
    /// 需要设置下拉刷新控件UI的偏移位置
    self.tableView.mj_header.ignoredScrollViewContentInsetTop = self.yn_pageViewController.config.tempTopHeight;
}







#pragma mark - 悬浮Center刷新高度方法
- (void)suspendTopReloadHeaderViewHeight {
    /// 布局高度
    CGFloat netWorkHeight = 408*kScale;
    __weak typeof (self) weakSelf = self;
    
    /// 结束刷新时 刷新 HeaderView高度
    [self.tableView.mj_header endRefreshingWithCompletionBlock:^{
        YNPageViewController *VC = weakSelf.yn_pageViewController;
        if (VC.headerView.frame.size.height != netWorkHeight) {
            VC.headerView.frame = CGRectMake(0, 0, kWidth, netWorkHeight);
            [VC reloadSuspendHeaderViewFrame];
        }
    }];
}
#pragma mark - 求出占位cell高度
- (CGFloat)placeHolderCellHeight {
    CGFloat height = self.config.contentHeight - kCellHeight * self.dataArray.count;
    height = height < 0 ? 0 : height;
    return height;
}

#pragma mark - UITableViewDelegate  UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.dataArray.count) {
        return kCellHeight;
    }
    return self.placeHolderCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.index <3) {
        
    
    HomePageTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (cell1 == nil) {
        cell1 = [[HomePageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell1.backgroundColor = [UIColor whiteColor];
    }
    
    cell1.cartBtn.tag = indexPath.row;
    [cell1.cartBtn addTarget:self action:@selector(cartBtnAction:) forControlEvents:1];
    
    if (indexPath.row < self.dataArray.count) {

    if (self.dataArray.count!=0) {
        HomePageModel *model =  self.dataArray[indexPath.row];
        totalPageCount = model.pages;
        [cell1 configHomePageCellWithModel:model];
        

//        if (indexPath.row == self.dataArray.count -1) {
//            self.feedBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            self.feedBackBtn.frame = CGRectMake(0, 135*kScale, kWidth, 100*kScale);
//            self.feedBackBtn.backgroundColor = RGB(238, 238, 238, 1);
//            [self.feedBackBtn setTitle:@"  没有商品啦~告诉我你想买点啥" forState:0];
//            [self.feedBackBtn setTitleColor:RGB(136, 136, 136, 1) forState:0];
//            self.feedBackBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
//            [self.feedBackBtn setImage:[UIImage imageNamed:@"bianji"] forState:0];
//            [cell1 addSubview:self.feedBackBtn];
//            [self.feedBackBtn addTarget:self action:@selector(postfeedbackAction) forControlEvents:1];
//        }
        
    }
    }
    
    
    return cell1;
        
    }else{
        
        
        if (tableView == self.secondTableView) {
            UITableViewCell *secondCell = [tableView dequeueReusableCellWithIdentifier:@"secondcell"];
            if (secondCell == nil) {
                secondCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"secondcell"];
            }
            secondCell.backgroundColor = RGB(238, 238, 238, 1);
            //默认选中第一行
            secondCell.selectedBackgroundView = [[UIView alloc]initWithFrame:secondCell.bounds];
            secondCell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
            [self.secondTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]animated:YES scrollPosition:UITableViewScrollPositionTop];
            
            if (self.secondaryMarray.count != 0) {
                HomePageModel *model = self.secondaryMarray[indexPath.row];
                secondCell.textLabel.text = model.dataName;
                secondCell.textLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
                secondCell.textLabel.textColor = RGB(51, 51, 51, 1);
                
            }
            
            return secondCell;
        }else{
            
            NSString *CellIdentifier = [NSString stringWithFormat:@"right_cell_%ld" ,indexPath.row];//以indexPath来唯一确定cell
            
            HomePageSortListTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell1 == nil) {
                cell1 = [[HomePageSortListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell1.backgroundColor = [UIColor whiteColor];
            }
            
            cell1.cartBtn.tag = indexPath.row;
            [cell1.cartBtn addTarget:self action:@selector(cartBtnAction:) forControlEvents:1];
            
            if (indexPath.row < self.dataArray.count) {

            if (self.dataArray.count!=0) {
                HomePageModel *model =  self.dataArray[indexPath.row];
                totalPageCount = model.pages;
                [cell1 configCellWithModel:model];
                if (indexPath.row == self.dataArray.count -1) {
//                    self.feedBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                    self.feedBackBtn.frame = CGRectMake(0, 100*kScale, kWidth - 85*kScale, 100*kScale);
//                    self.feedBackBtn.backgroundColor = [UIColor whiteColor];
//                    [self.feedBackBtn setTitle:@"  没有商品啦~告诉我你想买点啥" forState:0];
//                    [self.feedBackBtn setTitleColor:RGB(136, 136, 136, 1) forState:0];
//                    self.feedBackBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
//
//                    [self.feedBackBtn setImage:[UIImage imageNamed:@"bianji"] forState:0];
//                    [cell1 addSubview:self.feedBackBtn];
//                    [self.feedBackBtn addTarget:self action:@selector(postfeedbackAction) forControlEvents:1];
                    
                }
            }
            }
            return cell1;
            
        }
        
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomePageDetailsViewController *baseVC = [HomePageDetailsViewController new];
    //baseVC.title = @"二级页面";
    baseVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:baseVC animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kBarHeight, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor=  RGB(238, 238, 238, 1);
    }
    return _tableView;
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
