//
//  ShoppingCartViewController.m
//  Emeat
//
//  Created by liuheshun on 2017/11/6.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "ShoppingCartModel.h"
#import "ShoppingCartTableViewCell.h"
#import "ShoppingCartBottomView.h"
#import "ConfirmOrderInfoViewController.h"
#import "YouLikeTableViewCell.h"
#import "YouLikeCollectionHeadView.h"
#import "ShoppingCartEmptyHeadView.h"
#import "ShoppingCartAddressHeadView.h"
#import "HomePageDetailsViewController.h"
#define  TAG_BACKGROUNDVIEW 100

#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width


@interface ShoppingCartViewController ()<UITableViewDelegate,UITableViewDataSource,delegateColl>
{
    UITableView *myTableView;
    //是否全选
    BOOL isSelect;
    //已选的商品集合
//    NSMutableArray *selectGoods;
    
}

///购物车数据源
@property (nonatomic,strong) NSMutableArray *ShoppingListDataMarray;


///猜你喜欢 商品数据源
@property (strong, nonatomic) NSMutableArray*guessLikeMarray;

///收货地址
//@property (nonatomic,strong) UIButton *selectShoppingAddressBtn;

///所选商品productId
@property (nonatomic,strong) NSMutableArray *productIdMarray;


@property (nonatomic,strong) ShoppingCartBottomView *bottomView;

///是否全选allChecked
@property (nonatomic,strong) NSString *allChecked;
///
@property (nonatomic,strong) NSString *cartTotalPrice;



@end

@implementation ShoppingCartViewController
-(void)viewWillAppear:(BOOL)animated
{
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    if (status == RealStatusNotReachable)
    {
        
    }else{
        
//        [self setupMainView];
        [self requestShoppingListData];
        [self requestBadNumValue];
        [self requestGuesslikeData];
      
    }
  
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;


}





- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    self.productIdMarray = [NSMutableArray array];
    self.guessLikeMarray = [NSMutableArray array];
    self.ShoppingListDataMarray = [NSMutableArray array];
    self.navItem.title = @"购物车";
    [self netWorkIsOnLine];
  
}


-(void)netWorkIsOnLine{
    
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    
    if (status == RealStatusNotReachable)
    {
        [[GlobalHelper shareInstance] showErrorIView:self.view errorImageString:@"wuwangluo" errorBtnString:@"重新加载" errorCGRect:CGRectMake(0, 0, kWidth, kHeight)];
        [[GlobalHelper shareInstance].errorLoadingBtn addTarget:self action:@selector(errorLoadingBtnAction) forControlEvents:1];
        
    }else{
        
        [self setupMainView];
        [self setupRefresh];
        [self requestGuesslikeData];

        [[GlobalHelper shareInstance] removeErrorView];
    }
}


#pragma mark = 重新加载

-(void)errorLoadingBtnAction{
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    
    if (status == RealStatusNotReachable){
        
    }else{
        [self setupMainView];
        [self setupRefresh];
        [self requestGuesslikeData];

        [[GlobalHelper shareInstance] removeErrorView];
    }
}






-(void)countPrices{
    self.bottomView.priceLabel.text = [NSString stringWithFormat:@"¥ %@" ,self.cartTotalPrice];

}

#pragma mark ==== 结算ZZ

-(void)goPayBtnClick{
    
//    if ([self.cartTotalPrice integerValue] == 0)
//    {
//        SVProgressHUD.minimumDismissTimeInterval = 0.5;
//        SVProgressHUD.maximumDismissTimeInterval = 1.5;
//        [SVProgressHUD showErrorWithStatus:@"未选中商品"];
//    }
//    else
//    {
        [SVProgressHUD show];
        [self getOrderInfoData];
  //  }
   
    
}


