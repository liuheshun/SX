//
//  MyModel.h
//  Emeat
//
//  Created by liuheshun on 2018/1/26.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyModel : NSObject
///待付款数
@property (nonatomic,assign) NSInteger waitBuy;
///待配送数
@property (nonatomic,assign) NSInteger waitTransport;
///退货数
@property (nonatomic,assign) NSInteger salesReturn;
///待收货
@property (nonatomic,assign) NSInteger waitRecive;
///待评价
@property (nonatomic,assign) NSInteger waitEvaluation;
///用户id
@property (nonatomic,assign) NSInteger id;
///用户昵称
@property (nonatomic,strong) NSString *nickname;
///用户手机
@property (nonatomic,strong) NSString *customerAccount;
///用户头像
@property (nonatomic,strong) NSString *headPic;

@end
