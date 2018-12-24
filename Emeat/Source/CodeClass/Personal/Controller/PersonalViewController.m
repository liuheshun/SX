//
//  PersonalViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/8/22.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "PersonalViewController.h"
#import "YNPageViewController.h"
#import "UIViewController+YNPageExtend.h"


#import "HomePageDetailsViewController.h"
#import "HWPopTool.h"
#import "FeedBackView.h"

/// 开启刷新头部高度
#define kOpenRefreshHeaderViewHeight 1



@interface PersonalViewController ()<UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSString *baseURLString;
///当前处于哪一个segment
@property (nonatomic,assign) NSInteger pageIndex;
///记录当前登录状态
@property (nonatomic,strong) NSString *currenLoginStated;

@property (nonatomic,strong) FeedBackView *popupView ;

@end

@implementation PersonalViewController
{
    NSInteger totalPage;//分页
    NSInteger totalPageCount;//分页总数
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
  
    self.dataArray = [NSMutableArray array];
    totalPage = 1;
    YNPageViewController *vc = (YNPageViewController*)self.parentViewController;
    self.pageIndex = vc.pageIndex;
    [self addTableViewRefresh];
   //  [self isFirstLoadingData];
}

-(void)isFirstLoadingData{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if (self.pageIndex == 0) {///经常买
        
        self.baseURLString = [NSString stringWithFormat:@"%@/m/auth/user/get_often_commodity" , baseUrl];
        [self requestOftenListDataWithBaseURLString:self.baseURLString totalPage:1];
        
    }else if (self.pageIndex == 1){///赛选精选
        ///赛鲜精选
        self.baseURLString = [NSString stringWithFormat:@"%@/m/mobile/guess/guesslike?mtype=%@&promotionId=2&appVersionNumber=%@&user=%@&showType=PERSON" , baseUrl,mTypeIOS ,[user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"]];
        [self requesSaiXianDataBaseURLString:self.baseURLString];
    }
}

-(void)viewWillAppear:(BOOL)animated{
   
    
    
    [self isFirstLoadingData];

  

}


#pragma mark =====赛鲜精选 数据===

-(void)requesSaiXianDataBaseURLString:(NSString*)BaseURLString{

    [MHNetworkManager getRequstWithURL:BaseURLString params:nil successBlock:^(NSDictionary *returnData) {
        DLog(@"赛鲜精选数据=sssssd= %@" ,BaseURLString);

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

            [self.tableView reloadData];
        }else if ([[returnData[@"status"] stringValue] isEqualToString:@"201"]){
            [self.dataArray removeAllObjects];
            [[GlobalHelper shareInstance] removeEmptyView];
            self.currenLoginStated = @"2";
            
          
            [self.tableView reloadData];

        }


    } failureBlock:^(NSError *error) {

    } showHUD:NO];
}



#pragma mark ==================== 经常买 数据

-(void)requestOftenListDataWithBaseURLString:(NSString*)BaseURLString totalPage:(NSInteger)totalPage{
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
            
            self.currenLoginStated = @"0";
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
         
            
        }
        NSInteger pages = [returnData[@"data"][@"page"][@"totalPage"] integerValue];
        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"]) {
            [[GlobalHelper shareInstance] removeEmptyView];
            if (totalPage == 1) {
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
        }else if ([[returnData[@"status"] stringValue] isEqualToString:@"201"]){
            [self.dataArray removeAllObjects];
            [[GlobalHelper shareInstance] removeEmptyView];
            self.currenLoginStated = @"1";
           
            //            [loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:1];
            [self.tableView reloadData];
            
        }
        
        
        
    } failureBlock:^(NSError *error) {
        //DLog(@"经常买=error=%@" ,error);
        
    } showHUD:NO];
    
    
}






