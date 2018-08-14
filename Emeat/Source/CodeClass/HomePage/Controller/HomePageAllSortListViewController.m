//
//  HomePageAllSortListViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/8/2.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "HomePageAllSortListViewController.h"
#import "HomePageSortListTableViewCell.h"
#import "FeedBackView.h"
#import "HomePageDetailsViewController.h"

#import "HWPopTool.h"

@interface HomePageAllSortListViewController ()<UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic,strong) UITableView *mainRightTableView;

@property (nonatomic,strong) UITableView *leftTableView;


///商品数据数组
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *secondaryMarray;

@property (nonatomic,strong) NSString *baseURLString;

@property (nonatomic,assign) NSInteger titleIndexs;


@property (nonatomic,strong) NSString *isReloadLeftTableView;

@property (nonatomic,assign) NSInteger secondId;

///等级列表
@property (nonatomic,strong) NSMutableArray *levelMarray;

@property (nonatomic,assign) NSInteger levelStatedSelectIndex;

@property (nonatomic,strong) FeedBackView *popupView ;

@end

@implementation HomePageAllSortListViewController
{
    NSInteger totalPage;//分页
    NSInteger totalPageCount;//分页总数
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    self.isReloadLeftTableView = @"1";
    self.levelStatedSelectIndex = 10000;
    [self.view addSubview:self.mainRightTableView];
    [self.view addSubview:self.leftTableView];
   
    self.dataArray = [NSMutableArray array];
    self.secondaryMarray = [NSMutableArray array];
    self.levelMarray = [NSMutableArray array];
    DLog(@"sortId====== %ld  sortType===== %@" ,(long)self.sortId , self.sortType);
    
    [self getLevelListData];
    
    if (self.isFirsrEnter == 1) {
    if ([self.sortType isEqualToString:@"STAIR"]) {//一级
        if (self.isFirsrEnter == 1) {
            
            [self requestFirstLevelData];
        }
    }else if ([self.sortType isEqualToString:@"VFP"]){//二级
        if (self.isFirsrEnter == 1) {
            
            [self requestgoodsDataWithSonId:self.sortId ];

        }
    }
    }
    
//    self.segmentTitleMarray = [NSMutableArray array];
//    [self requestFirstLevelData];
//
    
}

//-(void)viewWillDisappear:(BOOL)animated{
//    [GlobalHelper shareInstance].isEnterDetails = @"0";
//}

-(void)viewWillAppear:(BOOL)animated{
    
    if ([[GlobalHelper shareInstance].merchantsIsLoginStated isEqualToString:@"2"] && [[GlobalHelper shareInstance].isMerchantsIsLoginEnter isEqualToString:@"2"]
        ) {
            [GlobalHelper shareInstance].merchantsIsLoginStated = @"1";
            [GlobalHelper shareInstance].isMerchantsIsLoginEnter = @"1";
            self.baseURLString = [NSString stringWithFormat:@"%@/m/auth/user/get_often_commodity" , baseUrl];
            [self requestOftenListData:totalPage BaseURLString:self.baseURLString totalPage:1];
    }
    
    
    if ([[GlobalHelper shareInstance].isEnterDetails isEqualToString:@"1"]) {
        
       // [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectIndexRefreshData" object:nil];

    }else{
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectIndexRefreshData:) name:@"selectIndexRefreshData" object:nil];
    }
    DLog(@"viewWillAppear======titleIndexs======= %ld" ,self.titleIndexs);
}

