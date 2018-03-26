//
//  HomePageDetailsViewController.m
//  Emeat
//
//  Created by liuheshun on 2017/11/20.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "HomePageDetailsViewController.h"
#import "HomePageDetailsHeadView.h"
#import "HomePageCommentDetailsTableViewCell.h"
#import "HomePageDetailsBottomView.h"
#import "LoginViewController.h"
#import "HomePageDetailsBuyNoticeView.h"
#import "HomePageShoppingDetailsTableViewCell.h"
@interface HomePageDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) HomePageDetailsHeadView *headView;
@property (nonatomic,strong) HomePageDetailsBottomView *bottomView;
@property (nonatomic,strong) HomePageDetailsBuyNoticeView *buyNoticeView;

///轮播图数据源
@property (nonatomic,strong) NSMutableArray *bannerDataArray;
///详情图片数据源
@property (nonatomic,strong) NSMutableArray *detailsDataArray;

///规格
@property (nonatomic,strong) NSMutableArray *headDataArray;


@end

@implementation HomePageDetailsViewController
{
    BOOL isClickGoods;
}


-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [GlobalHelper shareInstance].isLoginState = [user valueForKey:@"isLoginState"];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navItem.title = @"商品详情";
    [self showNavBarItemRight];
    isClickGoods = YES;
   
    [self requsetDetailsData];
    
    
    [self setButtonBadgeValue:self.bottomView.cartBtn badgeValue:[NSString stringWithFormat:@"%ld",[GlobalHelper shareInstance].shoppingCartBadgeValue ] badgeOriginX:MaxX(self.bottomView.cartBtn.imageView)-5 badgeOriginY:Y(self.bottomView.cartBtn.imageView)-12];
    
}
#pragma mark = 商品详情数据

-(void)requsetDetailsData{
    [SVProgressHUD show];
    self.bannerDataArray = [NSMutableArray array];
    self.detailsDataArray = [NSMutableArray array];
    self.headDataArray = [NSMutableArray array];
    NSString *str;
    if ([self.fromBaner isEqualToString:@"1"]) {////来自banner
        str = [NSString stringWithFormat:@"%@/mobile/commodity/commodityDeatilByCode?commodityCode=%@" ,baseUrl ,self.detailsId];
    }
    else ///来自商品列表
    {
        str = [NSString stringWithFormat:@"%@/mobile/commodity/commodityDeatil?id=%@" , baseUrl ,self.detailsId];
    }
    
    DLog(@"详情接口==== %@" ,str);
    
    [MHNetworkManager getRequstWithURL:str params:nil successBlock:^(NSDictionary *returnData) {
        DLog(@"详情返回结果=== %@" ,returnData);
            if ([[returnData[@"status"] stringValue] isEqualToString:@"200"]) {
                
                HomePageModel *bannerModel = [HomePageModel yy_modelWithJSON:returnData[@"data"]];
                
                if (bannerModel) {
                    [self.headDataArray addObject:bannerModel];
                    self.bannerDataArray = [NSMutableArray arrayWithArray:[bannerModel.commodityBanner componentsSeparatedByString:@","]];
                    
                    NSMutableArray *imvMarray = [NSMutableArray arrayWithArray:[bannerModel.commodityDetail componentsSeparatedByString:@","]];
                    
                    for (NSString *imvString in imvMarray) {
                        HomePageModel *detailsModel = [HomePageModel new];
                        detailsModel.commodityDetail = imvString;
                        [self.detailsDataArray addObject:detailsModel];
                    }
                    [SVProgressHUD dismiss];
                    [self.view addSubview:self.tableView];
                    [self.view addSubview:self.bottomView];
                    [self.tableView reloadData];
                }
              
            }else{
                [self alertMessage:returnData[@"msg"] willDo:nil];
            }            
            
        } failureBlock:^(NSError *error) {
            
            
        } showHUD:NO];
        

}