#pragma mark =====购物车数量
-(void)requestBadNumValue{
    
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
    
    
    [MHNetworkManager  postReqeustWithURL:[NSString stringWithFormat:@"%@/auth/cart/get_cart_product_count" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
        if ([returnData[@"status"] integerValue] == 200)
        {
            [GlobalHelper shareInstance].shoppingCartBadgeValue = [returnData[@"data"] integerValue];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shoppingCart" object:nil userInfo:nil];
        }
        
        DLog(@"购物车数量==  %@" ,returnData);
    } failureBlock:^(NSError *error) {
        
        DLog(@"购物车数量error==  %@" ,error);
        
    } showHUD:NO];
    
    
    
    
    
    
}

#pragma mark = =获取订单信息(去结算)

-(void)getOrderInfoData{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *ticket = [user valueForKey:@"ticket"];
    NSString *secret = @"UHnyKzP5sNmh2EV0Dflgl4VfzbaWc4crQ7JElfw1cuNCbcJUau";
    NSString *nonce = [self ret32bitString];//随机数
    NSString *curTime = [self dateTransformToTimeSp];
    NSString *checkSum = [self sha1:[NSString stringWithFormat:@"%@%@%@" ,secret ,  nonce ,curTime]];
    
    [dic setObject:secret forKey:@"secret"];
    [dic setObject:nonce forKey:@"nonce"];
    [dic setObject:curTime forKey:@"curTime"];
    [dic setObject:checkSum forKey:@"checkSum"];
    [dic setObject:ticket forKey:@"ticket"];
    DLog(@"获取订单信息 dic == %@" ,dic);
    NSMutableArray *orderListMarray = [NSMutableArray array];
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/auth/order/get_order_cart_product" , baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
        if ([returnData[@"status"] integerValue] == 200)
        {
            
        
        NSString *productTotalPrice = returnData[@"data"][@"productTotalPrice"];
        
        for (NSMutableDictionary *dic in returnData[@"data"][@"orderItemVoList"]) {
            
            ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
            model.productTotalPrice = productTotalPrice;
            [orderListMarray addObject:model];
        }
        
            [SVProgressHUD dismiss];
            ConfirmOrderInfoViewController *VC = [ConfirmOrderInfoViewController new];
            VC.hidesBottomBarWhenPushed = YES;
            VC.orderListMarray = orderListMarray;
            [self.navigationController pushViewController:VC animated:YES];
            NSLog(@"去结算");
            DLog(@"获取订单信息===msg=  %@   returnData == %@" ,returnData[@"msg"] , returnData);
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:returnData[@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"获取订单信息err0r=== %@  " ,error);
        
    } showHUD:NO];
    
    
}



#pragma mark = 选中商品结算

-(void)selectProductsPostDataCommodityId:(NSString*)commodityId{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *ticket = [user valueForKey:@"ticket"];
    NSString *secret = @"UHnyKzP5sNmh2EV0Dflgl4VfzbaWc4crQ7JElfw1cuNCbcJUau";
    NSString *nonce = [self ret32bitString];//随机数
    NSString *curTime = [self dateTransformToTimeSp];
    NSString *checkSum = [self sha1:[NSString stringWithFormat:@"%@%@%@" ,secret ,  nonce ,curTime]];
    
    [dic setObject:secret forKey:@"secret"];
    [dic setObject:nonce forKey:@"nonce"];
    [dic setObject:curTime forKey:@"curTime"];
    [dic setObject:checkSum forKey:@"checkSum"];
    [dic setObject:ticket forKey:@"ticket"];
    [dic setObject:commodityId forKey:@"commodityId"];

    ///商品
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/auth/cart/select" , baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        DLog(@"选中商品结算=== %@ " , returnData);
        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"])
        {
            [self.ShoppingListDataMarray removeAllObjects];
            self.cartTotalPrice =  [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"cartTotalPrice"]];
            //购物车选中总价
            self.allChecked = [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"allChecked"]] ;
            
            for (NSDictionary *dic in returnData[@"data"][@"cartProductVoList"])
            {
                
                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.cartTotalPrice = self.cartTotalPrice ;
                [self.ShoppingListDataMarray addObject:model];
            }
            
            [self countPrices];
            [myTableView reloadData];
            
        }else{
            // [self alertMessage:returnData[@"msg"] willDo:nil];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"选中商品结算error=== %@   " ,error);
        
    } showHUD:NO];
    
    
    
    
    
}

