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
#import "ActionSheetView.h"
#import "ShareImageViewController.h"
@interface HomePageDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
//轮播图
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) HomePageDetailsHeadView *headView;
@property (nonatomic,strong) HomePageDetailsBottomView *bottomView;
@property (nonatomic,strong) HomePageDetailsBuyNoticeView *buyNoticeView;

///轮播图数据源
@property (nonatomic,strong) NSMutableArray *bannerDataArray;
///详情图片数据源
@property (nonatomic,strong) NSMutableArray *detailsDataArray;

///商品详情
@property (nonatomic,strong) NSMutableArray *headDataArray;

///多规格
@property (nonatomic,strong) NSMutableArray *specsListMarray;
///头部高度
@property (nonatomic,assign) CGFloat headViewHeiht;


@end

@implementation HomePageDetailsViewController
{
    BOOL isClickGoods;
}


-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [GlobalHelper shareInstance].isLoginState = [user valueForKey:@"isLoginState"];
    self.navigationController.navigationBarHidden = YES;
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者
    [center addObserver:self selector:@selector(InfoNotificationAction:) name:@"refreshHomePageDetailsControllerWithNotification" object:nil];
    
}
-(void)InfoNotificationAction:(NSNotification*)notification{
    DLog(@"use == %@" , notification.userInfo)
    self.detailsId =  notification.userInfo[@"detailsId"];
    [self requsetDetailsData];
    [self requestBadNumValue];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshHomePageDetailsControllerWithNotification" object:nil];
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
//    self.bannerDataArray = [NSMutableArray array];
//    self.detailsDataArray = [NSMutableArray array];
//    self.headDataArray = [NSMutableArray array];
//    self.specsListMarray = [NSMutableArray array];
    [self requsetDetailsData];
    [self showNavBarLeftItem ];
  
}


-(void)showNavBarLeftItem{
    
    self.leftButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(leftItemAction)];
    [self.navBar pushNavigationItem:self.navItem animated:NO];
    [self.navItem setLeftBarButtonItem:self.leftButton];
    
    
}


-(void)leftItemAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark = 商品详情数据

-(void)requsetDetailsData{
    [SVProgressHUD show];
    self.bannerDataArray = [NSMutableArray array];
    self.detailsDataArray = [NSMutableArray array];
    self.headDataArray = [NSMutableArray array];
    self.specsListMarray = [NSMutableArray array];
    NSString *str;
    if ([self.fromBaner isEqualToString:@"1"]) {////来自banner
        str = [NSString stringWithFormat:@"%@/m/mobile/commodity/commodityDeatilByCode?commodityCode=%@&mtype=%@" ,baseUrl ,self.detailsId,mTypeIOS];
    }
    else ///来自商品列表
    {
        str = [NSString stringWithFormat:@"%@/m/mobile/commodity/commodityDeatil?id=%@&mtype=%@" , baseUrl ,self.detailsId,mTypeIOS];
    }
    
    DLog(@"详情接口==== %@" ,str);
    
    [MHNetworkManager getRequstWithURL:str params:nil successBlock:^(NSDictionary *returnData) {
        DLog(@"详情返回结果=== %@" ,returnData);
            if ([[returnData[@"status"] stringValue] isEqualToString:@"200"]) {
                
                HomePageModel *bannerModel = [HomePageModel yy_modelWithJSON:returnData[@"data"]];
                [GlobalHelper shareInstance].homePageDetailsId = [NSString stringWithFormat:@"%ld" ,bannerModel.id];

                CGSize r = [bannerModel.commodityDesc boundingRectWithSize:CGSizeMake(kWidth-30*kScale, 1000*kScale) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0f*kScale]} context:nil].size;
                self.headViewHeiht = (650)*kScale +r.height;
                if (bannerModel) {
                    [self.headDataArray addObject:bannerModel];
                    self.bannerDataArray = [NSMutableArray arrayWithArray:[bannerModel.commodityBanner componentsSeparatedByString:@","]];
                    
                    NSMutableArray *imvMarray = [NSMutableArray arrayWithArray:[bannerModel.commodityDetail componentsSeparatedByString:@","]];
                    
                    for (NSString *imvString in imvMarray) {
                        HomePageModel *detailsModel = [HomePageModel new];
                        detailsModel.commodityDetail = imvString;
                        [self.detailsDataArray addObject:detailsModel];
                    }
                    
                    
                    
                    self.productTitle = bannerModel.commodityName;
                    self.productContent = bannerModel.commodityDesc;
                    self.productImageURL = [self.bannerDataArray firstObject];
                    self.productPrices = [NSString stringWithFormat:@"%ld" ,bannerModel.unitPrice];
                    self.priceTypes = bannerModel.priceTypes;
                    
                    
                    
                    for (NSDictionary *specsListDic in returnData[@"data"][@"specsList"]) {
                        HomePageModel *specsListModel = [HomePageModel yy_modelWithJSON:specsListDic];
                        [self.specsListMarray addObject:specsListModel];
                    }
                    [GlobalHelper shareInstance].specsListMarray = self.specsListMarray;
                    [self.view addSubview:self.tableView];
                    [self.view addSubview:self.bottomView];
                    [self setBottomViewFrame];
                    
                    [self setButtonBadgeValue:self.bottomView.cartBtn badgeValue:[NSString stringWithFormat:@"%ld",(long)[GlobalHelper shareInstance].shoppingCartBadgeValue ] badgeOriginX:MaxX(self.bottomView.cartBtn.imageView)-5 badgeOriginY:Y(self.bottomView.cartBtn.imageView)-12];
                    
                    [self.tableView reloadData];
                }
              
            }else{
                [self alertMessage:returnData[@"msg"] willDo:nil];
            }            
        [SVProgressHUD dismiss];

        } failureBlock:^(NSError *error) {
            
            [SVProgressHUD dismiss];

        } showHUD:NO];
    [SVProgressHUD show];


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