//
////商品详情事件
//-(void)goodsDetailsBtnAction{
//    isClickGoods = YES;
//    [self.tableView reloadData];
//}
////商品 评价详情事件
//-(void)pingjiaDetailsBtnAction{
//    isClickGoods = NO;
//    [self.tableView reloadData];
//
//}

#pragma mark = 提示

-(void)noticeBtnAvtion{

    
    [self.buyNoticeView showBuyNotice];
    
}


-(void)connectRightItemAction{
    DLog(@"联系客服");
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4001106111"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

-(void)shareRightItemAction{
    DLog(@"分享");
}


-(void)showNavBarItemRight{
    
    UIBarButtonItem *connectRightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"kefu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(connectRightItemAction)];
   // UIBarButtonItem *shareRightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fenxiang"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(shareRightItemAction)];
    
    
    [self.navBar pushNavigationItem:self.navItem animated:NO];
   // [self.navItem setRightBarButtonItems:[NSArray arrayWithObjects:shareRightItem ,connectRightItem, nil]];
    [self.navItem setRightBarButtonItems:[NSArray arrayWithObjects: connectRightItem, nil]];

    
    // [self.navBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f*kScale],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    
}






-(HomePageDetailsBuyNoticeView *)buyNoticeView{
    if (!_buyNoticeView) {
        _buyNoticeView = [[HomePageDetailsBuyNoticeView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-LL_TabbarSafeBottomMargin)];
        _buyNoticeView.backgroundColor = RGB(0, 0, 0, 0.6);
    }
    return _buyNoticeView;
}

-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kBarHeight, kWidth, kHeight-kBarHeight-49-LL_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
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
    if (isClickGoods == NO) {
        return 4;
    }
    return self.detailsDataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isClickGoods == NO) {
        return 220;
    }
    // 先从缓存中查找图片
    HomePageModel *model = self.detailsDataArray[indexPath.row];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey: model.commodityDetail];
    // 没有找到已下载的图片就使用默认的占位图，当然高度也是默认的高度了，除了高度不固定的文字部分。
    if (!image) {
        
        image = [UIImage imageNamed:@"small_placeholder"];

    }
    
    //手动计算cell
    CGFloat imgHeight = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
    model.cellHeight = imgHeight;
    DLog(@"图片高度详情=====%f" ,model.cellHeight);

    return imgHeight;
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return (426+55+150)*kScale;
    }
    return 15;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
            self.headView = [[HomePageDetailsHeadView alloc] initWithFrame:CGRectMake(0, 0, kWidth, (426+55+150)*kScale)];
            [self.headView setSDCycleScrollView:self.bannerDataArray];
        if (self.headDataArray.count!=0) {
            HomePageModel *model = self.headDataArray[section];
            [self.headView configHeadViewWithModel:model];
        }
       
            [self.headView.noticeBtn addTarget:self action:@selector(noticeBtnAvtion) forControlEvents:1];
            
            __weak __typeof(self) weakSelf = self;
            self.headView.changeGoodsDetailsBlock = ^{
                
                isClickGoods = YES;
                [weakSelf.tableView reloadData];
            };
            
            self.headView.changeCommentDetailsBlock = ^{
                
                isClickGoods = NO;
                [weakSelf.tableView reloadData];
            };
    
        
        self.headView.backgroundColor = [UIColor whiteColor];
        return self.headView;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 15)];
    view.backgroundColor = [UIColor redColor];
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
    if (isClickGoods == NO) {
        
        HomePageCommentDetailsTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"comment_cell"];
        if (cell1 == nil) {
            cell1 = [[HomePageCommentDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"comment_cell"];
            
            //[cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
            cell1.backgroundColor = [UIColor whiteColor];
           
        
        }
        [cell1 setGoodsStartArray:@[@"1" ,@"2" ,@"3"] sendStarArray:@[@"1" ,@"2" ,@"3"] andCommentDescImvArray:@[@"1" ,@"2" ,@"3"]];
        return cell1;
    }else
    {
    HomePageShoppingDetailsTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"shoppingDetails_cell"];
    if (cell1 == nil) {
        cell1 = [[HomePageShoppingDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shoppingDetails_cell"];
        
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
        cell1.backgroundColor = [UIColor orangeColor];
        
    }
    if (self.detailsDataArray.count!=0) {
        DLog(@"yyyyy== %@" ,self.detailsDataArray);
        HomePageModel *model = self.detailsDataArray[indexPath.row];
        [cell1 configCell:model forIndexPath:indexPath tableView:self.tableView];
    }
    
    return cell1;
    }
}

