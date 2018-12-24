//
//  OneViewTableTableViewController.m
//  HeaderViewAndPageView
//
//  Created by su on 16/8/8.
//  Copyright © 2016年 susu. All rights reserved.
//

#import "OneViewTableTableViewController.h"
#import "HomePageSortTableViewCell.h"
#import "MJRefresh.h"
#import <CommonCrypto/CommonDigest.h>
#import "HomePageDetailsViewController.h"
#import "HomePageSortListTableViewCell.h"

#import "FeedBackView.h"

#import "HWPopTool.h"
#import "WMPageController.h"
#import "ShopCertificationViewController.h"
@interface OneViewTableTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic ,strong)UITableView * myTableView;

///二级分类
@property (nonatomic,strong) UITableView *secondTableView;

///商品数据列表
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) NSInteger indexs;

@property (nonatomic,strong) HomePageSortTableViewCell *SortTableViewCell;

///接口地址
@property (nonatomic,strong) NSString *baseURLString;
///一级分类id
@property (nonatomic,assign) NSInteger bigClassId;

///二级分类数据源
@property (nonatomic,strong) NSMutableArray *secondaryMarray;

@property (nonatomic,assign) NSString *isFirstLoading;

@property (nonatomic,strong) FeedBackView *popupView ;

@property (nonatomic,strong) NSMutableArray *levelMarray;
@property (nonatomic,assign) NSInteger levelStatedSelectIndex;
@property (nonatomic,assign) NSInteger secondId;
@property (nonatomic,strong) NSString *isReloadLeftTableView;

@property (nonatomic,strong) UIButton *feedBackBtn;
@property (nonatomic,strong) NSString *sss;

@end

@implementation OneViewTableTableViewController
{
    NSInteger totalPage;//分页
    NSInteger totalPageCount;//分页总数
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    self.secondaryMarray = [NSMutableArray array];
    self.levelMarray = [NSMutableArray array];
    self.isReloadLeftTableView = @"1";
    self.sss = @"1";
    totalPage = 1;
    [self getLevelListData];

    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height-kBarHeight-kBottomBarHeight - 44)];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.showsVerticalScrollIndicator = NO;
    _myTableView.showsHorizontalScrollIndicator = NO;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.myTableView];

    
    _secondTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,0,self.view.frame.size.height-kBarHeight-kBottomBarHeight-44)];
    _secondTableView.delegate = self;
    _secondTableView.dataSource = self;
    _secondTableView.showsVerticalScrollIndicator = NO;
    _secondTableView.showsHorizontalScrollIndicator = NO;
    _secondTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _secondTableView.backgroundColor = RGB(238, 238, 238, 1);
    [self.view addSubview:self.secondTableView];
    
    
    if (self.isFirsrEnter == 1) {
        ///经常买
        self.baseURLString = [NSString stringWithFormat:@"%@/m/auth/user/get_often_commodity" , baseUrl];
        [self requestOftenListData:totalPage BaseURLString:self.baseURLString totalPage:1];
        [self setupRefresh];
        self.isFirsrEnter = 2;
    }

   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(call:) name:@"WMControllerDidFullyDisplayedNotification" object:nil];

    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    MMAlertViewConfig1 *alertConfig = [MMAlertViewConfig1 globalConfig1];
    alertConfig.defaultTextOK = @"确定";
    alertConfig.defaultTextCancel = @"取消";
    alertConfig.titleFontSize = 17*kScale;
    alertConfig.detailFontSize = 13*kScale;
    alertConfig.buttonFontSize = 15*kScale;
    alertConfig.buttonHeight = 40*kScale;
    alertConfig.width = 315*kScale;
    alertConfig.buttonBackgroundColor = [UIColor redColor];
    alertConfig.detailColor = RGB(136, 136, 136, 1);
    alertConfig.itemNormalColor = [UIColor whiteColor];
    
    alertConfig.splitColor = [UIColor whiteColor];
}


- (void)viewDidAppear:(BOOL)animated{
   // DLog(@"12222222222222222222222");
   
}

-(void)call:(NSNotification*)notInfo{
   // DLog(@"calllllllllllllllllllllllllllll=== %@" ,notInfo);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    //[self requestStoreStatedData];///账号是否登录 认证
    
    self.levelStatedSelectIndex = 10000;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRefreshData:) name:@"sortRefresh" object:@"one"];

    if ([[GlobalHelper shareInstance].merchantsIsLoginStated isEqualToString:@"2"] && [[GlobalHelper shareInstance].isMerchantsIsLoginEnter isEqualToString:@"2"]
) {
        if ([self.sss isEqualToString:@"1"]) {
            [GlobalHelper shareInstance].merchantsIsLoginStated = @"1";
            [GlobalHelper shareInstance].isMerchantsIsLoginEnter = @"1";
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.baseURLString = [NSString stringWithFormat:@"%@/m/auth/user/get_often_commodity" , baseUrl];
                [self requestOftenListData:totalPage BaseURLString:self.baseURLString totalPage:1];
                self.sss = @"2";
                self.isLoading = 1;
                
            });
            
           

        }
       
    
    }

}




