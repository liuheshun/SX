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

/////购物车数据源
//@property (nonatomic,strong) NSMutableArray *ShoppingListDataMarray;
///小包装商品
@property (nonatomic,strong) NSMutableArray *xsmallListMarray;
///原箱商品
@property (nonatomic,strong) NSMutableArray *yoriginalListMarray;
///试样商品
@property (nonatomic,strong) NSMutableArray *ssampleListMarray;
///失效商品
@property (nonatomic,strong) NSMutableArray *sloseListMarray;

//@property (nonatomic,strong) NSMutableArray *ShoppingListDataMarray;



///猜你喜欢 商品数据源
@property (strong, nonatomic) NSMutableArray*guessLikeMarray;

///收货地址
//@property (nonatomic,strong) UIButton *selectShoppingAddressBtn;

///所选商品productId
@property (nonatomic,strong) NSMutableArray *productIdMarray;


@property (nonatomic,strong) ShoppingCartBottomView *bottomView;

///是否全选allChecked
@property (nonatomic,strong) NSString *allChecked;
///购物车总价
@property (nonatomic,strong) NSString *cartTotalPrice;
///配送费
@property (nonatomic,strong) NSString *postMoney;


///账号类型 1=商户 0=个人
@property (nonatomic,strong) NSString *approve;

///
@property (nonatomic,strong) NSMutableArray *titleArray;

///分组 数量
@property (nonatomic,strong) NSMutableArray *secionMarray;

@property (nonatomic,strong) NSString *isFirst;


@end

@implementation ShoppingCartViewController
-(void)viewWillAppear:(BOOL)animated
{
   self.navItem.title = @"购物车";
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    //禁止页面左侧滑动返回，注意，如果仅仅需要禁止此单个页面返回，还需要在viewWillDisapper下开放侧滑权限
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    if ([self.isFirst isEqualToString:@"1"]) {
        
    }else{
         [self requestStoreStatedData];
    }
    self.isFirst = @"2";

    ///清空已经选择的优惠券
    [self deleteCardTickets];
}

-(void)viewWillDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
    //[[GlobalHelper shareInstance] removeErrorView];

    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    self.productIdMarray = [NSMutableArray array];
    self.guessLikeMarray = [NSMutableArray array];
    self.yoriginalListMarray = [NSMutableArray array];
    self.xsmallListMarray = [NSMutableArray array];
    self.ssampleListMarray = [NSMutableArray array];
    self.sloseListMarray = [NSMutableArray array];
    self.secionMarray = [NSMutableArray array];
    
   
    self.titleArray = [NSMutableArray array];
    
    [self netWorkIsOnLine];
    self.isFirst = @"1";
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

    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/mobile/store/get_store" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
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
            self.approve = [NSString stringWithFormat:@"%ld" ,[dic[@"isApprove"] integerValue]];

        }else{
            self.approve = @"2";

            [user setValue:@"2" forKey:@"approve"];
            
        }
///请求购物车数据
        [self requestShoppingListData];
        [self requestGuesslikeData];

        
        [myTableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
    
    
}




-(void)netWorkIsOnLine{
//    [GLobalRealReachability startNotifier];
//
//    [GLobalRealReachability reachabilityWithBlock:^(ReachabilityStatus status) {
//        if (status == RealStatusNotReachable)
//        {
//            [[GlobalHelper shareInstance] showErrorIView:self.view errorImageString:@"wuwangluo" errorBtnString:@"重新加载" errorCGRect:CGRectMake(0, 0, kWidth, kHeight)];
//            [[GlobalHelper shareInstance].errorLoadingBtn addTarget:self action:@selector(errorLoadingBtnAction) forControlEvents:1];
//
//        }else{
    
            [self setupMainView];
            [self setupRefresh];
            [self requestBadNumValue];
            [[GlobalHelper shareInstance] removeErrorView];
//        }
//        
//    }];
//   
    
    
    
 
}


#pragma mark = 重新加载

-(void)errorLoadingBtnAction{
   
            [self setupMainView];
            [self setupRefresh];
            
    
    
 
   
}




#pragma mark =========计算 购物车底部价格显示

-(void)countPrices{
    if ([self.cartTotalPrice length] != 0 && ![self.cartTotalPrice isEqualToString:@"(null)"]) {
        self.bottomView.priceLabel.text = [NSString stringWithFormat:@"¥ %@" ,self.cartTotalPrice];
    }else{
        self.bottomView.priceLabel.text = [NSString stringWithFormat:@"¥ %@" ,@"0"];
    }
    if ([self.postMoney length] != 0 && ![self.postMoney isEqualToString:@"(null)"]) {
        
        if ([self.postMoney isEqualToString:@"0"]) {
            self.bottomView.sendPrices.text = [NSString stringWithFormat:@"¥ %@" ,self.postMoney];
        }else{
        
//            if ([self.bottomView.sendPrices.text length] == 0) {
//
//            }else{
            self.bottomView.sendPrices.text = [NSString stringWithFormat:@"¥ %@ (满199元享包邮)" ,self.postMoney];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.bottomView.sendPrices.text];
            NSRange range1 = [[str string] rangeOfString:@" (满199元享包邮)"];
            [str addAttribute:NSForegroundColorAttributeName value:RGB(236, 31, 35, 1) range:range1];
            
            self.bottomView.sendPrices.attributedText = str;
           // }
        }
        
    }else{
        self.bottomView.sendPrices.text = [NSString stringWithFormat:@"¥ %@" ,@"0"];
    }

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