#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //隐藏tabBar
    
}



-(HomePageDetailsBottomView*)bottomView{
    if (!_bottomView) {
        _bottomView = [[HomePageDetailsBottomView alloc] initWithFrame:CGRectMake(0, kHeight-49-LL_TabbarSafeBottomMargin, kWidth, 49)];
        [_bottomView.cartBtn addTarget:self action:@selector(cartBtnAction) forControlEvents:1];
        [_bottomView.addCartBtn addTarget:self action:@selector(addCartBtnAction) forControlEvents:1];

    }
    return _bottomView;
}

#pragma mark =购物车

-(void)cartBtnAction{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([[user valueForKey:@"isLoginState"] isEqualToString:@"1"])
    {
        ShoppingCartViewController *VC = [ShoppingCartViewController new];
        VC.isShowTabBarBottomView = YES;
        [self.navigationController pushViewController:VC animated:YES];
      
    }else
    {
        LoginViewController *VC = [LoginViewController new];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        
  
    }
}

#pragma mark =加入购物车

-(void)addCartBtnAction{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([[user valueForKey:@"isLoginState"] isEqualToString:@"1"])
    {
        
        if (self.headDataArray.count != 0) {
            HomePageModel *model = self.headDataArray[0];
            //加入购物车
            [self addCartPostDataWithProductId:model.id];
        }
        
       
    }else
    {
        
        LoginViewController *VC = [LoginViewController new];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    
  
}



#pragma mark = 加入购物车数据

-(void)addCartPostDataWithProductId:(NSInteger)productId{
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
       //     SVProgressHUD.minimumDismissTimeInterval = 2;
//            SVProgressHUD.maximumDismissTimeInterval = 2;
//            [SVProgressHUD showSuccessWithStatus:returnData[@"msg"]];
            [SVProgressHUD dismiss];
            
            [GlobalHelper shareInstance].shoppingCartBadgeValue += 1;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shoppingCart" object:nil userInfo:nil];
            
            [self setButtonBadgeValue:self.bottomView.cartBtn badgeValue:[NSString stringWithFormat:@"%ld",[GlobalHelper shareInstance].shoppingCartBadgeValue ] badgeOriginX:MaxX(self.bottomView.cartBtn.imageView)-5 badgeOriginY:Y(self.bottomView.cartBtn.imageView)-12];
            
            [ShoppingCartTool addToShoppingCartWithGoodsImage:[UIImage imageNamed:@"dingdanxaingqingtu"] startPoint:CGPointMake(self.bottomView.addCartBtn.center.x, kHeight-50) endPoint:CGPointMake(self.bottomView.cartBtn.center.x, kHeight-50) completion:^(BOOL finished) {
                
                
            }];
        }
        else
        {
            SVProgressHUD.minimumDismissTimeInterval = 1;
            SVProgressHUD.maximumDismissTimeInterval = 3;
            [SVProgressHUD showErrorWithStatus:returnData[@"msg"]];
        }
        DLog(@"首页加入购物车== id=== %ld  %@" ,productId,returnData);
    } failureBlock:^(NSError *error) {
        
        DLog(@"首页加入购物车error ========== id= %ld  %@" ,productId,error);
        
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