-(void)notificationRefreshData:(NSNotification*)notInfo{
    [self.dataArray removeAllObjects];
    [[GlobalHelper shareInstance] removeEmptyView];
    [self.feedBackBtn removeFromSuperview];

    NSString *s =[NSString stringWithFormat:@"%@" ,notInfo.userInfo[@"index"]] ;
    self.indexs = [s integerValue];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sortRefresh" object:@"one"];
    
    
    if (self.indexs >=3) {
     
        CGRect rect = self.myTableView.frame;
        rect.origin.x = 85;
        rect.size.width = kWidth - 85*kScale;
        self.myTableView.frame = rect;
        
        CGRect rect2 = self.secondTableView.frame;
        rect2.origin.x = 0;
        rect2.size.width = 85*kScale;
        self.secondTableView.frame = rect2;
        
        
    }else{
        
        CGRect rect = self.myTableView.frame;
        rect.origin.x = 0;
        rect.size.width = kWidth;
        self.myTableView.frame = rect;
        
        CGRect rect2 = self.secondTableView.frame;
        rect2.origin.x = 0;
        rect2.size.width = 0;
        self.secondTableView.frame = rect2;
        
    }
    
    
    
   totalPage=1;

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

  
    
    if ([s isEqualToString:@"0"]) {
        if (self.isLoading != 1) {
            ///经常买
            self.baseURLString = [NSString stringWithFormat:@"%@/m/auth/user/get_often_commodity" , baseUrl];
            [self setupRefresh];
            [self requestOftenListData:totalPage BaseURLString:self.baseURLString totalPage:1];
        }
        self.isLoading = 2;
        
    }else if ([s integerValue] == 1){
        ///赛鲜精选
        self.baseURLString = [NSString stringWithFormat:@"%@/m/mobile/guess/guesslike?mtype=%@&promotionId=2&appVersionNumber=%@&user=%@&showType=SOGO" , baseUrl,mTypeIOS ,[user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"]];
        [self requesSaiXianDataBaseURLString:self.baseURLString];
       
    
    }else if ([s integerValue] == 2){
        ///大家都在买
        
        self.baseURLString = [NSString stringWithFormat:@"%@/m/mobile/commodity/get_other_buy?mtype=%@&appVersionNumber=%@&user=%@&showType=SOGO" , baseUrl,mTypeIOS ,[user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"]];
        [self requestALLPeopleDataBaseURLString:self.baseURLString];
   
    }else if ([s integerValue] >=3){
        ///一级分类请求数据
       // HomePageModel *model = self.titleModelMarray[self.indexs];
        
        //[self requestFirstSortDataWithBigClassId:model.bigClassifyId];
        [self setupRefresh];
        
        
        ///一级分类请求数据
                HomePageModel *model = self.titleModelMarray[self.indexs];
                if ([self.isReloadLeftTableView isEqualToString:@"1"]) {
                    [self requestFirstSortDataWithBigClassId:model.bigClassifyId totalPage:totalPage];
        
                }else if ([self.isReloadLeftTableView isEqualToString:@"0"]){
                    [self requestGoodsListDataWithBigClassId:model.bigClassifyId secondId:self.secondId totalPage:totalPage];
        
                }
        
        
        
    }

}


- (void)setupRefresh{

//    //下拉刷新
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
//    self.myTableView.mj_header  = header;
//    header.lastUpdatedTimeLabel.hidden = YES;
//    [self.myTableView.mj_header beginRefreshing];
//    //上拉加载
//    //self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
//        self.myTableView.mj_footer.automaticallyHidden = YES;
    
    //上拉加载
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 加载旧的数据，加载旧的未显示的数据
        [self footerRereshing];
    }];
    
    
}


#pragma mark=====================上拉加载============================

- (void)footerRereshing{

    totalPage++;
    if (totalPage<=totalPageCount) {
        if (self.indexs == 0) {
            [self requestOftenListData:totalPage BaseURLString:self.baseURLString totalPage:totalPage];

        }
        
        if (self.indexs >=3){
            ///一级分类请求数据
            HomePageModel *model = self.titleModelMarray[self.indexs];
            
            [self requestFirstSortDataWithBigClassId:model.bigClassifyId totalPage:totalPage];
        }
        
        
        
        [self.myTableView.mj_footer endRefreshing];

    }else{

        [self.myTableView.mj_footer endRefreshingWithNoMoreData];
    }
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
    [dic setValue:@"SOGO" forKey:@"showType"];
    
  //  DLog(@"根据一级分类id 查询数据 == %@" ,dic);
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/classify/get_classify_list" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
        //DLog(@"根据一级分类id 查询数据=== %@" ,returnData);
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
            
            if ([self.isReloadLeftTableView isEqualToString:@"1"]) {
                [self.secondTableView reloadData];

            }
        }
        [self.myTableView reloadData];

    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
}


#pragma mark ===========根据二级分类请求商品数据


-(void)requestgoodsDataWithSonId:(NSInteger)sonId totalPage:(NSInteger)totalPage{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSString stringWithFormat:@"%ld" ,sonId] forKey:@"sonId"];
    [dic setValue:[NSString stringWithFormat:@"%ld" ,totalPage] forKey:@"currentPage"];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    [dic setValue:@"SOGO" forKey:@"showType"];

   // DLog(@"根据二级分类请求商品数据 == %@" ,dic);
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/classify/get_classify_list" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
        //DLog(@"根据二级分类请求商品数据=== %@" ,returnData);
        if ([returnData[@"status"] integerValue] == 200) {
            if (totalPage == 1) {
                [self.dataArray removeAllObjects];
            }
            
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
            
          
            [self.myTableView reloadData];
        }
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
}