//#pragma mark =====购物车数量
//-(void)requestBadNumValue{
//    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSString *ticket = [user valueForKey:@"ticket"];
//    NSString *secret = @"UHnyKzP5sNmh2EV0Dflgl4VfzbaWc4crQ7JElfw1cuNCbcJUau";
//    NSString *nonce = [self ret32bitString];//随机数
//    NSString *curTime = [self dateTransformToTimeSp];
//    NSString *checkSum = [self sha1:[NSString stringWithFormat:@"%@%@%@" ,secret ,  nonce ,curTime]];
//    
//    [dic setValue:secret forKey:@"secret"];
//    [dic setValue:nonce forKey:@"nonce"];
//    [dic setValue:curTime forKey:@"curTime"];
//    [dic setValue:checkSum forKey:@"checkSum"];
//    [dic setValue:ticket forKey:@"ticket"];
//    
//    
//    [MHNetworkManager  postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/cart/get_cart_product_count" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
//        
//        if ([returnData[@"status"] integerValue] == 200)
//        {
//            [GlobalHelper shareInstance].shoppingCartBadgeValue = [returnData[@"data"] integerValue];
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"shoppingCart" object:nil userInfo:nil];
//        }
//        
//        DLog(@"购物车数量==  %@" ,returnData);
//    } failureBlock:^(NSError *error) {
//        
//        DLog(@"购物车数量error==  %@" ,error);
//        
//    } showHUD:NO];
//    
//    
//    
//    
//    
//    
//}

#pragma mark = =获取订单信息(去结算)