/// 重写父类方法 添加 刷新方法
- (void)addTableViewRefresh {
    
    
    __weak typeof (self) weakSelf = self;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        ///通知个人专区其它数据刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPersonData" object:nil];
        
        
        [weakSelf.tableView.mj_footer resetNoMoreData];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (kOpenRefreshHeaderViewHeight) {
                if (weakSelf.pageIndex == 0) {///经常买
                    
                    weakSelf.baseURLString = [NSString stringWithFormat:@"%@/m/auth/user/get_often_commodity" , baseUrl];
                    [weakSelf requestOftenListDataWithBaseURLString:self.baseURLString totalPage:1];
                    
                }else if (weakSelf.pageIndex == 1){///赛选精选
                    ///赛鲜精选
                    weakSelf.baseURLString = [NSString stringWithFormat:@"%@/m/mobile/guess/guesslike?mtype=%@&promotionId=2&appVersionNumber=%@&user=%@&showType=PERSON" , baseUrl,mTypeIOS ,[user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"]];
                    [weakSelf requesSaiXianDataBaseURLString:self.baseURLString];
                }
                [weakSelf suspendTopReloadHeaderViewHeight];
            } else {
                
                [weakSelf.tableView.mj_header endRefreshing];
            }
            
        });
    }];
    
    if (self.pageIndex == 0) {///经常买 才有上拉加载
        
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 
                
                totalPage++;
                if (totalPage<=totalPageCount) {
                    [self requestOftenListDataWithBaseURLString:self.baseURLString totalPage:totalPage];
                    
                    [self.tableView.mj_footer endRefreshing];
                    
                }else{
                    
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
                
            });
        }];
    }
   
    
    /// 需要设置下拉刷新控件UI的偏移位置
    self.tableView.mj_header.ignoredScrollViewContentInsetTop = self.yn_pageViewController.config.tempTopHeight;
    

}


#pragma mark - 悬浮Top刷新高度方法
- (void)suspendTopReloadHeaderViewHeight {
    
    /// 布局高度
    CGFloat netWorkHeight = (567+18-91)*kScale;
    __weak typeof (self) weakSelf = self;
    
    /// 结束刷新时 刷新 HeaderView高度
    [self.tableView.mj_header endRefreshingWithCompletionBlock:^{
        YNPageViewController *VC = weakSelf.yn_pageViewController;
        if (VC.headerView.frame.size.height != netWorkHeight) {
            VC.headerView.frame = CGRectMake(0, 0, kWidth, netWorkHeight);
            [VC reloadSuspendHeaderViewFrame];
            [weakSelf addTableViewRefresh];
        }
    }];
    
}





//
//- (void)addTableViewRefresh {
//
////    __weak typeof (self) weakSelf = self;
////
////    /// 这里加 footer 刷新
////    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
////        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//////            for (int i = 0; i < 30; i++) {
//////                [weakSelf.dataArray addObject:@""];
//////            }
////            [weakSelf.tableView reloadData];
////            [weakSelf.tableView.mj_footer endRefreshing];
////        });
////    }];
//
//}

#pragma mark - 求出占位cell高度
- (CGFloat)placeHolderCellHeight {
    CGFloat height = self.config.contentHeight - 135*kScale * self.dataArray.count;
    height = height < 0 ? 0 : height;
    return height;
}


-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
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
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135*kScale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.dataArray.count == 0) {
        return [self placeHolderCellHeight];

    }
    
    return 15*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.dataArray.count == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 15*kScale)];
        view.backgroundColor = [UIColor whiteColor];
        if ([self.currenLoginStated isEqualToString:@"0"]) {
            [[GlobalHelper shareInstance] emptyViewNoticeText:@"如需查看购买过的商品记录,请先登录" NoticeImageString:@"未登录" viewWidth:50 viewHeight:54 UITableView:view isShowBottomBtn:YES bottomBtnTitle:@"点击登录"];
            [[GlobalHelper shareInstance].bottomBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:1];
        }else if ([self.currenLoginStated isEqualToString:@"1"]){
            
            [[GlobalHelper shareInstance] emptyViewNoticeText:@"您还未购买过任何商品,看看大家都买了啥!" NoticeImageString:@"未购买" viewWidth:50 viewHeight:54 UITableView:view isShowBottomBtn:YES bottomBtnTitle:@"瞧一瞧"];
            [[GlobalHelper shareInstance].bottomBtn addTarget:self action:@selector(showOther) forControlEvents:1];
            
        }else if ([self.currenLoginStated isEqualToString:@"2"]){
            [[GlobalHelper shareInstance] emptyViewNoticeText:@"暂无商品" NoticeImageString:@"未购买" viewWidth:50 viewHeight:54 UITableView:self.tableView isShowBottomBtn:NO bottomBtnTitle:@""];
        }
       
        
        
        return view;
    }
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 15*kScale)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}