#pragma mark ===========通知事件 
- (void)selectIndexRefreshData:(NSNotification *)noti {
    [self.dataArray removeAllObjects];
    [[GlobalHelper shareInstance] removeEmptyView];
    //[self.feedBackBtn removeFromSuperview];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectIndexRefreshData" object:nil];

    self.titleIndexs = [noti.object integerValue];
    DLog(@"通知事件 titlecccccccc======= %ld" ,self.segmentTitleMarray.count);
    if (self.segmentTitleMarray.count == 0) {
        self.segmentTitleMarray = [NSMutableArray array];
        [self requestFirstLevelData];
    }
    
    
    if (self.titleIndexs <3) {///列表显示
        
        CGRect rectMain = self.mainRightTableView.frame;
        rectMain.origin.x = 0;
        rectMain.size.width = kWidth;
        self.mainRightTableView.frame = rectMain;
        
        CGRect rectLeft = self.leftTableView.frame;
        rectLeft.size.width = 0;
        self.leftTableView.frame = rectLeft;
        
        [self.mainRightTableView reloadData];
    }else{
        CGRect rectMain = self.mainRightTableView.frame;
        rectMain.origin.x = 85*kScale;
        rectMain.size.width = kWidth - 85*kScale ;
        self.mainRightTableView.frame = rectMain;
        
        CGRect rectLeft = self.leftTableView.frame;
        rectLeft.size.width = 85*kScale;
        self.leftTableView.frame = rectLeft;
        [self.mainRightTableView reloadData];
        [self.leftTableView reloadData];
    }
    
    
    
       totalPage=1;

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
   
        if (self.titleIndexs == 0) {
    
    
                ///经常买
                self.baseURLString = [NSString stringWithFormat:@"%@/m/auth/user/get_often_commodity" , baseUrl];
                [self setupRefresh];
    
            [self requestOftenListData:totalPage BaseURLString:self.baseURLString totalPage:totalPage];
    
        }else if (self.titleIndexs == 1){
            ///大家都在买
            self.baseURLString = [NSString stringWithFormat:@"%@/m/mobile/commodity/get_other_buy?mtype=%@&appVersionNumber=%@&user=%@" , baseUrl,mTypeIOS ,[user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"]];
            [self requestALLPeopleDataBaseURLString:self.baseURLString];
    
        }else if (self.titleIndexs == 2){
            ///赛鲜精选
            self.baseURLString = [NSString stringWithFormat:@"%@//m/mobile/guess/guesslike?mtype=%@&promotionId=2&appVersionNumber=%@&user=%@" , baseUrl,mTypeIOS ,[user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"]];
            [self requesSaiXianDataBaseURLString:self.baseURLString];
    
        }else if (self.titleIndexs >=3){
            ///一级分类请求数据
            
            [self setupRefresh];
            HomePageModel *model = self.segmentTitleMarray[self.titleIndexs];
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
//    self.mainRightTableView.mj_header  = header;
//    header.lastUpdatedTimeLabel.hidden = YES;
//    [self.mainRightTableView.mj_header beginRefreshing];
    //上拉加载
    self.mainRightTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 加载旧的数据，加载旧的未显示的数据
        [self footerRereshing];
    }];
}

//
//- (void)headerRereshing{
//
//    totalPage=1;
//    if (self.titleIndexs == 0) {
//        [self requestOftenListData:totalPage BaseURLString:self.baseURLString totalPage:totalPage];
//
//    }
//
//    if (self.titleIndexs >=3){
//        ///一级分类请求数据
//        HomePageModel *model = self.segmentTitleMarray[self.titleIndexs];
//        if ([self.isReloadLeftTableView isEqualToString:@"1"]) {
//            [self requestFirstSortDataWithBigClassId:model.bigClassifyId totalPage:totalPage];
//
//        }else if ([self.isReloadLeftTableView isEqualToString:@"0"]){
//            [self requestGoodsListDataWithBigClassId:model.bigClassifyId secondId:self.secondId totalPage:totalPage];
//
//        }
//
//
//        //if ([self.sortType isEqualToString:@"STAIR"]) {//一级
//
//          //  [self requestFirstSortDataWithBigClassId:self.sortId totalPage:totalPage];
//        //}else if ([self.sortType isEqualToString:@"VFP"]){//二级
//           // [self requestgoodsDataWithSonId:self.sortId totalPage:totalPage];
//       // }
//
//
//    }
//
//    [self.mainRightTableView.mj_header endRefreshing];
//    [self.mainRightTableView.mj_footer endRefreshing];
//
//}


#pragma mark=====================上拉加载============================

- (void)footerRereshing{
    
    totalPage++;
    if (totalPage<=totalPageCount) {
        if (self.titleIndexs == 0) {
            [self requestOftenListData:totalPage BaseURLString:self.baseURLString totalPage:totalPage];
            
        }
        
        if (self.titleIndexs >=3){
            ///一级分类请求数据
            HomePageModel *model = self.segmentTitleMarray[self.titleIndexs];
            
            [self requestFirstSortDataWithBigClassId:model.bigClassifyId totalPage:totalPage];
        }
        
        
        
        [self.mainRightTableView.mj_footer endRefreshing];
        
    }else{
        
        [self.mainRightTableView.mj_footer endRefreshingWithNoMoreData];
    }
}


#pragma mark ====  一级分类菜单标签  ====

-(void)requestFirstLevelData{
    self.segmentTitleMarray = [NSMutableArray array];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/classify/get_classifys?mtype=%@&appVersionNumber=%@&user=%@" ,baseUrl ,mTypeIOS ,[user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"]] params:nil successBlock:^(NSDictionary *returnData) {
        DLog(@"一级分类标签数据 = %@" ,returnData);
        if ([returnData[@"status"] integerValue] == 200) {
            ///初始数据
            NSArray *titleArray = @[@{@"classifyName":@"经常买"} ,@{@"classifyName":@"大家都在买"} ,@{@"classifyName":@"赛鲜精选"}];
            [self.segmentTitleMarray removeAllObjects];
            for (NSDictionary *dic in titleArray) {
                HomePageModel *model = [HomePageModel yy_modelWithJSON:dic];
                [self.segmentTitleMarray addObject:model];
            }
            for (NSDictionary *dic in returnData[@"data"]) {
                HomePageModel *model = [HomePageModel yy_modelWithJSON:dic];
                NSString *bigClassifyId = dic[@"id"];
                model.bigClassifyId = [bigClassifyId integerValue];
                [self.segmentTitleMarray addObject:model];
                if (self.isFirsrEnter == 1) {
                    if (model.bigClassifyId == self.sortId) {
                        self.titleIndexs = [self.segmentTitleMarray indexOfObject:model];
                        DLog(@" titleIndexs ============= %ld" ,self.titleIndexs);
                        
                    }
                }
                
            }
            if (self.isFirsrEnter == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSelectedIndex" object:[NSString stringWithFormat:@"%ld", self.titleIndexs]];
                
            }
           
           
            [self.mainRightTableView reloadData];
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
    DLog(@"根据一级分类id 查询数据 == %@" ,dic);
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/classify/get_classify_list" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
        DLog(@"根据一级分类id 查询数据=== %@" ,returnData);
        if ([returnData[@"status"] integerValue] == 200) {
            [self.dataArray removeAllObjects];
            [self.secondaryMarray removeAllObjects];
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
           ///默认选中的侧边栏secondId
            HomePageModel *model1 = [self.secondaryMarray firstObject];
            self.secondId = model1.id;
        }
        if ([self.isReloadLeftTableView isEqualToString:@"1"]) {
            [self.leftTableView reloadData];

        }
        [self.mainRightTableView reloadData];
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
}


#pragma mark ===========根据二级分类id查总一级分类ID


-(void)requestgoodsDataWithSonId:(NSInteger)sonId {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSString stringWithFormat:@"%ld" ,sonId] forKey:@"sonId"];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    DLog(@"根据二级分类请求商品数据 == %@" ,dic);
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/classify/get_classify_list" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
        DLog(@"根据二级分类请求商品数据=== %@" ,returnData);
        if ([returnData[@"status"] integerValue] == 200) {
            
            self.sortId = [returnData[@"data"][@"bigClassId"] integerValue];
            [self requestFirstLevelData];
            
//            if (totalPage == 1) {
//                [self.dataArray removeAllObjects];
//            }
//
//            NSInteger pages = [returnData[@"data"][@"result"][@"page"][@"totalPage"] integerValue];
//
//            for (NSDictionary *dic in returnData[@"data"][@"result"][@"list"]) {
//                HomePageModel *model = [HomePageModel yy_modelWithJSON:dic];
//                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
//                if (mainImvMarray.count!=0) {
//                    model.mainImage = [mainImvMarray firstObject];
//                }
//                model.pages = pages;
//                [self.dataArray addObject:model];
//            }
//
            
           // [self.mainRightTableView reloadData];
        }
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
}



#pragma mark =====赛鲜精选 数据===

-(void)requesSaiXianDataBaseURLString:(NSString*)BaseURLString{
    
    [MHNetworkManager getRequstWithURL:BaseURLString params:nil successBlock:^(NSDictionary *returnData) {
        DLog(@"赛鲜精选数据=sssssd= %@" ,returnData);
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
            
            [self.mainRightTableView reloadData];
        }else if ([[returnData[@"status"] stringValue] isEqualToString:@"201"]){
            [self.dataArray removeAllObjects];
            [[GlobalHelper shareInstance] removeEmptyView];
            
            [[GlobalHelper shareInstance] emptyViewNoticeText:@"暂无商品" NoticeImageString:@"未购买" viewWidth:50 viewHeight:54 UITableView:self.mainRightTableView isShowBottomBtn:NO bottomBtnTitle:@""];
            [[GlobalHelper shareInstance].bottomBtn addTarget:self action:@selector(showOther) forControlEvents:1];
            //            [loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:1];
            [self.mainRightTableView reloadData];
            
        }
        
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}






#pragma mark =====大家都在买 数据===

-(void)requestALLPeopleDataBaseURLString:(NSString*)BaseURLString{
    
    [MHNetworkManager getRequstWithURL:BaseURLString params:nil successBlock:^(NSDictionary *returnData) {
        DLog(@"大家都在买 数据=sssssd= %@" ,returnData);
        
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
            
            [self.mainRightTableView reloadData];
        }
        
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}



#pragma mark = 经常买 = 列表数据

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
    DLog(@"经常买1111= %@" ,dic);
    
    [MHAsiNetworkHandler startMonitoring];
    [MHNetworkManager postReqeustWithURL:BaseURLString params:dic successBlock:^(NSDictionary *returnData) {
        
        DLog(@"经常买=sssssd= %@" ,returnData);
        [[GlobalHelper shareInstance] removeEmptyView];

        if ([[NSString stringWithFormat:@"%@" ,returnData[@"code"]] isEqualToString:@"0404"] || [[NSString stringWithFormat:@"%@" ,returnData[@"code"]] isEqualToString:@"04"]) {
            DLog(@"未登录");
            
            [self.dataArray removeAllObjects];
            [self.mainRightTableView reloadData];
            [[GlobalHelper shareInstance] emptyViewNoticeText:@"如需查看购买过的商品记录,请先登陆" NoticeImageString:@"未登录" viewWidth:50 viewHeight:54 UITableView:self.mainRightTableView isShowBottomBtn:YES bottomBtnTitle:@"点击登陆"];
            [[GlobalHelper shareInstance].bottomBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:1];
            
        }
        
        NSInteger pages = [returnData[@"data"][@"page"][@"totalPage"] integerValue];
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
                [self.dataArray addObject:model];
            }
            
        }else if ([[returnData[@"status"] stringValue] isEqualToString:@"201"]){
            [self.dataArray removeAllObjects];
            
            [[GlobalHelper shareInstance] emptyViewNoticeText:@"您还未购买过任何商品,看看大家都买了啥!" NoticeImageString:@"未购买" viewWidth:50 viewHeight:54 UITableView:self.mainRightTableView isShowBottomBtn:YES bottomBtnTitle:@"瞧一瞧"];
            [[GlobalHelper shareInstance].bottomBtn addTarget:self action:@selector(showOther) forControlEvents:1];
            //            [loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:1];
//            [self.mainRightTableView reloadData];

            
        }
        [self.mainRightTableView reloadData];

        
        
    } failureBlock:^(NSError *error) {
        DLog(@"经常买=sssssd=%@" ,error);
        
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

#pragma mark ==========经常买 未购买商品 点击事件

-(void)showOther{
    //    DLog(@"看一看");[NSString stringWithFormat:@"%ld", self.titleIndexs]
    //    selectIndex
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSelectedIndex" object:[NSString stringWithFormat:@"%@", @"1"]];
}

-(UITableView*)mainRightTableView{
    if (!_mainRightTableView) {
        _mainRightTableView = [[UITableView alloc] initWithFrame:CGRectMake(85*kScale, 10*kScale, kWidth-85*kScale, kHeight-kBarHeight-44-LL_TabbarSafeBottomMargin-10*kScale) style:UITableViewStyleGrouped];
        _mainRightTableView.delegate = self;
        _mainRightTableView.dataSource = self;
        [_mainRightTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _mainRightTableView.backgroundColor =  RGB(238, 238, 238, 1);;
    }
    return _mainRightTableView;
}
-(UITableView*)leftTableView{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10*kScale, 85, kHeight-kBarHeight-44-LL_TabbarSafeBottomMargin-10*kScale) style:UITableViewStyleGrouped];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        [_leftTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _leftTableView.backgroundColor = RGB(238, 238, 238, 1);
    }
    return _leftTableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.titleIndexs <3) {
        return 1;
    }else{
    if (tableView == self.leftTableView) {
        return 1;
    }
    return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.titleIndexs <3) {
        return self.dataArray.count;
    }else{
    if (tableView == self.leftTableView) {
        return self.secondaryMarray.count;
    }
        return self.dataArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.titleIndexs <3) {
        return  135*kScale;
    }else{
    if (tableView == self.leftTableView) {
        return 41*kScale;
    }
    return 100*kScale;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.titleIndexs < 3) {
        return 0.001*kScale;
    }else{
    if (tableView == self.leftTableView) {
        return 0.001*kScale;
    }
    return 41*kScale;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.titleIndexs < 3) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 85*kScale, 0.001*kScale)];
        view.backgroundColor = [UIColor whiteColor];
        return view;
    }else{
    if (tableView == self.leftTableView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 85*kScale, 0.001*kScale)];
        view.backgroundColor = [UIColor whiteColor];
        return view;
    }else{
    
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(85*kScale, 0, kWidth-85*kScale, 15*kScale)];
        view.backgroundColor = [UIColor whiteColor];
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
            [view addSubview:levelBtn];
            [levelBtn addTarget:self action:@selector(levelBtnClickAction:) forControlEvents:1];
    }
        
    return view;

    }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.titleIndexs <3) {
        return 100*kScale;
    }else{
    if (tableView == self.leftTableView) {
        return 0.001*kScale;
    }
    return 100*kScale;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.titleIndexs <3) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 100*kScale)];
        view.backgroundColor = RGB(238, 238, 238, 1);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, kWidth, 100*kScale);
        btn.backgroundColor = RGB(238, 238, 238, 1);
        [btn setTitle:@"  没有商品啦~告诉我你想买点啥" forState:0];
        [btn setTitleColor:RGB(136, 136, 136, 1) forState:0];
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        [btn setImage:[UIImage imageNamed:@"bianji"] forState:0];
        [btn addTarget:self action:@selector(postfeedbackAction) forControlEvents:1];

        if ( self.dataArray.count != 0 ) {
            [view addSubview:btn];

        }else{
            [btn removeFromSuperview];

        }
        return view;
        
    }else{
    
        if (tableView == self.leftTableView) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.001*kScale)];
            view.backgroundColor = RGB(238, 238, 238, 1);
            return view;
        }
       
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth-85*kScale, 100*kScale)];
        view.backgroundColor = RGB(238, 238, 238, 1);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, kWidth-85*kScale, 100*kScale);
        btn.backgroundColor = RGB(238, 238, 238, 1);
        [btn setTitle:@"  没有商品啦~告诉我你想买点啥" forState:0];
        [btn setTitleColor:RGB(136, 136, 136, 1) forState:0];
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        [btn setImage:[UIImage imageNamed:@"bianji"] forState:0];
        [btn addTarget:self action:@selector(postfeedbackAction) forControlEvents:1];
        if (self.dataArray.count != 0) {
            [view addSubview:btn];

        }else{
            [btn removeFromSuperview];
        }
        return view;
    
    }
}