-(void)getOrderInfoData{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    dic = [self checkoutData];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    [dic setValue:@"NO_SERVICE" forKey:@"serviceType"];
    [dic setValue:@"" forKey:@"ticketId"];
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    if ([[user valueForKey:@"approve"] isEqualToString:@"0"] || [[user valueForKey:@"approve"] isEqualToString:@"2"]) {
        
        [dic setValue:@"PERSON" forKey:@"showType"];
        
    }else if ([[user valueForKey:@"approve"] isEqualToString:@"1"]){
        
        [dic setValue:@"SOGO" forKey:@"showType"];
        
    }
    
    
    NSMutableArray *orderListMarray = [NSMutableArray array];
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/order/get_order_cart_product_new" , baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        NSLog(@"去结算==== %@" ,returnData);

        if ([returnData[@"status"] integerValue] == 200)
        {
            [orderListMarray removeAllObjects];
        
        NSString *productTotalPrice = returnData[@"data"][@"productTotalPrice"];
        NSString *payment = returnData[@"data"][@"payment"];
            
            NSString *postMoney =  [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"postMoney"]];
            NSString *businessType = [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"businessType"]];
        for (NSMutableDictionary *dic in returnData[@"data"][@"orderItemVoList"]) {
            
            ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
            model.productTotalPrice = productTotalPrice;
            model.payment = payment;
            model.postMoney = postMoney;
            model.businessType = businessType;
            model.mainImage = dic[@"productImage"];
            NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
            if (mainImvMarray.count!=0) {
                model.mainImage = [mainImvMarray firstObject];
            }
            [orderListMarray addObject:model];
        }
        
            [SVProgressHUD dismiss];
            ConfirmOrderInfoViewController *VC = [ConfirmOrderInfoViewController new];
            VC.hidesBottomBarWhenPushed = YES;
            VC.orderListMarray = orderListMarray;
             [user setValue:@"" forKey:@"ticketsCard"];

            [self.navigationController pushViewController:VC animated:YES];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:returnData[@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        
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
    [dic setValue:mTypeIOS forKey:@"mtype"];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    
    
    if ([self.approve isEqualToString:@"0"] || [self.approve isEqualToString:@"2"]) {
        [dic setValue:@"PERSON" forKey:@"showType"];
        
    }else if ([self.approve isEqualToString:@"1"]){
        [dic setValue:@"SOGO" forKey:@"showType"];
        
    }
    
    ///商品
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/cart/select" , baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"])
        {
            [self.yoriginalListMarray removeAllObjects];
            [self.xsmallListMarray removeAllObjects];
            [self.ssampleListMarray removeAllObjects];
            [self.sloseListMarray removeAllObjects];
            [self.secionMarray removeAllObjects];
            [self.titleArray removeAllObjects];
//            [self.ShoppingListDataMarray removeAllObjects];
            self.cartTotalPrice =  [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"cartTotalPrice"]];
            self.postMoney = [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"postMoney"]];
            //购物车选中总价
            self.allChecked = [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"allChecked"]] ;
            
            ///小包装商品
            for (NSDictionary *dic in returnData[@"data"][@"smallList"])
            {
                
                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.cartTotalPrice = self.cartTotalPrice ;
                [self.xsmallListMarray addObject:model];
                
            }
            
            ////失效商品
            for (NSDictionary *dic in returnData[@"data"][@"loseList"])
            {
                
                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
                model.productStatus = 12;
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.cartTotalPrice = self.cartTotalPrice ;
                [self.sloseListMarray addObject:model];
                
            }
            
            
            ////试样商品
            for (NSDictionary *dic in returnData[@"data"][@"sampleList"])
            {
                
                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.cartTotalPrice = self.cartTotalPrice ;
                [self.ssampleListMarray addObject:model];
                
                
            }
            
            ////原箱大包装商品
            for (NSDictionary *dic in returnData[@"data"][@"originalList"])
            {
                
                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.cartTotalPrice = self.cartTotalPrice ;
                [self.yoriginalListMarray addObject:model];
                
                
            }
            
            // self.titleArray = @[@"原箱大包装商品" ,@"小包装商品" ,@"试样品" ,@"失效商品"];
            
            
            if (self.yoriginalListMarray.count != 0) {
                [self.secionMarray addObject:self.yoriginalListMarray];
                [self.titleArray addObject:@"原箱大包装商品"];
            }
            if (self.xsmallListMarray.count != 0) {
                [self.secionMarray addObject:self.xsmallListMarray];
                [self.titleArray addObject:@"小包装商品"];
                
            }
            if (self.ssampleListMarray.count != 0) {
                [self.secionMarray addObject:self.ssampleListMarray];
                [self.titleArray addObject:@"试样品"];
                
            }
            if (self.sloseListMarray.count != 0) {
                [self.secionMarray addObject:self.sloseListMarray];
                [self.titleArray addObject:@"失效商品"];
                
            }
            [self.secionMarray addObject:@[@"猜你喜欢"]];
            [self.titleArray addObject:@"猜你喜欢"];
            
            
            [self countPrices];
            [myTableView reloadData];
            
        }else{
            
            // [self alertMessage:returnData[@"msg"] willDo:nil];
        }
    } failureBlock:^(NSError *error) {
        
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
    [dic setValue:mTypeIOS forKey:@"mtype"];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
   
    //[dic setObject:productIds forKey:@"productIds"];

    if ([self.approve isEqualToString:@"0"] || [self.approve isEqualToString:@"2"]) {
        [dic setValue:@"PERSON" forKey:@"showType"];
        
    }else if ([self.approve isEqualToString:@"1"]){
        [dic setValue:@"SOGO" forKey:@"showType"];
        
    }

    ///商品
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/cart/un_select" , baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
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
            [self.yoriginalListMarray removeAllObjects];
            [self.xsmallListMarray removeAllObjects];
            [self.ssampleListMarray removeAllObjects];
            [self.sloseListMarray removeAllObjects];
            [self.secionMarray removeAllObjects];
            [self.titleArray removeAllObjects];
            //[self.ShoppingListDataMarray removeAllObjects];
            self.cartTotalPrice =  [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"cartTotalPrice"]];
            self.postMoney = [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"postMoney"]];

            //购物车选中总价
            self.allChecked = [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"allChecked"]] ;
            
            ///小包装商品
            for (NSDictionary *dic in returnData[@"data"][@"smallList"])
            {
                
                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.cartTotalPrice = self.cartTotalPrice ;
                [self.xsmallListMarray addObject:model];
                
            }
            
            ////失效商品
            for (NSDictionary *dic in returnData[@"data"][@"loseList"])
            {
                
                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
                model.productStatus = 12;
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.cartTotalPrice = self.cartTotalPrice ;
                [self.sloseListMarray addObject:model];
                
            }
            
            
            ////试样商品
            for (NSDictionary *dic in returnData[@"data"][@"sampleList"])
            {
                
                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.cartTotalPrice = self.cartTotalPrice ;
                [self.ssampleListMarray addObject:model];
                
                
            }
            
            ////原箱大包装商品
            for (NSDictionary *dic in returnData[@"data"][@"originalList"])
            {
                
                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.cartTotalPrice = self.cartTotalPrice ;
                [self.yoriginalListMarray addObject:model];
                
                
            }
            
            // self.titleArray = @[@"原箱大包装商品" ,@"小包装商品" ,@"试样品" ,@"失效商品"];
            
            
            if (self.yoriginalListMarray.count != 0) {
                [self.secionMarray addObject:self.yoriginalListMarray];
                [self.titleArray addObject:@"原箱大包装商品"];
            }
            if (self.xsmallListMarray.count != 0) {
                [self.secionMarray addObject:self.xsmallListMarray];
                [self.titleArray addObject:@"小包装商品"];
                
            }
            if (self.ssampleListMarray.count != 0) {
                [self.secionMarray addObject:self.ssampleListMarray];
                [self.titleArray addObject:@"试样品"];
                
            }
            if (self.sloseListMarray.count != 0) {
                [self.secionMarray addObject:self.sloseListMarray];
                [self.titleArray addObject:@"失效商品"];
                
            }
            [self.secionMarray addObject:@[@"猜你喜欢"]];
            [self.titleArray addObject:@"猜你喜欢"];
            
            
            [self countPrices];
            [myTableView reloadData];
            
        }else{
            // [self alertMessage:returnData[@"msg"] willDo:nil];
        }
        
        
        
        
        
        
        
    } failureBlock:^(NSError *error) {
        
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
    [dic setValue:mTypeIOS forKey:@"mtype"];

    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    //[dic setObject:productIds forKey:@"productIds"];
    
    ///商品
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/cart/un_select_all" , baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        DLog(@"全部取消选中商品结算=== %@   %@" ,returnData[@"msg"] , returnData);
        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"])
        {
            //[self.ShoppingListDataMarray removeAllObjects];
            self.cartTotalPrice =  [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"cartTotalPrice"]];
            self.postMoney = [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"postMoney"]];

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
               // [self.ShoppingListDataMarray addObject:model];
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
    [dic setValue:mTypeIOS forKey:@"mtype"];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    ///商品
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/cart/select_all" , baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        DLog(@"全部选中商品结算=== %@   %@" ,returnData[@"msg"] , returnData);
        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"])
        {
            //[self.ShoppingListDataMarray removeAllObjects];
            self.cartTotalPrice =  [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"cartTotalPrice"]];
            self.postMoney = [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"postMoney"]];

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
                //[self.ShoppingListDataMarray addObject:model];
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
    [self requestStoreStatedData];