#pragma mark =====赛鲜精选 数据===

-(void)requesSaiXianDataBaseURLString:(NSString*)BaseURLString{
    
    [MHNetworkManager getRequstWithURL:BaseURLString params:nil successBlock:^(NSDictionary *returnData) {
        DLog(@"商户专区赛鲜精选数据=sssssd= %@" ,returnData);
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
            
            [self.myTableView reloadData];
        }else if ([[returnData[@"status"] stringValue] isEqualToString:@"201"]){
            [self.dataArray removeAllObjects];
            [[GlobalHelper shareInstance] removeEmptyView];
            
            [[GlobalHelper shareInstance] emptyViewNoticeText:@"暂无商品" NoticeImageString:@"未购买" viewWidth:50 viewHeight:54 UITableView:self.myTableView isShowBottomBtn:NO bottomBtnTitle:@""];
            [[GlobalHelper shareInstance].bottomBtn addTarget:self action:@selector(showOther) forControlEvents:1];
            //            [loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:1];
            [self.myTableView reloadData];
            
        }
        
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}






#pragma mark =====大家都在买 数据===

-(void)requestALLPeopleDataBaseURLString:(NSString*)BaseURLString{
    
    [MHNetworkManager getRequstWithURL:BaseURLString params:nil successBlock:^(NSDictionary *returnData) {
      //  DLog(@"大家都在买 数据=sssssd= %@" ,returnData);
        
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
            
            [self.myTableView reloadData];
        }
        [self.myTableView reloadData];
        
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
           // DLog(@"未登录");
            
            
            [self.dataArray removeAllObjects];
            [self.myTableView reloadData];
            [[GlobalHelper shareInstance] emptyViewNoticeText:@"如需查看购买过的商品记录,请先登录" NoticeImageString:@"未登录" viewWidth:50 viewHeight:54 UITableView:self.myTableView isShowBottomBtn:YES bottomBtnTitle:@"点击登录"];
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

            [self.myTableView reloadData];
            self.isLoading = 2;
        }else if ([[returnData[@"status"] stringValue] isEqualToString:@"201"]){
            [self.dataArray removeAllObjects];
            [[GlobalHelper shareInstance] removeEmptyView];

              [[GlobalHelper shareInstance] emptyViewNoticeText:@"您还未购买过任何商品,看看大家都买了啥!" NoticeImageString:@"未购买" viewWidth:50 viewHeight:54 UITableView:self.myTableView isShowBottomBtn:YES bottomBtnTitle:@"瞧一瞧"];
            [[GlobalHelper shareInstance].bottomBtn addTarget:self action:@selector(showOther) forControlEvents:1];
            //            [loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:1];
            [self.myTableView reloadData];

        }

      

    } failureBlock:^(NSError *error) {
       // DLog(@"经常买=error=%@" ,error);

    } showHUD:NO];


}
#pragma mark ==========经常买 未购买商品 点击事件

-(void)showOther{
//    DLog(@"看一看");[NSString stringWithFormat:@"%ld", self.titleIndexs]
//    selectIndex
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectIndex" object:[NSString stringWithFormat:@"%@", @"1"]];
}