#pragma mark = 取消选中商品结算

-(void)cancelProductsPostDataCommodityId:(NSString*)commodityId{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *ticket = [user valueForKey:@"ticket"];
    NSString *secret = @"UHnyKzP5sNmh2EV0Dflgl4VfzbaWc4crQ7JElfw1cuNCbcJUau";
    NSString *nonce = [self ret32bitString];//随机数
    NSString *curTime = [self dateTransformToTimeSp];
    NSString *checkSum = [self sha1:[NSString stringWithFormat:@"%@%@%@" ,secret ,  nonce ,curTime]];
    
    [dic setObject:secret forKey:@"secret"];
    [dic setObject:nonce forKey:@"nonce"];
    [dic setObject:curTime forKey:@"curTime"];
    [dic setObject:checkSum forKey:@"checkSum"];
    [dic setObject:ticket forKey:@"ticket"];
    [dic setObject:commodityId forKey:@"commodityId"];
    
   
    //[dic setObject:productIds forKey:@"productIds"];

    ///商品
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/auth/cart/un_select" , baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        DLog(@"取消选中商品结算=== %@   %@" ,returnData[@"msg"] , returnData);
//        if ([returnData[@"status"] integerValue] == 200) {
//            self.allChecked = [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"allChecked"]] ;
//            self.cartTotalPrice =  [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"cartTotalPrice"]]  ;
//
//            [self countPrices];
//
//
//        }
//        [myTableView reloadData];
        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"])
        {
            [self.ShoppingListDataMarray removeAllObjects];
            self.cartTotalPrice =  [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"cartTotalPrice"]];
            //购物车选中总价
            self.allChecked = [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"allChecked"]] ;
            
            for (NSDictionary *dic in returnData[@"data"][@"cartProductVoList"])
            {
                
                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.cartTotalPrice = self.cartTotalPrice ;
                [self.ShoppingListDataMarray addObject:model];
            }
            
            [self countPrices];
            [myTableView reloadData];
            
        }else{
            // [self alertMessage:returnData[@"msg"] willDo:nil];
        }
        
        
        
        
        
        
        
    } failureBlock:^(NSError *error) {
        DLog(@"取消选中商品结算error=== %@   " ,error);
        
    } showHUD:NO];
    
    
    
    
    
}


#pragma mark = 全部取消选中商品结算

-(void)cancelAllProductsPostData{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *ticket = [user valueForKey:@"ticket"];
    NSString *secret = @"UHnyKzP5sNmh2EV0Dflgl4VfzbaWc4crQ7JElfw1cuNCbcJUau";
    NSString *nonce = [self ret32bitString];//随机数
    NSString *curTime = [self dateTransformToTimeSp];
    NSString *checkSum = [self sha1:[NSString stringWithFormat:@"%@%@%@" ,secret ,  nonce ,curTime]];
    
    [dic setObject:secret forKey:@"secret"];
    [dic setObject:nonce forKey:@"nonce"];
    [dic setObject:curTime forKey:@"curTime"];
    [dic setObject:checkSum forKey:@"checkSum"];
    [dic setObject:ticket forKey:@"ticket"];
    
    
    //[dic setObject:productIds forKey:@"productIds"];
    
    ///商品
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/auth/cart/un_select_all" , baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        DLog(@"全部取消选中商品结算=== %@   %@" ,returnData[@"msg"] , returnData);
        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"])
        {
            [self.ShoppingListDataMarray removeAllObjects];
            self.cartTotalPrice =  [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"cartTotalPrice"]];
            //购物车选中总价
            self.allChecked = [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"allChecked"]] ;
            
            for (NSDictionary *dic in returnData[@"data"][@"cartProductVoList"])
            {
                
                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.cartTotalPrice = self.cartTotalPrice ;
                [self.ShoppingListDataMarray addObject:model];
            }
            
            [self countPrices];
            [myTableView reloadData];
            
        }else{
            // [self alertMessage:returnData[@"msg"] willDo:nil];
        }

    } failureBlock:^(NSError *error) {
        DLog(@"全部取消选中商品结算error=== %@   " ,error);
        
    } showHUD:NO];
    
    
    
    
    
}
#pragma mark = 全部选中商品结算