//    [self requestShoppingListData];
    [self requestBadNumValue];

    [myTableView.mj_header endRefreshing];
    [myTableView.mj_footer endRefreshing];
    
}




#pragma mark =============== 购物车列表数据接口


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
    [dic setValue:mTypeIOS forKey:@"mtype"];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];

    if ([self.approve isEqualToString:@"0"] || [self.approve isEqualToString:@"2"] ) {
        [dic setValue:@"PERSON" forKey:@"showType"];

    }else if ([self.approve isEqualToString:@"1"]){
        [dic setValue:@"SOGO" forKey:@"showType"];

    }
    
    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/cart/select_commodity_by_customer_type" , baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        [self.yoriginalListMarray removeAllObjects];
        [self.xsmallListMarray removeAllObjects];
        [self.ssampleListMarray removeAllObjects];
        [self.sloseListMarray removeAllObjects];
        [self.secionMarray removeAllObjects];
        [self.titleArray removeAllObjects];
        DLog(@"购物车列表数据接口======= %@  %@" , returnData[@"msg"], returnData );
        
        [[GlobalHelper shareInstance] removeErrorView];
         ////下面判断可删除
        if ([returnData[@"code"]isEqualToString:@"0404"] || [returnData[@"code"]  isEqualToString:@"04"]) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:@"0" forKey:@"isLoginState"];
        }
        
        
        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"])
        {
            
            
            [self.yoriginalListMarray removeAllObjects];
            [self.xsmallListMarray removeAllObjects];
            [self.ssampleListMarray removeAllObjects];
            [self.sloseListMarray removeAllObjects];
            [self.secionMarray removeAllObjects];
            [self.titleArray removeAllObjects];
            
            
            
            self.cartTotalPrice =  [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"cartTotalPrice"]];//购物车选中总价
            self.postMoney = [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"postMoney"]];

            self.allChecked = [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"allChecked"]] ;

            ///小包装商品
            for (NSDictionary *dic in returnData[@"data"][@"smallList"])
            {
                
                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.cartTotalPrice = self.cartTotalPrice ;
                [self.xsmallListMarray addObject:model];
                
            }
            
            ////失效商品
            for (NSDictionary *dic in returnData[@"data"][@"loseList"])
            {
                
                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
                model.productStatus = 12;
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.cartTotalPrice = self.cartTotalPrice ;
                [self.sloseListMarray addObject:model];

            }
            
            
            ////试样商品
            for (NSDictionary *dic in returnData[@"data"][@"sampleList"])
            {
                
                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.cartTotalPrice = self.cartTotalPrice ;
                [self.ssampleListMarray addObject:model];
                

            }
            
            ////原箱大包装商品
            for (NSDictionary *dic in returnData[@"data"][@"originalList"])
            {
                
                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.cartTotalPrice = self.cartTotalPrice ;
                [self.yoriginalListMarray addObject:model];
                

            }
            
           // self.titleArray = @[@"原箱大包装商品" ,@"小包装商品" ,@"试样品" ,@"失效商品"];

            
            if (self.yoriginalListMarray.count != 0) {
                [self.secionMarray addObject:self.yoriginalListMarray];
                [self.titleArray addObject:@"原箱大包装商品"];
            }
            if (self.xsmallListMarray.count != 0) {
                [self.secionMarray addObject:self.xsmallListMarray];
                [self.titleArray addObject:@"小包装商品"];

            }
            if (self.ssampleListMarray.count != 0) {
                [self.secionMarray addObject:self.ssampleListMarray];
                [self.titleArray addObject:@"试样品"];

            }
            if (self.sloseListMarray.count != 0) {
                [self.secionMarray addObject:self.sloseListMarray];
                [self.titleArray addObject:@"失效商品"];

            }
            [self.secionMarray addObject:@[@"猜你喜欢"]];
            [self.titleArray addObject:@"猜你喜欢"];

            DLog(@"///======== %ld" ,self.secionMarray.count);
            
            
            
            [self countPrices];
            [myTableView reloadData];
            
        }else{
            
            self.bottomView.priceLabel.text = [NSString stringWithFormat:@"¥ %@" ,@"0"];
            self.bottomView.sendPrices.text = [NSString stringWithFormat:@"¥ %@" ,@"0"];

            [self.yoriginalListMarray removeAllObjects];
            [self.xsmallListMarray removeAllObjects];
            [self.ssampleListMarray removeAllObjects];
            [self.sloseListMarray removeAllObjects];
            [self.secionMarray removeAllObjects];
            [self.titleArray removeAllObjects];
            
            [self.secionMarray addObject:@[@"猜你喜欢"]];
            [self.titleArray addObject:@"猜你喜欢"];
            [myTableView reloadData];
        
           // [self alertMessage:returnData[@"msg"] willDo:nil];
        }
        
    } failureBlock:^(NSError *error) {
        DLog(@"购物车列表error=== %@" , error);

        
    } showHUD:NO];
    
  
    
}