#pragma mark ==============点击登陆
-(void)loginBtnAction{
    LoginViewController *VC = [LoginViewController new];
    VC.hidesBottomBarWhenPushed = YES;
    [GlobalHelper shareInstance].isMerchantsIsLoginEnter = @"2";
    [self.navigationController pushViewController:VC animated:YES];
   // merchantsIsLogin
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




#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.indexs >=3) {
        if (tableView == self.secondTableView) {
            return self.secondaryMarray.count;
        }
        if (self.dataArray.count == 0) {
            return 1;
        }
        return self.dataArray.count;
    }else{
        return self.dataArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.indexs >=3) {
        if (tableView == self.secondTableView) {
            return 41*kScale;
        }
        if (indexPath.row == self.dataArray.count-1 || self.dataArray.count == 0) {
            return 200*kScale;
        }
        return 100*kScale;
    }
    if (indexPath.row == self.dataArray.count-1) {
        return 235*kScale;
    }
    return 135*kScale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.indexs >=3) {

    if (tableView == self.secondTableView) {
        return 15*kScale;
    
    }else{
        return 56*kScale;
    }
    
    }
    return 15*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 15*kScale)];
    if (self.indexs >=3) {
        if (tableView == self.secondTableView) {
            view.backgroundColor = RGB(238, 238, 238, 1);

        }else{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(85*kScale, 0, kWidth-85*kScale, 56*kScale)];
            view.backgroundColor = RGB(238, 238, 238, 1);
            UIView *sView = [[UIView alloc] initWithFrame:CGRectMake(0, 15*kScale, kWidth-85*kScale, 41*kScale)];
            sView.backgroundColor = [UIColor whiteColor];
            [view addSubview:sView];
            
            for (int i = 0; i <4;i++ ) {
                UIButton *levelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                levelBtn.frame = CGRectMake(10*kScale+55*i*kScale+10*kScale*i, 10*kScale, 55*kScale, 25*kScale);
                levelBtn.layer.cornerRadius = 5;
                levelBtn.layer.masksToBounds = YES;
                levelBtn.backgroundColor = RGB(238, 238, 238, 1);
                if (self.levelMarray.count != 0) {
                    HomePageModel *model = self.levelMarray[i];
                    [levelBtn setTitle:model.dataName forState:0];
                }
                
                levelBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
                [levelBtn setTitleColor:RGB(136, 136, 136, 1) forState:0];
                
                if (i == self.levelStatedSelectIndex) {
                    levelBtn.backgroundColor = RGB(231, 35, 36, 1);
                    [levelBtn setTitleColor:[UIColor whiteColor] forState:0];
                    
                }
                if (i == 3) {
                    levelBtn.frame = CGRectMake(10*kScale+55*i*kScale+10*kScale*i, 10*kScale, 77*kScale, 25*kScale);
                }
                levelBtn.tag = i+100;
                [sView addSubview:levelBtn];
                [levelBtn addTarget:self action:@selector(levelBtnClickAction:) forControlEvents:1];
            }
            
            return view;
        }
    }else{
        view.backgroundColor = RGB(238, 238, 238, 1);

    }
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (self.indexs >=3) {
        if (tableView == self.secondTableView) {
             return 0.001;
        }else{
            return 0.001;
        }
    }else{
    return 0.001;
    }
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 44)];
    view.backgroundColor = RGB(238, 238, 238, 1);
    
    if (self.indexs >=3) {
        if (tableView == self.secondTableView) {
           
            return view;
        }else{
            return view;
        }
    }else{
       
        return view;
    }
    
   
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.indexs>=3) {
        
        if (tableView == self.secondTableView) {
            ///左侧分类
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
                secondCell.textLabel.numberOfLines = 2;
                secondCell.textLabel.textColor = RGB(51, 51, 51, 1);

            }
            
            return secondCell;
        }else{
        ///右侧商品列表
        NSString *CellIdentifier = [NSString stringWithFormat:@"right_cell_%ld" ,indexPath.row];//以indexPath来唯一确定cell
        
        HomePageSortListTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
       // if (cell1 == nil) {
            cell1 = [[HomePageSortListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell1.backgroundColor = [UIColor whiteColor];
        //}
        
        cell1.cartBtn.tag = indexPath.row;
        [cell1.cartBtn addTarget:self action:@selector(cartBtnAction:) forControlEvents:1];
        if (self.dataArray.count!=0) {
            HomePageModel *model =  self.dataArray[indexPath.row];
            totalPageCount = model.pages;
        ///标记商户专区
            model.goodsTypes = @"1";
            [cell1 configCellWithModel:model];
            
            ///是否可以查看价格
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            
            if ([[user valueForKey:@"approve"] isEqualToString:@"1"]) {
                
                
            }else if ([[user valueForKey:@"approve"] isEqualToString:@"0"] || [[user valueForKey:@"approve"] isEqualToString:@"2"]){
                ///点击查看价格点击事件
                [cell1.newsPriceBtn addTarget:self action:@selector(checkPricesAction) forControlEvents:1];
            }
            
            
            if (indexPath.row == self.dataArray.count -1) {
                self.feedBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                self.feedBackBtn.frame = CGRectMake(0, 100*kScale, kWidth - 85*kScale, 100*kScale);
                self.feedBackBtn.backgroundColor = [UIColor whiteColor];
                [self.feedBackBtn setTitle:@"  没有商品啦~告诉我你想买点啥" forState:0];
                [self.feedBackBtn setTitleColor:RGB(136, 136, 136, 1) forState:0];
                self.feedBackBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
                
                [self.feedBackBtn setImage:[UIImage imageNamed:@"bianji"] forState:0];
                [cell1 addSubview:self.feedBackBtn];
                [self.feedBackBtn addTarget:self action:@selector(postfeedbackAction) forControlEvents:1];
                
            }
        }else{
            self.feedBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.feedBackBtn.frame = CGRectMake(0, 100*kScale, kWidth - 85*kScale, 100*kScale);
            self.feedBackBtn.backgroundColor = [UIColor whiteColor];
            [self.feedBackBtn setTitle:@"  没有商品啦~告诉我你想买点啥" forState:0];
            [self.feedBackBtn setTitleColor:RGB(136, 136, 136, 1) forState:0];
            self.feedBackBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
            
            [self.feedBackBtn setImage:[UIImage imageNamed:@"bianji"] forState:0];
            [cell1 addSubview:self.feedBackBtn];
            [self.feedBackBtn addTarget:self action:@selector(postfeedbackAction) forControlEvents:1];
            
        }
       
        return cell1;
        
        }
        
    }else{
        
        ///前三个固定分类商品列表
        NSString *CellIdentifier = [NSString stringWithFormat:@"sCellIdentifier_cell%ld" ,indexPath.row];//以indexPath来唯一确定cell
        
        HomePageTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        if (cell1 == nil) {
            cell1 = [[HomePageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell1.backgroundColor = [UIColor whiteColor];
        //}
        
        cell1.cartBtn.tag = indexPath.row;
        [cell1.cartBtn addTarget:self action:@selector(cartBtnAction:) forControlEvents:1];
        if (self.dataArray.count!=0) {
             HomePageModel *model =  self.dataArray[indexPath.row];
             totalPageCount = model.pages;
            ///商户
            model.goodsTypes = @"1";
            ///赋值
            [cell1 configHomePageCellWithModel:model];
            
            ///是否可以查看价格
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            
            if ([[user valueForKey:@"approve"] isEqualToString:@"1"]) {
                
            
            }else if ([[user valueForKey:@"approve"] isEqualToString:@"0"] || [[user valueForKey:@"approve"] isEqualToString:@"2"]){
                ///点击查看价格点击事件
                [cell1.newsPriceBtn addTarget:self action:@selector(checkPricesAction) forControlEvents:1];
            }
            ///反馈
            if (indexPath.row == self.dataArray.count -1) {
                self.feedBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                self.feedBackBtn.frame = CGRectMake(0, 135*kScale, kWidth, 100*kScale);
                self.feedBackBtn.backgroundColor = RGB(238, 238, 238, 1);
                [self.feedBackBtn setTitle:@"  没有商品啦~告诉我你想买点啥" forState:0];
                [self.feedBackBtn setTitleColor:RGB(136, 136, 136, 1) forState:0];
                self.feedBackBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
                [self.feedBackBtn setImage:[UIImage imageNamed:@"bianji"] forState:0];
                [cell1 addSubview:self.feedBackBtn];
                [self.feedBackBtn addTarget:self action:@selector(postfeedbackAction) forControlEvents:1];
            }
            
        }
        
       
        
        return cell1;
    }
}


#pragma mark ==============查看价格

-(void)checkPricesAction{
    
  
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

    if ([[user valueForKey:@"isLoginState"] isEqualToString:@"0"]) {
        LoginViewController *VC = [LoginViewController new];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }else if ([[user valueForKey:@"isLoginState"] isEqualToString:@"1"]){
        
        
        if ([[user valueForKey:@"approve"] isEqualToString:@"0"]) {///认证未通过
            MMPopupItemHandler block = ^(NSInteger index){
              //  NSLog(@"clickd %@ button",@(index));
                if (index == 0) {
                    NSString *str = [NSString stringWithFormat:@"tel:%@",@"4001106111"];
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                    });
                }
            };
            NSArray *items = @[MMItemMake(@"联系客服", MMItemTypeNormal, block) , MMItemMake(@"再等等", MMItemTypeNormal, block)];
            MMMyCustomView *alertView =  [[MMMyCustomView alloc] initWithTitle:@"认证提示" detail:@"您的认证申请还未通过，请耐心等待！\n客服热线：4001106111" items:items];
            
            alertView.attachedView.mm_dimBackgroundBlurEnabled = NO;
            
            alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
            
            [alertView show];
            
          
            
        }else  if ([[user valueForKey:@"approve"] isEqualToString:@"2"]) {///未认证
            MMPopupItemHandler block = ^(NSInteger index){
               // NSLog(@"clickd %@ button",@(index));
                if (index == 0) {
                   
                    ShopCertificationViewController *VC = [ShopCertificationViewController new];
                    VC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:VC animated:YES];
                }
            };
            NSArray *items = @[MMItemMake(@"去认证", MMItemTypeNormal, block)];
            MMMyCustomView *alertView =  [[MMMyCustomView alloc] initWithTitle:@"认证提示" detail:@"您还未通过商户认证，请先提交认证申请!" items:items];
            
            alertView.attachedView.mm_dimBackgroundBlurEnabled = NO;
            
            alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
            
            [alertView show];
            
            
        }
        
    }
    
    
    
}


