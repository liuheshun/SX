//
//  LHSPayManger.m
//  Emeat
//
//  Created by liuheshun on 2018/1/12.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "LHSPayManger.h"

@implementation LHSPayManger

+ (LHSPayManger*)sharedManager {
    static dispatch_once_t onceToken;
    static LHSPayManger *payManger;
    dispatch_once(&onceToken, ^{
        payManger = [[LHSPayManger alloc] init];
    });
    return payManger;
}

#pragma mark = 微信支付

-(void)sendWXPay:(NSDictionary*)dic{
    NSMutableString *stamp  = dic[@"msg"] [@"timestamp"];
    //调起支付
    PayReq *req = [[PayReq alloc]init];
    req.partnerId = dic[@"msg"][@"partnerid"];//@"10000100";//商家id
    req.prepayId = dic[@"msg"][@"prepayid"];//@"wx20160222181228eabc76df380849802454";//预支付订单
    req.package = dic[@"msg"][@"package"];  //@"Sign=WXPay";//扩展字段  暂填写固定值Sign=WXPay
    req.nonceStr = dic[@"msg"][@"noncestr"];//@"758d476b9ebdc37e698ccfbdbcd21906";//随机串，防重发
    req.timeStamp = stamp.intValue; //@"1456135948";//时间戳
    req.sign = dic[@"msg"][@"sign"];//@"61EC78AB39E256B2624D54C7E1390D70";//商家根据微信开放平台文档对数据做的签名
    [WXApi sendReq:req];



}

#pragma mark = 支付宝支付

-(void)sendAliPay:(NSString *)orderString{
//    NSString *orderString = dic[@"orderString"];
    NSString *appScheme = @"appScheme";
    
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//        NSDictionary *dic = resultDic;
//        NSString *resultStr = EncodeFormDic(dic, @"resultStatus");
        NSLog(@"resultStr_%@",resultDic);
        //[self paymentResult:resultStr];
    }];
    
}

#pragma mark = 银联支付
-(void)sendUPPay:(NSDictionary*)dic UiviewController:(UIViewController*)VC{
    NSString *tn = @"711160276350323179701";
    if (tn.length > 0) {
        //当获得的tn不为空时，调用支付接口
        [[UPPaymentControl defaultControl] startPay:tn fromScheme:@"UPPaySaixian" mode:@"01" viewController:VC];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"银联参数配置不正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
   
}

-(void)s{
    /* 银联支付回调监听 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payOk:) name:@"YINLIANPAYS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payCancel) name:@"YINLIANPAYC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFail) name:@"YINLIANPAYF" object:nil];
    
  
}




-(void)paymentResult:(NSString *)resultd {
    NSLog(@" = %@",resultd);
    //结果处理
    if ([resultd isEqualToString:@"9000"]) {
        //支付宝回调显示支付成功后调用自己的后台的借口确认是否支付成功
        //[self payOrdCallback:@"1"];
    }else if ([resultd isEqualToString:@"6001"]){
       // [self payCancel];
        
    }else{
       // [self payFail];
    }
}






@end