#pragma mark=====================链接分享============================

-(void)linkingOfShare{
    
  
    NSArray *titlearr = @[@"",@"微信好友",@"微信朋友圈",@""];
    NSArray *imageArr = @[@"",@"微信",@"朋友圈",@""];
    ActionSheetView *actionsheet  = [[ActionSheetView alloc] initWithShareHeadOprationWith:titlearr andImageArry:imageArr andProTitle:@"分享至" and:ShowTypeIsShareStyle];
    actionsheet.otherBtnFont = 14.0f;
    actionsheet.otherBtnColor = RGB(51, 51, 51, 1);
    actionsheet.cancelBtnFont = 14.0f;
    actionsheet.cancelBtnColor = RGB(51, 51, 51, 1);
    
    [actionsheet setBtnClick:^(NSInteger btnTag) {
        
        
        if (btnTag ==0) {
        }else if (btnTag ==1){
            //分享到聊天
            [self wxchatWebShare:WXSceneSession];
        }else if (btnTag ==2){
            //分享到朋友圈
            [self wxchatWebShare:WXSceneTimeline];
        }else if (btnTag == 3){
        }
        
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:actionsheet];
}

- (UIImage *)handleImageWithURLStr:(NSString *)imageURLStr {
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLStr]];
    NSData *newImageData = imageData;
    // 压缩图片data大小
    newImageData = UIImageJPEGRepresentation([UIImage imageWithData:newImageData scale:0.1], 0.1f);
    UIImage *image = [UIImage imageWithData:newImageData];
    
    // 压缩图片分辨率(因为data压缩到一定程度后，如果图片分辨率不缩小的话还是不行)
    CGSize newSize = CGSizeMake(200, 200);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,(NSInteger)newSize.width, (NSInteger)newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


-(void)wxchatWebShare:(int)scene{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.productTitle;
    message.description = self.productContent;
    
    [message setThumbImage:[self handleImageWithURLStr:self.productImageURL]];
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = [NSString stringWithFormat:@"%@/breaf/beef_detail.html?ds=%@" ,baseUrl,self.detailsId];
    message.mediaObject = webpageObject;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];
    
}



