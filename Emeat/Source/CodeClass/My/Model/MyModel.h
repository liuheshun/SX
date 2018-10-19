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


///店铺认证
///店铺id
@property (nonatomic,assign) NSInteger storeId;

///店铺地址
@property (nonatomic,strong) NSString *address;
///店铺详细地址
@property (nonatomic,strong) NSString *addressDetail;
///店铺联系电话
@property (nonatomic,assign) NSInteger callNumber;
///店铺联系人
@property (nonatomic,strong) NSString *kp;
///店铺名字
@property (nonatomic,strong) NSString *storeName;

///邀请码
@property (nonatomic,assign) NSInteger bdName;


///是否认证审核通过
@property (nonatomic,assign) NSInteger isApprove;
///是否认证审核通过
@property (nonatomic,assign) NSInteger effectivity;



@end