-(void)selectAllProductsPostData{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *ticket = [user valueForKey:@"ticket"];
    NSString *secret = @"UHnyKzP5sNmh2EV0Dflgl4VfzbaWc4crQ7JElfw1cuNCbcJUau";
    NSString *nonce = [self ret32bitString];//随机数
    NSString *curTime = [self dateTransformToTimeSp];
    NSString *checkSum = [self sha1:[NSString stringWithFormat:@"%@%@%@" ,secret ,  nonce ,curTime]];
    
    [dic setObject:secret forKey:@"secret"];
    [dic setObject:nonce forKey:@"nonce"];
    [dic setObject:curTime forKey:@"curTime"];
    [dic setObject:checkSum forKey:@"checkSum"];
    [dic setObject:ticket forKey:@"ticket"];
    
    ///商品
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/auth/cart/select_all" , baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        DLog(@"全部选中商品结算=== %@   %@" ,returnData[@"msg"] , returnData);
        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"])
        {
            [self.ShoppingListDataMarray removeAllObjects];
            self.cartTotalPrice =  [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"cartTotalPrice"]];
            //购物车选中总价
            self.allChecked = [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"allChecked"]] ;
            
            for (NSDictionary *dic in returnData[@"data"][@"cartProductVoList"])
            {
                
                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.cartTotalPrice = self.cartTotalPrice ;
                [self.ShoppingListDataMarray addObject:model];
            }
            
            [self countPrices];
            [myTableView reloadData];
            
        }else{
            // [self alertMessage:returnData[@"msg"] willDo:nil];
        }

    } failureBlock:^(NSError *error) {
        DLog(@"全部选中商品结算error=== %@   " ,error);
        
    } showHUD:NO];
    
    
    
    
    
}
- (void)setupRefresh{
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    myTableView.mj_header  = header;
    header.lastUpdatedTimeLabel.hidden = YES;
    [myTableView.mj_header beginRefreshing];
}


- (void)headerRereshing{
    
    [self requestShoppingListData];
    [myTableView.mj_header endRefreshing];
    [myTableView.mj_footer endRefreshing];
    
}




#pragma mark ===== 购物车列表数据接口


-(void)requestShoppingListData{
 
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *ticket = [user valueForKey:@"ticket"];
    NSString *secret = @"UHnyKzP5sNmh2EV0Dflgl4VfzbaWc4crQ7JElfw1cuNCbcJUau";
    NSString *nonce = [self ret32bitString];//随机数
    NSString *curTime = [self dateTransformToTimeSp];
    NSString *checkSum = [self sha1:[NSString stringWithFormat:@"%@%@%@" ,secret ,  nonce ,curTime]];
    [dic setObject:secret forKey:@"secret"];
    [dic setObject:nonce forKey:@"nonce"];
    [dic setObject:curTime forKey:@"curTime"];
    [dic setObject:checkSum forKey:@"checkSum"];
    [dic setValue:ticket forKey:@"ticket"];
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/auth/cart/list" , baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        [self.ShoppingListDataMarray removeAllObjects];

        DLog(@"购物车列表数据接口======= %@  %@" , returnData[@"msg"], returnData );
         ////下面判断可删除
        if ([returnData[@"code"]isEqualToString:@"0404"]) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:@"0" forKey:@"isLoginState"];
        }
        
        
        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"])
        {
            self.cartTotalPrice =  [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"cartTotalPrice"]];