-(void)postfeedbackAction{
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
        DLog(@"反馈==== %@" ,returnData);
        if ([returnData[@"status"] integerValue] == 200) {
            
            [[HWPopTool sharedInstance] closeWithBlcok:^{
                
            }];
            
        }
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.titleIndexs < 3) {
        NSString *CellIdentifier = [NSString stringWithFormat:@"sortCellIdentifier_cell%ld" ,indexPath.row];//以indexPath来唯一确定cell
        
        HomePageTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell1 == nil) {
            cell1 = [[HomePageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell1.backgroundColor = [UIColor whiteColor];
        }
        
        cell1.cartBtn.tag = indexPath.row;
        [cell1.cartBtn addTarget:self action:@selector(cartBtnAction:) forControlEvents:1];
        if (self.dataArray.count!=0) {
            HomePageModel *model =  self.dataArray[indexPath.row];
            totalPageCount = model.pages;
            [cell1 configHomePageCellWithModel:model];
        }
        
        return cell1;
        
    }else{
        
    if (tableView == self.leftTableView) {
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"leftlist_cells"];
        if (cell1 == nil) {
            cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"leftlist_cells"];
            
           // [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
            cell1.backgroundColor = RGB(238, 238, 238, 1);
            
        }
       
        //默认选中第一行
        cell1.selectedBackgroundView = [[UIView alloc]initWithFrame:cell1.bounds];
        cell1.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]animated:YES scrollPosition:UITableViewScrollPositionTop];

        if (self.secondaryMarray.count !=0) {
            HomePageModel *model = self.secondaryMarray[indexPath.row];
            cell1.textLabel.text = model.dataName;
            cell1.textLabel.backgroundColor = [UIColor clearColor];
            cell1.textLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
            cell1.textLabel.textColor = RGB(51, 51, 51, 1);
        }
        
        
        
        
        return cell1;
    }
    
        NSString *CellIdentifier = [NSString stringWithFormat:@"rightMain_cell_%ld" ,indexPath.row];//以indexPath来唯一确定cell
        
        HomePageSortListTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell1 == nil) {
            cell1 = [[HomePageSortListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell1.backgroundColor = [UIColor whiteColor];
        }
        
        cell1.cartBtn.tag = indexPath.row;
        [cell1.cartBtn addTarget:self action:@selector(cartBtnAction:) forControlEvents:1];
        if (self.dataArray.count!=0) {
            HomePageModel *model =  self.dataArray[indexPath.row];
            totalPageCount = model.pages;
            [cell1 configCellWithModel:model];
        }
        
        return cell1;
        
}
}