#pragma mark = 猜你喜欢

-(void)requestGuesslikeData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *dataUTF8;
    if ([[user valueForKey:@"approve"] isEqualToString:@"1"]) {//商户猜你喜欢
        dataUTF8 = [[NSString stringWithFormat:@"%@/m/mobile/guess/guesslike?promotionId=1&mtype=%@&appVersionNumber=%@&user=%@&showType=SOGO" ,baseUrl,mTypeIOS ,[user valueForKey:@"appVersionNumber"] , [user valueForKey:@"user"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    }else if ([[user valueForKey:@"approve"] isEqualToString:@"0"] || [[user valueForKey:@"approve"] isEqualToString:@"2"]){//个人用户
         dataUTF8 = [[NSString stringWithFormat:@"%@/m/mobile/guess/guesslike?promotionId=1&mtype=%@&appVersionNumber=%@&user=%@&showType=PERSON" ,baseUrl,mTypeIOS ,[user valueForKey:@"appVersionNumber"] , [user valueForKey:@"user"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
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
    [dic setValue:mTypeIOS forKey:@"mtype"];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    if ([[user valueForKey:@"approve"] isEqualToString:@"0"] || [[user valueForKey:@"approve"] isEqualToString:@"2"]) {
        
        [dic setValue:@"PERSON" forKey:@"showType"];
        
    }else if ([[user valueForKey:@"approve"] isEqualToString:@"1"]){
        
        [dic setValue:@"SOGO" forKey:@"showType"];
        
    }
    DLog(@"猜你喜欢====dic====%@   %ld" ,dic ,productId);
    
    [MHNetworkManager  postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/cart/add",baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
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
    
   // [self.ShoppingListDataMarray removeAllObjects];
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
    [dic setValue:mTypeIOS forKey:@"mtype"];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    
    if ([self.approve isEqualToString:@"0"] || [self.approve isEqualToString:@"2"]) {
        
        [dic setValue:@"PERSON" forKey:@"showType"];
        
    }else if ([self.approve isEqualToString:@"1"]){
        
        [dic setValue:@"SOGO" forKey:@"showType"];
        
    }
    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/cart/delete_product", baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
        DLog(@"删除 == %@" , returnData);
        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"])
        {
            [self.yoriginalListMarray removeAllObjects];
            [self.xsmallListMarray removeAllObjects];
            [self.ssampleListMarray removeAllObjects];
            [self.sloseListMarray removeAllObjects];
            [self.secionMarray removeAllObjects];
            [self.titleArray removeAllObjects];
            
            
            self.cartTotalPrice =  [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"cartTotalPrice"]];
            //购物车选中总价
            self.postMoney = [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"postMoney"]];

            self.allChecked = [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"allChecked"]] ;
            
//            for (NSDictionary *dic in returnData[@"data"][@"cartProductVoList"])
//            {
//
//                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
//                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
//                if (mainImvMarray.count!=0) {
//                    model.mainImage = [mainImvMarray firstObject];
//                }
//                model.cartTotalPrice = self.cartTotalPrice ;
//                [self.ShoppingListDataMarray addObject:model];
//            }
            
            
            ///小包装商品
            for (NSDictionary *dic in returnData[@"data"][@"smallList"])
            {
                
                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.cartTotalPrice = self.cartTotalPrice ;
                [self.xsmallListMarray addObject:model];
                
            }
            
            ////失效商品
            for (NSDictionary *dic in returnData[@"data"][@"loseList"])
            {
                
                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
                model.productStatus = 12;

                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.cartTotalPrice = self.cartTotalPrice ;
                [self.sloseListMarray addObject:model];
                
            }
            
            
            ////试样商品
            for (NSDictionary *dic in returnData[@"data"][@"sampleList"])
            {
                
                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.cartTotalPrice = self.cartTotalPrice ;
                [self.ssampleListMarray addObject:model];
                
                
            }
            
            ////原箱大包装商品
            for (NSDictionary *dic in returnData[@"data"][@"originalList"])
            {
                
                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.cartTotalPrice = self.cartTotalPrice ;
                [self.yoriginalListMarray addObject:model];
                
                
            }
            
            // self.titleArray = @[@"原箱大包装商品" ,@"小包装商品" ,@"试样品" ,@"失效商品"];
            
            
            if (self.yoriginalListMarray.count != 0) {
                [self.secionMarray addObject:self.yoriginalListMarray];
                [self.titleArray addObject:@"原箱大包装商品"];
            }
            if (self.xsmallListMarray.count != 0) {
                [self.secionMarray addObject:self.xsmallListMarray];
                [self.titleArray addObject:@"小包装商品"];
                
            }
            if (self.ssampleListMarray.count != 0) {
                [self.secionMarray addObject:self.ssampleListMarray];
                [self.titleArray addObject:@"试样品"];
                
            }
            if (self.sloseListMarray.count != 0) {
                [self.secionMarray addObject:self.sloseListMarray];
                [self.titleArray addObject:@"失效商品"];
                
            }
            [self.secionMarray addObject:@[@"猜你喜欢"]];
            [self.titleArray addObject:@"猜你喜欢"];

            
            
            
            
            
            
            if (self.secionMarray.count == 1) {
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
    [dic setValue:mTypeIOS forKey:@"mtype"];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    
    
    if ([self.approve isEqualToString:@"0"] || [self.approve isEqualToString:@"2"]) {
        [dic setValue:@"PERSON" forKey:@"showType"];
        
    }else if ([self.approve isEqualToString:@"1"]){
        [dic setValue:@"SOGO" forKey:@"showType"];
        
    }
    DLog(@"购物车加减购物车===%@" ,dic);

    [MHNetworkManager  postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/cart/update" , baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
        DLog(@"购物车加减购物车===%@" ,returnData);
        
        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"])
        {
            
            [self.yoriginalListMarray removeAllObjects];
            [self.xsmallListMarray removeAllObjects];
            [self.ssampleListMarray removeAllObjects];
            [self.sloseListMarray removeAllObjects];
            [self.secionMarray removeAllObjects];
            
            self.cartTotalPrice =  [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"cartTotalPrice"]];
            //购物车选中总价
            self.postMoney = [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"postMoney"]];

            self.allChecked = [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"allChecked"]] ;
            
//            for (NSDictionary *dic in returnData[@"data"][@"cartProductVoList"])
//            {
//
//                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
//                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
//                if (mainImvMarray.count!=0) {
//                    model.mainImage = [mainImvMarray firstObject];
//                }
//                model.cartTotalPrice = self.cartTotalPrice ;
//                [self.ShoppingListDataMarray addObject:model];
//            }
            
            
            ///小包装商品
            for (NSDictionary *dic in returnData[@"data"][@"smallList"])
            {
                
                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.cartTotalPrice = self.cartTotalPrice ;
                [self.xsmallListMarray addObject:model];
                
            }
            
            ////失效商品
            for (NSDictionary *dic in returnData[@"data"][@"loseList"])
            {
                
                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
                model.productStatus = 12;

                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.cartTotalPrice = self.cartTotalPrice ;
                [self.sloseListMarray addObject:model];
                
            }
            
            
            ////试样商品
            for (NSDictionary *dic in returnData[@"data"][@"sampleList"])
            {
                
                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.cartTotalPrice = self.cartTotalPrice ;
                [self.ssampleListMarray addObject:model];
                
                
            }
            
            ////原箱大包装商品
            for (NSDictionary *dic in returnData[@"data"][@"originalList"])
            {
                
                ShoppingCartModel *model = [ShoppingCartModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
                model.cartTotalPrice = self.cartTotalPrice ;
                [self.yoriginalListMarray addObject:model];
                
                
            }
            
            // self.titleArray = @[@"原箱大包装商品" ,@"小包装商品" ,@"试样品" ,@"失效商品"];
            
            
            if (self.yoriginalListMarray.count != 0) {
                [self.secionMarray addObject:self.yoriginalListMarray];
                [self.titleArray addObject:@"原箱大包装商品"];
            }
            if (self.xsmallListMarray.count != 0) {
                [self.secionMarray addObject:self.xsmallListMarray];
                [self.titleArray addObject:@"小包装商品"];
                
            }
            if (self.ssampleListMarray.count != 0) {
                [self.secionMarray addObject:self.ssampleListMarray];
                [self.titleArray addObject:@"试样品"];
                
            }
            if (self.sloseListMarray.count != 0) {
                [self.secionMarray addObject:self.sloseListMarray];
                [self.titleArray addObject:@"失效商品"];
                
            }
            [self.secionMarray addObject:@[@"猜你喜欢"]];
            [self.titleArray addObject:@"猜你喜欢"];

            
            
            
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



-(void)deleteCardTickets{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    dic = [self checkoutData];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
   
    
    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/ticket/deleteTicket" , baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
        if ([returnData[@"status"] integerValue] == 200)
        {
           
        }else{
           
        }
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
    
    
}



#pragma mark ========全选按钮点击事件

-(void)selectAllBtnClick:(UIButton*)button
{
    if (self.secionMarray.count != 1 || self.secionMarray.count != 0) {
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
        
    }
  
}





#pragma mark - 设置底部视图
-(void)setupBottomView
{
    CGFloat yHeight =  0;
    if (self.isShowTabBarBottomView == YES)
    {
        yHeight = LL_TabbarSafeBottomMargin;
    }
    self.bottomView= [[ShoppingCartBottomView alloc] init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@44);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-yHeight);
        
        
    }];
    
    [self.bottomView.selectAll addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.PayBtn addTarget:self action:@selector(goPayBtnClick) forControlEvents:UIControlEventTouchUpInside];

    
}

#pragma mark - 设置主视图
-(void)setupMainView
{
    if (myTableView == nil) {
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
   
 
}

#pragma mark - tableView 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        if (section == 0){
            return [self.secionMarray[0] count];
        }else if (section == 1){
            return [self.secionMarray[1] count];
            
        }else if (section == 2){
            return [self.secionMarray[2] count];
            
        }else if (section == 3){
            return [self.secionMarray[3] count];
            
        }else{
            return [self.secionMarray[4] count];
            
        }
        
        
    
    
   
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.secionMarray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == self.secionMarray.count-1) {
        return  [self GetCellHeight:self.guessLikeMarray.count]*200*kScale +85*kScale;

    }
    return 90*kScale +20*kScale;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
        if (self.secionMarray.count == 1) {///此时只有猜你喜欢
            if (section == 0) {
                
                if (self.guessLikeMarray.count == 0) {
                    
                    return 185*kScale;
                 
                }else{
                     return 250*kScale;
                 }
                
            }else if (section == 1){
                
                if (self.guessLikeMarray.count == 0) {
                    return 0.01;
                }
                return 65*kScale;
            }
        }else{
            
            if (section == 0) {
                return 70*kScale;
            }else if (section == self.secionMarray.count -1){
                return 65*kScale;
                
            }else{
                return 35*kScale;
            }
            
        }
        
        
    return 35*kScale;
   
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.secionMarray.count == 1) {///此时只有猜你喜欢
        if (section == 0) {
            
            if (self.guessLikeMarray.count == 0) {
                
                ShoppingCartEmptyHeadView *emptyHeadView = [[ShoppingCartEmptyHeadView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 185*kScale)];
                emptyHeadView.backgroundColor = [UIColor whiteColor];
                
                return emptyHeadView;
                
            }else{
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 250*kScale)];
                view.backgroundColor = RGB(238, 238, 238, 1);
                
                ShoppingCartEmptyHeadView *emptyHeadView = [[ShoppingCartEmptyHeadView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 185*kScale)];
                emptyHeadView.backgroundColor = [UIColor whiteColor];
                [view addSubview:emptyHeadView];
                
                YouLikeCollectionHeadView *headview = [[YouLikeCollectionHeadView alloc] initWithFrame:CGRectMake(0, 195*kScale, kWidth, 55*kScale)];
                headview.titleLab.text = @"猜你喜欢";
                headview.backgroundColor = [UIColor whiteColor];
                
                [view addSubview:headview];
                
                return view;
            }
            
            
            
        }else if (section == 1){
            
            if (self.guessLikeMarray.count == 0) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.01)];
                view.backgroundColor = RGB(238, 238, 238, 1);
                return view;
            }
            YouLikeCollectionHeadView *headview = [[YouLikeCollectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 55*kScale)];
            headview.titleLab.text = @"猜你喜欢";
            headview.backgroundColor = [UIColor whiteColor];
            return headview;
        }
    }else if (self.secionMarray.count >= 1){
        
        if (section == 0) {
            ShoppingCartAddressHeadView *addressView = [[ShoppingCartAddressHeadView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 35*kScale)];
            [addressView.addressBtn setTitle:[GlobalHelper shareInstance].selectAddressString forState:0];
            addressView.backgroundColor = [UIColor whiteColor];
            
            UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 35*kScale, kWidth, 35*kScale)];
            labTitle.textColor = RGB(136, 136, 136, 1);
            labTitle.font = [UIFont systemFontOfSize:15.0f*kScale];
            labTitle.textAlignment = NSTextAlignmentCenter;
            labTitle.backgroundColor = RGB(238, 238, 238, 1);
            labTitle.text = self.titleArray[section];
            [addressView addSubview:labTitle];
            
            
            
            return addressView;
        }else if (section == self.secionMarray.count -1){
            if (self.guessLikeMarray.count == 0) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.01)];
                view.backgroundColor = RGB(238, 238, 238, 1);
                return view;
            }else{
            YouLikeCollectionHeadView *headview = [[YouLikeCollectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 55*kScale)];
            headview.titleLab.text = @"猜你喜欢";
            headview.backgroundColor = [UIColor whiteColor];
            return headview;
            }
            
        }else{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.01)];
            view.backgroundColor = RGB(238, 238, 238, 1);
            
            UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, 35*kScale)];

            labTitle.textColor = RGB(136, 136, 136, 1);
            labTitle.font = [UIFont systemFontOfSize:15.0f*kScale];
            labTitle.textAlignment = NSTextAlignmentCenter;
            labTitle.backgroundColor = RGB(238, 238, 238, 1);
            
            labTitle.text = self.titleArray[section];
            [view addSubview:labTitle];
            
            return view;
        }
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.01)];
    view.backgroundColor = RGB(238, 238, 238, 1);
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (self.secionMarray.count == 1) {///此时只有猜你喜欢
        if (section == 0) {
            return 0.001*kScale;
        }else if (section == 1){
            return 0.001*kScale;
        }
        
    }else{
        
        if (section == self.secionMarray.count -2){
            return 20*kScale;
        }
    }
    return 0.001*kScale;

   
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 20)];
    view.backgroundColor = RGB(238, 238, 238, 1);
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{  ///底部是否全选
    if ([self.allChecked isEqualToString:@"1"]) {
        self.bottomView.selectAll.selected = YES;
        
    }else if ([self.allChecked isEqualToString:@"0"])
    {
        self.bottomView.selectAll.selected = NO;
        
    }
    
    if (indexPath.section == self.secionMarray.count-1) {///猜你喜欢
        
        YouLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID_like"];
        //if (cell == nil) {
            cell = [[YouLikeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID_like"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
       // }
        
        //获取到数据后刷新
        if (self.guessLikeMarray.count != 0) {
            cell.HomeArray = self.guessLikeMarray;
            [cell.CollView reloadData];
            cell.CollView.backgroundColor = [UIColor whiteColor];
            //防止出现collerview滚动
            cell.CollView.scrollEnabled = NO;
            cell.delegateColl = self;
            
            [cell setCollViewHeight:[self GetCellHeight:self.guessLikeMarray.count]*200*kScale +85*kScale];
            [cell configHeight:[self GetCellHeight:self.guessLikeMarray.count]*200*kScale + 85*kScale];
            
        }else{
            
            cell.CollView.backgroundColor = RGB(238, 238, 238, 1);

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
        
    }else{
        
        NSString *Identifier = [NSString stringWithFormat:@"cellID_shop%ld%ld" ,(long)indexPath.section,indexPath.row];
        
        ShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if (!cell) {
            cell = [[ShoppingCartTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.isSelected = isSelect;
        cell.selectBtn.tag = indexPath.row;
        
        //选择回调
        cell.cartBlock = ^(BOOL isSelec){
            if (isSelec) {
#pragma mark ========选中购物车商品
                ShoppingCartModel *cartModel = self.secionMarray[indexPath.section][indexPath.row];
                [self selectProductsPostDataCommodityId:[NSString stringWithFormat:@"%ld" , (long)cartModel.commodityId]];
            }
            else
            {
#pragma mark ========取消选中购物车商品
                
                ShoppingCartModel *cartModel = self.secionMarray[indexPath.section][indexPath.row];
                
                [self cancelProductsPostDataCommodityId:[NSString stringWithFormat:@"%ld" , cartModel.commodityId]];
                
            }
            
            
        };
        
        
        __block ShoppingCartTableViewCell *weakCell = cell;
        __weak __typeof(self) weakSelf = self;
        if (self.secionMarray.count != 1) {
            ShoppingCartModel *model = self.secionMarray[indexPath.section][indexPath.row];
            ///加入购物车
            cell.numAddBlock =^(){
                
                [weakSelf cutCartPostDataWithProductId:model.commodityId quatity:1 CartStyle:@"1" shoppingTableViewCell:weakCell ShoppingCartModel:model NSIndexPath:indexPath];
            };
            
            
            
            cell.numCutBlock =^(){
                NSInteger count = [weakCell.numberLabel.text integerValue];
                if (count>1)
                {
                    [self cutCartPostDataWithProductId:model.commodityId quatity:-1 CartStyle:@"0" shoppingTableViewCell:weakCell ShoppingCartModel:model NSIndexPath:indexPath];
                }else{
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
            
            
            
            [cell.deleteBtn addTarget:self action:@selector(deleteBtnProductsAction:) forControlEvents:1];
            cell.deleteBtn.tag = indexPath.row;
            
            ///商品cell赋值
            if (self.secionMarray.count !=0 || self.secionMarray.count !=1 ) {
                [cell reloadDataWith:[self.secionMarray[indexPath.section] objectAtIndex:indexPath.row]];
            }else{
                DLog(@"sssssss");
            }
            
        }
        return cell;
        
        
        
       
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.secionMarray.count != 1 && indexPath.section != self.secionMarray.count-1) {
        ShoppingCartModel *model = self.secionMarray[indexPath.section][indexPath.row];
        if (model.productStatus == 11) {//上架
            HomePageDetailsViewController *VC = [HomePageDetailsViewController new];
            
            VC.detailsId = [NSString stringWithFormat:@"%ld" ,(long)model.commodityId];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
        }else{
            
        }
        
    }
   
    
    
}

#pragma mark ==失效商品商品下架 删除整个商品

-(void)deleteBtnProductsAction:(UIButton*)btn{
    DLog(@"删除商品tag================ %ld" ,btn.tag)
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该商品?删除后无法恢复!" preferredStyle:1];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        ///删除整个商品
        if (self.secionMarray.count >= 1) {
            NSInteger section = self.secionMarray.count-2;
            
            ShoppingCartModel *model = self.secionMarray[section][btn.tag];
            
            [self deleteProductPostDataWithProductId:model.commodityId ShoppingCartModel:model];
            
        }
       
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:okAction];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
    
 
}



#pragma mark - 猜你喜欢 代理用来接收点击的是第几个
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
    
    if (self.secionMarray.count == 1) {
        
        return NO;
    
    }else{
        
        if (indexPath.section == self.secionMarray.count-1) {
            
            return NO;
       
        }else{
           
            return YES;
        }
        
        
    }
    
//    if (indexPath.section == 0) {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//
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
            
            ShoppingCartModel *model = self.secionMarray[indexPath.section][indexPath.row];

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



-(void)leftItemAction{
//    if (self.presentingViewController) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    } else {
        [self.navigationController popViewControllerAnimated:YES];
  //  }
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