-(void)shareRightItemAction{
    DLog(@"分享");
    NSArray *titlearr = @[@"",@"链接",@"图片",@""];
    NSArray *imageArr = @[@"",@"链接",@"图片",@""];
    ActionSheetView *actionsheet  = [[ActionSheetView alloc] initWithShareHeadOprationWith:titlearr andImageArry:imageArr andProTitle:@"分享" and:ShowTypeIsShareStyle];
    actionsheet.otherBtnFont = 14.0f;
    actionsheet.otherBtnColor = RGB(51, 51, 51, 1);
    actionsheet.cancelBtnFont = 14.0f;
    actionsheet.cancelBtnColor = RGB(51, 51, 51, 1);
    [actionsheet setBtnClick:^(NSInteger btnTag) {
        
        if (btnTag ==0) {
            
        }else if (btnTag ==1){
            
            [self linkingOfShare];//链接分享
            
        }else if (btnTag ==2){//图片分享
            
            ShareImageViewController *VC = [ShareImageViewController new];
            VC.productTitle = self.productTitle;
            VC.productContent = self.productContent;
            VC.productImageURL = self.productImageURL;
            VC.detailsId = self.detailsId;
            VC.productPrices = self.productPrices;
            VC.priceTypes = self.priceTypes;
            [self.navigationController pushViewController:VC animated:YES];
            
        }else if (btnTag ==3){
            
        }
        
        
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:actionsheet];
}


-(void)showNavBarItemRight{
    
    UIBarButtonItem *connectRightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"kefu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(connectRightItemAction)];
    UIBarButtonItem *shareRightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fenxiang"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(shareRightItemAction)];
    
    
    [self.navBar pushNavigationItem:self.navItem animated:NO];
    [self.navItem setRightBarButtonItems:[NSArray arrayWithObjects:shareRightItem ,connectRightItem, nil]];
   // [self.navItem setRightBarButtonItems:[NSArray arrayWithObjects: connectRightItem, nil]];

    
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

    return imgHeight;
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {

        return self.headViewHeiht;
    }
    return 15;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
            self.headView = [[HomePageDetailsHeadView alloc] initWithFrame:CGRectMake(0, 0, kWidth, self.headViewHeiht)];
//            [self.headView setSDCycleScrollView:self.bannerDataArray];
        
        
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kWidth, 300*kScale) delegate:self placeholderImage:[UIImage imageNamed:@"商品主图加载"]];   //placeholder
        cycleScrollView.imageURLStringsGroup = self.bannerDataArray;
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        cycleScrollView.showPageControl = YES;//是否显示分页控件
        cycleScrollView.currentPageDotColor = [UIColor orangeColor]; // 自定义分页控件小圆标颜色
        [self.headView addSubview:cycleScrollView];
        self.cycleScrollView = cycleScrollView;
        
        
        
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
        

        self.headView.returnSelectIndex = ^(NSInteger selectIndex) {
            HomePageModel *model = [GlobalHelper shareInstance].specsListMarray[selectIndex];
            weakSelf.detailsId = [NSString stringWithFormat:@"%ld" ,(long)model.commodityId] ;
            weakSelf.fromBaner = @"0"; ///此处不能传sp的ID
            [weakSelf requsetDetailsData];

        };
        self.headView.backgroundColor = [UIColor whiteColor];
        return self.headView;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 15)];
    view.backgroundColor = [UIColor whiteColor];
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
        cell1.backgroundColor = [UIColor whiteColor];
        
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

#pragma mark = 底部视图

-(HomePageDetailsBottomView*)bottomView{
    if (!_bottomView) {
        _bottomView = [[HomePageDetailsBottomView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_bottomView.cartBtn addTarget:self action:@selector(cartBtnAction) forControlEvents:1];
        [_bottomView.addCartBtn addTarget:self action:@selector(addCartBtnAction) forControlEvents:1];
    }
    return _bottomView;
}

#pragma makr = 底部视图frame

-(void)setBottomViewFrame{
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@49);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-LL_TabbarSafeBottomMargin);
        
    }];
}


#pragma mark =购物车

-(void)cartBtnAction{
    
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    if (status == RealStatusNotReachable)
    {
        SVProgressHUD.minimumDismissTimeInterval = 2.0f;
        [SVProgressHUD showErrorWithStatus:@"好像断网了,请检查网络"];
        
    }else{
    
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
    [dic setValue:mTypeIOS forKey:@"mtype"];

    DLog(@"加入购物车 ==== %@" , dic);
    [MHNetworkManager  postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/cart/add",baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
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