#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    if (self.titleIndexs>=3) {
        
        if (tableView == self.leftTableView) {
            
            HomePageModel * model = self.segmentTitleMarray[self.titleIndexs];
            
            HomePageModel *smodel = self.secondaryMarray[indexPath.row];
            self.isReloadLeftTableView = @"0";
            DLog(@"一级 == %ld  二级====%ld" ,model.bigClassifyId ,smodel.id);
            self.secondId = smodel.id;
            self.levelStatedSelectIndex = 10000;
            [self requestGoodsListDataWithBigClassId:model.bigClassifyId secondId:smodel.id totalPage:1];
            
        }else{
            if (self.dataArray.count != 0) {
                [GlobalHelper shareInstance].isEnterDetails = @"1";

                HomePageDetailsViewController *VC = [HomePageDetailsViewController new];
                VC.hidesBottomBarWhenPushed = YES;
                HomePageModel *model = self.dataArray[indexPath.row];
                VC.detailsId = [NSString stringWithFormat:@"%ld" ,(long)model.id];
                
                [self.navigationController pushViewController:VC animated:YES];
            }
        }
        
        
    }else{
        if (self.dataArray.count != 0) {
            HomePageDetailsViewController *VC = [HomePageDetailsViewController new];
            VC.hidesBottomBarWhenPushed = YES;
            HomePageModel *model = self.dataArray[indexPath.row];
            VC.detailsId = [NSString stringWithFormat:@"%ld" ,(long)model.id];
            [GlobalHelper shareInstance].isEnterDetails = @"1";
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
    DLog(@"根据二级分类请求商品数据 == %@" ,dic);
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/classify/get_classify_list" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
        DLog(@"根据二级分类请求商品数据=== %@" ,returnData);
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
            
            
            
            
             [self.mainRightTableView reloadData];
        }
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
    
}