#pragma mark ===============选择三级分类

-(void)levelBtnClickAction:(UIButton*)btn{
    
    if (self.levelMarray.count != 0) {
        [self.feedBackBtn removeFromSuperview];
        HomePageModel *model = self.levelMarray[btn.tag - 100];
        
        [self requestListDataWithSecondId:self.secondId levelId:model.id totalPage:1];
    }
    self.levelStatedSelectIndex = btn.tag - 100 ;

    
}
#pragma mark ===============按等级筛选

-(void)requestListDataWithSecondId:(NSInteger)secondId levelId:(NSInteger)levelId totalPage:(NSInteger)totalPage{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSString stringWithFormat:@"%ld" ,secondId] forKey:@"posistionId"];
    [dic setValue:[NSString stringWithFormat:@"%ld" ,levelId] forKey:@"gradeId"];
    [dic setValue:[NSString stringWithFormat:@"%ld" ,totalPage] forKey:@"currentPage"];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    //DLog(@" 按等级筛选 === %@" ,dic);
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    [dic setValue:@"SOGO" forKey:@"showType"];

    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/mobile/commodity/search_item_list" , baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        //DLog(@" 按等级筛选 === %@" ,returnData);
        if ([returnData[@"status"] integerValue] == 200) {
            [self.feedBackBtn removeFromSuperview];
            if (totalPage == 1) {
                [self.dataArray removeAllObjects];
            }
            
            NSInteger pages = [returnData[@"data"][@"page"][@"totalPage"] integerValue];
            
            for (NSDictionary *dic in returnData[@"data"][@"list"]) {
                HomePageModel *model = [HomePageModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.pages = pages;
                [self.dataArray addObject:model];
            }
            
            [self.myTableView reloadData];
        }else if ([returnData[@"status"] integerValue] == 201){
            [SVProgressHUD showErrorWithStatus:returnData[@"msg"]];
        }
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
}