//购物车选中总价
            self.allChecked = [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"allChecked"]] ;

            for (NSDictionary *dic in returnData[@"data"][@"cartProductVoList"])
            {
                
                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.cartTotalPrice = self.cartTotalPrice ;
                [self.ShoppingListDataMarray addObject:model];
            }
            
            [self countPrices];
            [myTableView reloadData];
            
        }else{
           // [self alertMessage:returnData[@"msg"] willDo:nil];
        }
        
    } failureBlock:^(NSError *error) {
        DLog(@"购物车列表error=== %@" , error);

        
    } showHUD:NO];
    
  
    
}


#pragma mark = 猜你喜欢

-(void)requestGuesslikeData{
    
    NSString *dataUTF8 = [[NSString stringWithFormat:@"%@/mobile/guess/guesslike?promotionId=1" ,baseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [MHNetworkManager getRequstWithURL:dataUTF8 params:nil successBlock:^(NSDictionary *returnData) {
        DLog(@"猜你喜欢 === %@" ,returnData);
        
        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"]) {
            [self.guessLikeMarray  removeAllObjects];

            for (NSDictionary *dic in returnData[@"data"][@"commodity"]) {
                HomePageModel *bannerModel = [HomePageModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[bannerModel.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    bannerModel.mainImage = [mainImvMarray firstObject];
                }
                [self.guessLikeMarray addObject:bannerModel];
            }
            [myTableView reloadData];
        }
        
        
        
    } failureBlock:^(NSError *error) {
        DLog(@"猜你喜欢error === %@" ,error);

    } showHUD:NO];
    
}




#pragma mark = 加入购物车数据(猜你喜欢)

-(void)addCartPostDataWithProductId:(NSInteger)productId{
    //  ：http://192.168.0.124:8085/cart/add?userId=7&productId=112&quatity=100
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
    
    
    [dic setObject:[NSString stringWithFormat:@"%ld" ,productId] forKey:@"commodityId"];
    [dic setObject:@"1" forKey:@"quatity"];
    
    DLog(@"猜你喜欢====dic====%@   %ld" ,dic ,productId);
    
    [MHNetworkManager  postReqeustWithURL:[NSString stringWithFormat:@"%@/auth/cart/add",baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
        if ([returnData[@"status"] integerValue] == 200)
        {
            SVProgressHUD.maximumDismissTimeInterval = 2;
            SVProgressHUD.backgroundColor = RGB(238, 238, 238, 1);
            [SVProgressHUD showSuccessWithStatus:@"下拉刷新购物车看看哟~"];
//            [GlobalHelper shareInstance].shoppingCartBadgeValue += 1;
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"shoppingCart" object:nil userInfo:nil];

        }
        else
        {
            SVProgressHUD.maximumDismissTimeInterval = 1;
            [SVProgressHUD showErrorWithStatus:returnData[@"msg"]];
        }
        DLog(@"猜你喜欢加入购物车==  %@" ,returnData);
    } failureBlock:^(NSError *error) {
        
        DLog(@"猜你喜欢加入购物车error==  %@" ,error);
        
    } showHUD:NO];
    
}


#pragma mark = 加入购物车商品数量为0时 删除整个商品

-(void)deleteProductPostDataWithProductId:(NSInteger)productId ShoppingCartModel:(ShoppingCartModel*)model{
    
    [self.ShoppingListDataMarray removeAllObjects];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *ticket = [user valueForKey:@"ticket"];
    NSString *secret = @"UHnyKzP5sNmh2EV0Dflgl4VfzbaWc4crQ7JElfw1cuNCbcJUau";
    NSString *nonce = [self ret32bitString];//随机数
    NSString *curTime = [self dateTransformToTimeSp];
    NSString *checkSum = [self sha1:[NSString stringWithFormat:@"%@%@%@" ,secret ,  nonce ,curTime]];
    
    [dic setObject:secret forKey:@"secret"];
    [dic setObject:nonce forKey:@"nonce"];
    [dic setObject:curTime forKey:@"curTime"];
    [dic setObject:checkSum forKey:@"checkSum"];
    [dic setObject:ticket forKey:@"ticket"];
//    [dic setObject:@"7" forKey:@"userId"];
    [dic setObject:[NSString stringWithFormat:@"%ld",productId] forKey:@"commodityIds"];
    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/auth/cart/delete_product", baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
        DLog(@"删除 == %@" , returnData);
        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"])
        {
            self.cartTotalPrice =  [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"cartTotalPrice"]];
            //购物车选中总价
            self.allChecked = [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"allChecked"]] ;
            
            for (NSDictionary *dic in returnData[@"data"][@"cartProductVoList"])
            {
                
                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.cartTotalPrice = self.cartTotalPrice ;
                [self.ShoppingListDataMarray addObject:model];
            }
            if (self.ShoppingListDataMarray.count == 0) {
                ///底部是否全选
                self.bottomView.selectAll.selected = NO;
            }
            [self countPrices];
            [self requestBadNumValue];
            [myTableView reloadData];
            
        }else{
            // [self alertMessage:returnData[@"msg"] willDo:nil];
        }
 
    } failureBlock:^(NSError *error) {
        DLog(@"删除error == %@" , error);
        
        
    } showHUD:NO];
}