-(void)levelBtnClickAction:(UIButton*)btn{
    if (self.levelMarray.count != 0) {
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
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    DLog(@" 按等级筛选 === %@" ,dic);

    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/mobile/commodity/search_item_list" , baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        DLog(@" 按等级筛选 === %@" ,returnData);
        if ([returnData[@"status"] integerValue] == 200) {
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
       
            [self.mainRightTableView reloadData];
        }else if ([returnData[@"status"] integerValue] == 201){
            [SVProgressHUD showErrorWithStatus:returnData[@"msg"]];
        }
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
}




#pragma mark =============== 一级分类加入购物车点击事件


#pragma mark ==================加入购物车点击事件
-(void)cartBtnAction:(UIButton*)btn{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user valueForKey:@"isLoginState"]) {
        [GlobalHelper shareInstance].isLoginState = [user valueForKey:@"isLoginState"];
    }
    if ([[GlobalHelper shareInstance].isLoginState isEqualToString:@"1"])
    {
        
        NSIndexPath *myIndex=[self.mainRightTableView indexPathForCell:(HomePageTableViewCell*)[btn superview]];
        HomePageTableViewCell *cell1 = [self.mainRightTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:myIndex.section]];
        
        //后期可能会有此需求(商品首页回显加入购物车数量)下面一行需要删掉
        // [cell1.cartBtn removeFromSuperview];
        
        if (self.dataArray.count != 0)
        {
            HomePageModel *model = self.dataArray[myIndex.row];
            
            [self addCartPostDataWithProductId:model.id homePageModel:model NSIndexPath:myIndex cell:cell1 isFirstClick:YES tableView:self.mainRightTableView];
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:myIndex.row inSection:myIndex.section];
            [self.mainRightTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
        }
        
    }else
    {
        LoginViewController *VC = [LoginViewController new];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        
        
    }
}



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
    DLog(@"加入购物车 ==== %@" , dic);
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
            [SVProgressHUD showSuccessWithStatus:@"加入购物车成功"];
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
            DLog(@"-------------=== %f  %f" ,rect.origin.y , imageViewRect.origin.y );
            
