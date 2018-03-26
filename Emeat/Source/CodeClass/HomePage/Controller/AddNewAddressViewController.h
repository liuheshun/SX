//
//  AddNewAddressViewController.h
//  Emeat
//
//  Created by liuheshun on 2017/12/4.
//  Copyright © 2017年 liuheshun. All rights reserved.
//新增收货地址

#import <UIKit/UIKit.h>

@interface AddNewAddressViewController : SHLBaseViewController
@property (nonatomic,assign) BOOL isCanRemove;
@property (nonatomic,strong) NSString *navTitle;


//传值
///收货人姓名
@property (nonatomic,strong) NSString  *shoppingName;
///
@property (nonatomic,strong) NSString *shoppingPhoneNum;

@property (nonatomic,strong) NSString *shoppingAddressCity;

@property (nonatomic,strong) NSString *shoppingAddressStreet;

@property (nonatomic,strong) NSString *shoppingAddressDetails;

@property (nonatomic,strong) NSString *shoppingAddressType;


@property (nonatomic,strong) MyAddressModel *postMyAddressModel;






@end