#pragma mark ===================反馈建议


-(void)postfeedbackAction{
   // DLog(@"反馈建议");
    self.popupView = [[FeedBackView alloc] initWithFrame:CGRectMake((kWidth-315*kScale)/2, (kHeight -250*kScale)/2, 315*kScale, 250*kScale)];
    self.popupView.backgroundColor = [UIColor whiteColor];
    self.popupView.layer.cornerRadius = 5;
    self.popupView.layer.masksToBounds = YES;
    [self.popupView.submitBtn addTarget:self action:@selector(submitBtnAction) forControlEvents:1];
    [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
    [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeNone;
    [[HWPopTool sharedInstance] showWithPresentView:self.popupView animated:YES];
    
}

-(void)submitBtnAction{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user valueForKey:@"isLoginState"]) {
        [GlobalHelper shareInstance].isLoginState = [user valueForKey:@"isLoginState"];
    }
    if ([[GlobalHelper shareInstance].isLoginState isEqualToString:@"1"])
     {///登陆
         [self pustDataIsLoginStated:@"1" URL:[NSString stringWithFormat:@"%@/m/auth/user/feedback" ,baseUrl]];
         
     }else{
         //未登录
         [self pustDataIsLoginStated:@"0" URL:[NSString stringWithFormat:@"%@/m/user/feedback" ,baseUrl]];
     }
}

#pragma mark ===============反馈建议