//            [[PurchaseCarAnimationTool shareTool]startAnimationandView:weakCell.mainImv andRect:imageViewRect andFinisnRect:CGPointMake(ScreenWidth/4*2, ScreenHeight-49) topView:self.view andFinishBlock:^(BOOL finish) {
//
//
//                UIView *tabbarBtn = self.tabBarController.tabBar.subviews[2];
//                [PurchaseCarAnimationTool shakeAnimation:tabbarBtn];
//            }];
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
        DLog(@"首页加入购物车== id=== %ld  %@" ,productId,returnData);
        [tableView reloadData];
    } failureBlock:^(NSError *error) {
        
        DLog(@"首页加入购物车error ========== id= %ld  %@" ,productId,error);
        
    } showHUD:NO];
    
}



#pragma mark =========获取等级列表

-(void)getLevelListData{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
   
    [MHNetworkManager getRequstWithURL:[NSString stringWithFormat:@"%@/m/mobile/commodity/get_grade_list?mtype=%@&appVersionNumber=%@&user=%@" ,baseUrl ,mTypeIOS ,[user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"]] params:nil successBlock:^(NSDictionary *returnData) {
        DLog(@"获取等级列表 == %@" ,returnData);
        for (NSDictionary *dic in returnData[@"data"]) {
            HomePageModel *model = [HomePageModel yy_modelWithJSON:dic];
            [self.levelMarray addObject:model];
        }
        [self.mainRightTableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
    
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