#pragma mark ==============点击登陆
-(void)loginBtnAction{
    LoginViewController *VC = [LoginViewController new];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark ==========经常买 未购买商品 点击事件

-(void)showOther{
    //DLog(@"看一看");
      YNPageViewController *vc = (YNPageViewController*)self.parentViewController;
    [vc setSelectedPageIndex:1];
    //    selectIndex
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectIndex" object:[NSString stringWithFormat:@"%@", @"1"]];
}




-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
     if (self.pageIndex == 0) {///经常买
         return 0.001*kScale;

     }
    return 100*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 100*kScale)];
    view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, kWidth, 100*kScale);
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:@"  没有商品啦~告诉我你想买点啥" forState:0];
    [btn setTitleColor:RGB(136, 136, 136, 1) forState:0];
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
    [btn setImage:[UIImage imageNamed:@"bianji"] forState:0];
    [btn addTarget:self action:@selector(postfeedbackAction) forControlEvents:1];
    if (self.pageIndex == 0) {///经常买
        [btn removeFromSuperview];
        
    }else{
        [view addSubview:btn];

    }
    return view;
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

#pragma mark ====≠≠≠======提交反馈建议

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
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"person_CellIdentifier_cell%ld" ,indexPath.row];//以indexPath来唯一确定cell
    //NSString *CellIdentifier = @"person_CellIdentifier_cell";

    HomePageTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell1 == nil) {
        cell1 = [[HomePageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell1.backgroundColor = [UIColor whiteColor];
    }
    
   
    if (self.dataArray.count!=0) {
        cell1.cartBtn.tag = indexPath.row;
        [cell1.cartBtn addTarget:self action:@selector(cartBtnAction:) forControlEvents:1];
        HomePageModel *model =  self.dataArray[indexPath.row];
        totalPageCount = model.pages;
        model.goodsTypes = @"0";
        [cell1 configHomePageCellWithModel:model];
    }
    
    return cell1;
}




#pragma mark =============== 加入购物车点击事件


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
    
    
    if ([[user  valueForKey:@"approve"] isEqualToString:@"0"] || [[user  valueForKey:@"approve"] isEqualToString:@"2"]) {
        [dic setValue:@"PERSON" forKey:@"showType"];
        
    }else if ([[user  valueForKey:@"approve"] isEqualToString:@"1"]){
        [dic setValue:@"SOGO" forKey:@"showType"];
        
    }
    
#pragma mark---------------------------------需要更改productID--------------------------------
    
    //[dic setObject:[NSString stringWithFormat:@"%ld" ,productId] forKey:@"productId"];
    [dic setValue:[NSString stringWithFormat:@"%ld" ,(long)productId] forKey:@"commodityId"];
    
    [dic setObject:@"1" forKey:@"quatity"];
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
            //DLog(@"-------------=== %f  %f" ,rect.origin.y , imageViewRect.origin.y );
            
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
        DLog(@"首页加入购物车== id=== %ld  %@" ,productId,returnData);
        [tableView reloadData];
    } failureBlock:^(NSError *error) {
        
        //DLog(@"首页加入购物车error ========== id= %ld  %@" ,productId,error);
        
    } showHUD:NO];
    
}



#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    HomePageDetailsViewController *VC = [HomePageDetailsViewController new];
    VC.hidesBottomBarWhenPushed = YES;
    HomePageModel *model = self.dataArray[indexPath.row];
    VC.detailsId = [NSString stringWithFormat:@"%ld" ,(long)model.id];
    ///标记详情页 显示C端详情
    VC.isFromBORC = @"c";
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