#pragma mark = 购物车 加 减 更新数据接口 ( 添加 减去相同的update接口 ,删除这个商品的时候调用delete的接口)

-(void)cutCartPostDataWithProductId:(NSInteger)productId quatity:(NSInteger)quatity CartStyle:(NSString*)cartStyle shoppingTableViewCell:(ShoppingCartTableViewCell*)weakCell ShoppingCartModel:(ShoppingCartModel*)model NSIndexPath:(NSIndexPath*)indexPath
{
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
    [dic setValue:[NSString stringWithFormat:@"%ld" , productId] forKey:@"commodityId"];
    [dic setValue:[NSString stringWithFormat:@"%ld" ,quatity] forKey:@"quatity"];
    
    [MHNetworkManager  postReqeustWithURL:[NSString stringWithFormat:@"%@/auth/cart/update" , baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
        DLog(@"购物车加减购物车===%@" ,returnData);
        
        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"])
        {
            [self.ShoppingListDataMarray removeAllObjects];

            self.cartTotalPrice =  [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"cartTotalPrice"]];
            //购物车选中总价
            self.allChecked = [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"allChecked"]] ;
            
            for (NSDictionary *dic in returnData[@"data"][@"cartProductVoList"])
            {
                
                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.cartTotalPrice = self.cartTotalPrice ;
                [self.ShoppingListDataMarray addObject:model];
            }
            
            [self countPrices];
            [self requestBadNumValue];
            [myTableView reloadData];
            
        }else{
            SVProgressHUD.minimumDismissTimeInterval = 1;
            [SVProgressHUD showErrorWithStatus:returnData[@"msg"]];
        }
 
    } failureBlock:^(NSError *error) {
        
        DLog(@"加减去购物车error==  %@" ,error);
        
    } showHUD:NO];
    
    
    
    
}

#pragma mark ========全选按钮点击事件

-(void)selectAllBtnClick:(UIButton*)button
{
    if (self.ShoppingListDataMarray.count != 0) {
        button.selected = !button.selected;
        isSelect = button.selected;
        if (isSelect)
        {
            [self selectAllProductsPostData];
            
            
        }
        else
        {
            [self cancelAllProductsPostData];
            
        }
        
       // [myTableView reloadData];
    }
  
}





