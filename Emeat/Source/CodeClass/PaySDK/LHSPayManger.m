//
//  LHSPayManger.m
//  Emeat
//
//  Created by liuheshun on 2018/1/12.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "LHSPayManger.h"
#import <CommonCrypto/CommonDigest.h>
#import "OrderDetailesViewController.h"

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
    if (dic) {
        NSMutableString *stamp  = dic[@"timestamp"];
        //调起支付
        PayReq *req = [[PayReq alloc]init];
        req.partnerId = dic[@"partnerid"];//@"10000100";//商家id
        req.prepayId = dic[@"prepayid"];//@"wx20160222181228eabc76df380849802454";//预支付订单
        req.package = dic[@"package"];  //@"Sign=WXPay";//扩展字段  暂填写固定值Sign=WXPay
        req.nonceStr = dic[@"noncestr"];//@"758d476b9ebdc37e698ccfbdbcd21906";//随机串，防重发
        req.timeStamp = stamp.intValue; //@"1456135948";//时间戳
        req.sign = dic[@"sign"];//@"61EC78AB39E256B2624D54C7E1390D70";//商家根据微信开放平台文档对数据做的签名
        [WXApi sendReq:req];

    }



}

#pragma mark = 支付宝支付

-(void)sendAliPay:(NSString *)orderString{
    NSString *appScheme = @"alisdkSaixian";
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"调起支付结果==== resultStr_%@",resultDic);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Alipay_Result" object:resultDic];

//        [self paymentResult:resultDic];
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




-(void)paymentResult:(NSDictionary *)resultDic {
    //结果处理
    if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
        //支付宝回调显示支付成功后调用自己的后台的借口确认是否支付成功
        NSString *orderStringNO = resultDic[@"result"];
        
        orderStringNO = [orderStringNO stringByReplacingOccurrencesOfString:@" " withString:@"/"];
        NSData *jsonData = [orderStringNO dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        orderStringNO = dic[@"alipay_trade_app_pay_response"][@"out_trade_no"];
        DLog(@"ssssssssssss==== %@" ,orderStringNO);

        [self requsetOrderDetailsData:orderStringNO];
        
        
    }else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]){
       // [self payCancel];
        DLog(@"取消支付");
         [[NSNotificationCenter defaultCenter] postNotificationName:@"Alipay_Result" object:@"取消"];
    }else{
       // [self payFail];
        DLog(@"支付失败");
         [[NSNotificationCenter defaultCenter] postNotificationName:@"Alipay_Result" object:@"失败"];
    }
}


#pragma mark === 请求订单详情 校验订单状态是否支付成功
-(void)requsetOrderDetailsData:(NSString*)orderNo{
   
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
    [dic setValue:orderNo forKey:@"orderNo"];
    [dic setValue:mTypeIOS forKey:@"mtype"];

    
    DLog(@"订单详情dic == %@   orderNo ==== %@ " ,dic , orderNo  );
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/order/detail" , baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        DLog(@"支付回调订单结果===msg=%@   returnData == %@" ,returnData[@"msg"] , returnData);
        
        if ([returnData[@"status"] integerValue] == 200)
        {
            
            OrderModel *model = [OrderModel yy_modelWithJSON:returnData[@"data"]];
            if (model.status == 40) {//已付款 , 订单支付成功
            
                
            }else{//支付不成功
                
            }
//            self.status = footModel.status;
//            [self.footViewOrderInfoMarray addObject:footModel];
            
        }
        
    } failureBlock:^(NSError *error) {
        DLog(@"获取订单信息err0r=== %@  " ,error);
        [SVProgressHUD dismiss];
    } showHUD:NO];
    
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

@end