-(void)pustDataIsLoginStated:(NSString*)isLoginState URL:(NSString*)URL{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    if ([isLoginState isEqualToString:@"1"]) {///登陆
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
        [dic setValue:self.popupView.textView.text forKey:@"feedBack"];
    }else{
        //未登录
        [dic setValue:mTypeIOS forKey:@"mtype"];
        [dic setValue:self.popupView.textView.text forKey:@"feedBack"];
    }
    [MHNetworkManager postReqeustWithURL:URL params:dic successBlock:^(NSDictionary *returnData) {
        //DLog(@"反馈==== %@" ,returnData);
        if ([returnData[@"status"] integerValue] == 200) {
        
           

            [[HWPopTool sharedInstance] closeWithBlcok:^{
                
                
            }];
        }
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
    
}

#pragma mark =============== 加入购物车点击事件


-(void)cartBtnAction:(UIButton*)btn{
   
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user valueForKey:@"isLoginState"]) {
        [GlobalHelper shareInstance].isLoginState = [user valueForKey:@"isLoginState"];
    }
    if ([[GlobalHelper shareInstance].isLoginState isEqualToString:@"1"])
    {
        
        if ([[user valueForKey:@"approve"] isEqualToString:@"0"]) {///认证未通过
            MMPopupItemHandler block = ^(NSInteger index){
               // NSLog(@"clickd %@ button",@(index));
                if (index == 0) {
                    NSString *str = [NSString stringWithFormat:@"tel:%@",@"4001106111"];
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                    });
                }
            };
            NSArray *items = @[MMItemMake(@"联系客服", MMItemTypeNormal, block) , MMItemMake(@"再等等", MMItemTypeNormal, block)];
            MMMyCustomView *alertView =  [[MMMyCustomView alloc] initWithTitle:@"认证提示" detail:@"您的认证申请还未通过，请耐心等待！\n客服热线：4001106111" items:items];
            
            alertView.attachedView.mm_dimBackgroundBlurEnabled = NO;
            
            alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
            
            [alertView show];
            
            
            
        }else  if ([[user valueForKey:@"approve"] isEqualToString:@"2"]) {///未认证
            MMPopupItemHandler block = ^(NSInteger index){
                if (index == 0) {
                    
                    ShopCertificationViewController *VC = [ShopCertificationViewController new];
                    VC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:VC animated:YES];
                }
            };
            NSArray *items = @[MMItemMake(@"去认证", MMItemTypeNormal, block)];
            MMMyCustomView *alertView =  [[MMMyCustomView alloc] initWithTitle:@"认证提示" detail:@"您还未通过商户认证，请先提交认证申请!" items:items];
            
            alertView.attachedView.mm_dimBackgroundBlurEnabled = NO;
            
            alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
            
            [alertView show];
            
            
        }else if ([[user valueForKey:@"approve"] isEqualToString:@"1"]){
            
            
            /////
            
            NSIndexPath *myIndex=[self.myTableView indexPathForCell:(HomePageTableViewCell*)[btn superview]];
            HomePageTableViewCell *cell1 = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:myIndex.section]];
            
            //后期可能会有此需求(商品首页回显加入购物车数量)下面一行需要删掉
            // [cell1.cartBtn removeFromSuperview];
            
            if (self.dataArray.count != 0)
            {
                HomePageModel *model = self.dataArray[myIndex.row];
                
                [self addCartPostDataWithProductId:model.id homePageModel:model NSIndexPath:myIndex cell:cell1 isFirstClick:YES tableView:self.myTableView];
                
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:myIndex.row inSection:myIndex.section];
                [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                
            }
            
        }
  
    }else
    {
        LoginViewController *VC = [LoginViewController new];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        
        
    }
}

#pragma mark ==================加入购物车

-(void)addCartPostDataWithProductId:(NSInteger)productId homePageModel:(HomePageModel*)model NSIndexPath:(NSIndexPath*)indexPath cell:(HomePageTableViewCell*)weakCell isFirstClick:(BOOL)isFirst tableView:(UITableView*)tableView{
    //[SVProgressHUD show];
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
#pragma mark---------------------------------需要更改productID--------------------------------
    
    //[dic setObject:[NSString stringWithFormat:@"%ld" ,productId] forKey:@"productId"];
    [dic setValue:[NSString stringWithFormat:@"%ld" ,(long)productId] forKey:@"commodityId"];
    
    [dic setObject:@"1" forKey:@"quatity"];
    
    if ([[user valueForKey:@"approve"] isEqualToString:@"0"] || [[user valueForKey:@"approve"] isEqualToString:@"2"]) {
        
        [dic setValue:@"PERSON" forKey:@"showType"];
        
    }else if ([[user valueForKey:@"approve"] isEqualToString:@"1"]){
        
        [dic setValue:@"SOGO" forKey:@"showType"];
        
    }
    
    
    //DLog(@"加入购物车 ==== %@" , dic);
    [MHNetworkManager  postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/cart/add",baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        //
        //        HomePageModel *modelq = [HomePageModel yy_modelWithJSON:returnData];
        //
        //        if ([modelq isEqual:@"(null)"]) {
        //            DLog(@"sss");
        //        }
        if ([returnData[@"code"]  isEqualToString:@"0404"] || [returnData[@"code"]  isEqualToString:@"04"]) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:@"0" forKey:@"isLoginState"];
            LoginViewController *VC = [LoginViewController new];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
        }
        
        
        
        if ([returnData[@"status"] integerValue] == 200)
        {
            //            SVProgressHUD.minimumDismissTimeInterval = 0.5;
            //            SVProgressHUD.maximumDismissTimeInterval = 1;
            //            [SVProgressHUD showSuccessWithStatus:returnData[@"msg"]];
            //加入购物车动画
            NSInteger count = [weakCell.cartView.numberLabel.text integerValue];
            count++;
            weakCell.cartView.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
            model.number = count ;
            if (isFirst == YES) {
                model.number = 1;
                
            }
            CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
            //获取当前cell 相对于self.view 当前的坐标
            rect.origin.y = rect.origin.y - [tableView contentOffset].y;
            CGRect imageViewRect = weakCell.mainImv.frame;
            if (tableView.tag == 100) {///来自分来列表
                imageViewRect.origin.y = rect.origin.y+imageViewRect.origin.y+kBarHeight+116;
                
            }else{
                imageViewRect.origin.y = rect.origin.y+imageViewRect.origin.y;
            }
           // DLog(@"-------------=== %f  %f" ,rect.origin.y , imageViewRect.origin.y );
            
            [[PurchaseCarAnimationTool shareTool]startAnimationandView:weakCell.mainImv andRect:imageViewRect andFinisnRect:CGPointMake(ScreenWidth/5*3, ScreenHeight-49) topView:self.view andFinishBlock:^(BOOL finish) {
                
                
                UIView *tabbarBtn = self.tabBarController.tabBar.subviews[2];
                [PurchaseCarAnimationTool shakeAnimation:tabbarBtn];
            }];
            [[GlobalHelper shareInstance].addShoppingCartMarray addObject:model];
            
            if ([[GlobalHelper shareInstance].addShoppingCartMarray containsObject:model]) {
                [[GlobalHelper shareInstance].addShoppingCartMarray removeObject:model];
                [[GlobalHelper shareInstance].addShoppingCartMarray addObject:model];
            }
            
            [GlobalHelper shareInstance].shoppingCartBadgeValue += 1;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shoppingCart" object:nil userInfo:nil];
            
            
            
        }
        else
        {
            //            model.number = 0;
            
            SVProgressHUD.minimumDismissTimeInterval = 0.5;
            SVProgressHUD.maximumDismissTimeInterval = 2;
            [SVProgressHUD showErrorWithStatus:returnData[@"msg"]];
        }
    
        DLog(@"商户首页加入购物车== id=== %ld  %@" ,productId,returnData);
        [tableView reloadData];
    } failureBlock:^(NSError *error) {
        
       // DLog(@"首页加入购物车error ========== id= %ld  %@" ,productId,error);
        
    } showHUD:NO];
    
}