#pragma mark - 设置底部视图
-(void)setupBottomView
{
    CGFloat yHeight = kHeight - 44-kBottomBarHeight;
    if (self.isShowTabBarBottomView == YES)
    {
        yHeight = kHeight - 44 -LL_TabbarSafeBottomMargin;
    }
    self.bottomView= [[ShoppingCartBottomView alloc] initWithFrame:CGRectMake(0, yHeight, kWidth, 44)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    [self.bottomView.selectAll addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.PayBtn addTarget:self action:@selector(goPayBtnClick) forControlEvents:UIControlEventTouchUpInside];

    
}

#pragma mark - 设置主视图
-(void)setupMainView
{
    
    UIView *vi = [self.view viewWithTag:TAG_BACKGROUNDVIEW];
    [vi removeFromSuperview];
    CGFloat tbHeight = kHeight - 44 -kBarHeight-kBottomBarHeight;
    if (self.isShowTabBarBottomView == YES) {
        tbHeight = kHeight - 44 -kBarHeight;
    }
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kBarHeight, kWidth, tbHeight) style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.rowHeight = 90*kScale;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor = RGB(238, 238, 238, 1);
    [self.view addSubview:myTableView];
    [self setupBottomView];
 
}

#pragma mark - tableView 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.ShoppingListDataMarray.count;
        
    }
        return 1;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 90*kScale;
    }
    return  [self GetCellHeight:self.guessLikeMarray.count]*200*kScale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.ShoppingListDataMarray.count == 0) {
            return 185;
        }
        return 35*kScale;

    }else{
        if (self.guessLikeMarray.count == 0) {
            return 0.01;
        }
        return 65*kScale;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.ShoppingListDataMarray.count == 0) {
            
            ShoppingCartEmptyHeadView *emptyHeadView = [[ShoppingCartEmptyHeadView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 185)];
            emptyHeadView.backgroundColor = RGB(238, 238, 238, 1);
            return emptyHeadView;
        }else{
            ShoppingCartAddressHeadView *addressView = [[ShoppingCartAddressHeadView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 35)];
            [addressView.addressBtn setTitle:[GlobalHelper shareInstance].selectAddressString forState:0];
            addressView.backgroundColor = RGB(238, 238, 238, 1);
            return addressView;
        }

    }else{
        if (self.guessLikeMarray.count == 0) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.01)];
            view.backgroundColor = RGB(238, 238, 238, 1);
            return view;
        }
        else
        {
        YouLikeCollectionHeadView *headview = [[YouLikeCollectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 55*kScale)];
        headview.titleLab.text = @"猜你喜欢";
        headview.backgroundColor = [UIColor whiteColor];
        return headview;
        }
    }
   
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        if (self.ShoppingListDataMarray.count == 0) {
            return 0.01;
        }
        return 15*kScale;
    }else{
       
        if (self.guessLikeMarray.count == 0) {
            return 0.01;
        }
        return 15*kScale;

    }
   
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 20)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
    ShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID_shop"];
    if (!cell) {
        cell = [[ShoppingCartTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID_shop"];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
        cell.isSelected = isSelect;
        cell.selectBtn.tag = indexPath.row;
  
    //选择回调
    cell.cartBlock = ^(BOOL isSelec){
        if (isSelec) {
#pragma mark ========选中购物车商品
            ShoppingCartModel *cartModel = self.ShoppingListDataMarray[indexPath.row];
            [self selectProductsPostDataCommodityId:[NSString stringWithFormat:@"%ld" , cartModel.commodityId]];
        }
        else
        {
#pragma mark ========取消选中购物车商品

            ShoppingCartModel *cartModel = self.ShoppingListDataMarray[indexPath.row];
            
            [self cancelProductsPostDataCommodityId:[NSString stringWithFormat:@"%ld" , cartModel.commodityId]];

        }
        

        };
        
        
        __block ShoppingCartTableViewCell *weakCell = cell;
        __weak __typeof(self) weakSelf = self;
        if (self.ShoppingListDataMarray.count != 0) {
             ShoppingCartModel *model = self.ShoppingListDataMarray[indexPath.row];
        ///加入购物车
        cell.numAddBlock =^(){
       
            [weakSelf cutCartPostDataWithProductId:model.commodityId quatity:1 CartStyle:@"1" shoppingTableViewCell:weakCell ShoppingCartModel:model NSIndexPath:indexPath];
            };
    
        
    
        cell.numCutBlock =^(){
            NSInteger count = [weakCell.numberLabel.text integerValue];
            if (count>1)
            {
                [self cutCartPostDataWithProductId:model.commodityId quatity:-1 CartStyle:@"0" shoppingTableViewCell:weakCell ShoppingCartModel:model NSIndexPath:indexPath];
            }
            else
            {
            
               
               
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该商品?删除后无法恢复!" preferredStyle:1];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    ///删除整个商品
                    
                    [self deleteProductPostDataWithProductId:model.commodityId ShoppingCartModel:model];
                    
                    
                }];
                
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                
                [alert addAction:okAction];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
               
        }
       
      
    };
        
        ///底部是否全选
        if ([self.allChecked isEqualToString:@"1"]) {
            self.bottomView.selectAll.selected = YES;

        }else if ([self.allChecked isEqualToString:@"0"])
        {
            self.bottomView.selectAll.selected = NO;

        }
        ///商品cell赋值
        if (self.ShoppingListDataMarray.count!=0) {
            [cell reloadDataWith:[self.ShoppingListDataMarray objectAtIndex:indexPath.row]];
        }
            
        }
    return cell;
        
        
    }else{
        
        YouLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID_like"];
        if (cell == nil) {
            cell = [[YouLikeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID_like"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        //获取到数据后刷新
        if (self.guessLikeMarray.count != 0) {
            cell.HomeArray = self.guessLikeMarray;
            [cell.CollView reloadData];
            cell.CollView.backgroundColor = [UIColor whiteColor];
            //防止出现collerview滚动
            cell.CollView.scrollEnabled = NO;
            cell.delegateColl = self;
            
            [cell setCollViewHeight:[self GetCellHeight:self.guessLikeMarray.count]*200];
            [cell configHeight:[self GetCellHeight:self.guessLikeMarray.count]*200];
            
            
        }
       
#pragma mark = 猜你喜欢 加入购物车

        [cell setClickIndexBlock:^(NSInteger index) {
            
            DLog(@"猜你喜欢点击下标=== %ld" ,index);
            if (self.guessLikeMarray.count != 0)
                {
                    HomePageModel *model = [self.guessLikeMarray objectAtIndex:index];
                    [self addCartPostDataWithProductId:model.id];
                    [myTableView reloadData];
                }
          
            
         
        }];
        
        
        
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.ShoppingListDataMarray.count != 0) {
         HomePageDetailsViewController *VC = [HomePageDetailsViewController new];
        
        ShoppingCartModel *model = self.ShoppingListDataMarray[indexPath.row];
        VC.detailsId = [NSString stringWithFormat:@"%ld" ,(long)model.commodityId];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }
   
    
    
}

#pragma mark - 代理用来接收点击的是第几个
-(void)ClickCooRow :(NSInteger)CellRow
{
    NSLog(@"猜你喜欢=== %ld" ,CellRow);
    
    HomePageDetailsViewController *VC = [HomePageDetailsViewController new];
    VC.hidesBottomBarWhenPushed = YES;
    HomePageModel *model = self.guessLikeMarray[CellRow];
    VC.detailsId = [NSString stringWithFormat:@"%ld" ,model.id];
    [self.navigationController pushViewController:VC animated:YES];
    
    
}



//根据 猜你喜欢 数组的长度动态设置cell的高度
-(float) GetCellHeight :(float) ListCount
{
    float cellH = round(ListCount / 2);
    cellH = ceilf(ListCount / 2);
    return cellH;//collectionView 多少行
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if (indexPath.section == 0) {
        return YES;
    }
    else
    {
        return NO;
    }
    
}




/**
 *  左滑cell时出现什么按钮
 */
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"取消" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        // 收回左滑出现的按钮(退出编辑模式)
        tableView.editing = NO;
    }];
    
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该商品?删除后无法恢复!" preferredStyle:1];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ShoppingCartModel *model = self.ShoppingListDataMarray[indexPath.row];
            
            [self deleteProductPostDataWithProductId:model.commodityId ShoppingCartModel:model];
            
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okAction];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    
        
        
        
    }];
    
    return @[action1, action0];
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {

    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
     
        
   }
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
