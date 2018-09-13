//
//  MyAddressModel.h
//  Emeat
//
//  Created by liuheshun on 2018/1/26.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAddressModel : NSObject
//参数字段说明：
///id:收货地址id
@property (nonatomic,assign) NSInteger id;

///用户id ：user_id
@property (nonatomic,assign) NSInteger user_id;

///收货人姓名：receiverName
@property (nonatomic,strong) NSString *receiverName;

///联系方式：receiverPhone
@property (nonatomic,assign) NSInteger receiverPhone;

///邮政编码:receiverZip
@property (nonatomic,assign) NSInteger receiverZip;

///收货人详细地址:receiverAddress
@property (nonatomic,strong) NSString *receiverAddress;

///收货人省份:receiverProvince
@property (nonatomic,strong) NSString *receiverProvince;

/////收货人城市:receiverCity
//@property (nonatomic,strong) NSString *receiverCity;
//
/////收货人区:receiverDistrict
//@property (nonatomic,strong) NSString *receiverDistrict;

///收货地址分类：shippingCategory 1,2 ,3
@property (nonatomic,assign) NSInteger shippingCategory;

///创建时间:createTime
///修改时间:updateTime

///区分订单 是B端商品( productTypes = SOGO;) 还是C端商品( productTypes = PROCEDDED;)
@property (nonatomic,strong) NSString *businessType;









@end