#pragma mark ==============tableview 点击事件

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.indexs>=3) {
        
        if (tableView == self.secondTableView) {
            [self.feedBackBtn removeFromSuperview];
            HomePageModel * model = self.titleModelMarray[self.indexs];
            HomePageModel *smodel = self.secondaryMarray[indexPath.row];
            self.isReloadLeftTableView = @"0";
            self.levelStatedSelectIndex = 10000;
            //DLog(@"一级 == %ld  二级====%ld" ,model.bigClassifyId ,smodel.id);
            self.secondId = smodel.id;
            [self requestGoodsListDataWithBigClassId:model.bigClassifyId secondId:smodel.id totalPage:1];
            
        }else{
            if (self.dataArray.count != 0) {
                HomePageDetailsViewController *VC = [HomePageDetailsViewController new];
                VC.hidesBottomBarWhenPushed = YES;
                HomePageModel *model = self.dataArray[indexPath.row];
                VC.detailsId = [NSString stringWithFormat:@"%ld" ,(long)model.id];
               // VC.isFromBORC = @"b";
                [self.navigationController pushViewController:VC animated:YES];
            }
        }
        
        
    }else{
        if (self.dataArray.count != 0) {
            HomePageDetailsViewController *VC = [HomePageDetailsViewController new];
            VC.hidesBottomBarWhenPushed = YES;
            HomePageModel *model = self.dataArray[indexPath.row];
            VC.detailsId = [NSString stringWithFormat:@"%ld" ,(long)model.id];
           //VC.isFromBORC = @"b";

            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}



#pragma mark =========侧边栏切换数据请求

-(void)requestGoodsListDataWithBigClassId:(NSInteger)bigClassId secondId:(NSInteger)sonId totalPage:(NSInteger)totalPage{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSString stringWithFormat:@"%ld" ,sonId] forKey:@"sonId"];
    [dic setValue:[NSString stringWithFormat:@"%ld" ,bigClassId] forKey:@"bigClassId"];
    [dic setValue:[NSString stringWithFormat:@"%ld" ,totalPage] forKey:@"currentPage"];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    [dic setValue:@"SOGO" forKey:@"showType"];

    //DLog(@"根据二级分类请求商品数据 == %@" ,dic);
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/classify/get_classify_list" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
        //DLog(@"根据二级分类请求商品数据=== %@" ,returnData);
        if ([returnData[@"status"] integerValue] == 200) {
            [self.feedBackBtn removeFromSuperview];

            if (totalPage == 1) {
                [self.dataArray removeAllObjects];
            }
            
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
            
            
            
            
            [self.myTableView reloadData];
        }
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
    
}




#pragma mark =========获取等级列表

-(void)getLevelListData{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [MHNetworkManager getRequstWithURL:[NSString stringWithFormat:@"%@/m/mobile/commodity/get_grade_list?appVersionNumber=%@&user=%@&mtype=%@" ,baseUrl ,[user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"],mTypeIOS] params:nil successBlock:^(NSDictionary *returnData) {
        //DLog(@"获取等级列表 == %@" ,returnData);
        for (NSDictionary *dic in returnData[@"data"]) {
            HomePageModel *model = [HomePageModel yy_modelWithJSON:dic];
            [self.levelMarray addObject:model];
        }
        [self.myTableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
