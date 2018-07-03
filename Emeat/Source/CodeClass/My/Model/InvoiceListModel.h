//
//  InvoiceListModel.h
//  Emeat
//
//  Created by liuheshun on 2018/6/26.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvoiceListModel : NSObject
///id
@property (nonatomic,strong) NSString *Id;
///订单状态
@property (nonatomic,strong) NSString *status;

///商品数量
@property (nonatomic,assign) NSInteger quantity;
///订单创建时间
@property (nonatomic,strong) NSString *createTime;
////发票金额
@property (nonatomic,assign) NSInteger netPrice;
///图片
@property (nonatomic,strong) NSString *productImage;

///选中状态
@property (nonatomic,assign) NSInteger checkStated;

@property (nonatomic,strong) NSString *orderNo;

///默认商品分页数
@property (nonatomic,assign) NSInteger pages;
///每页展示的商品数量
@property (nonatomic,assign) NSInteger pageSize;
///商品总数量
@property (nonatomic,assign) NSInteger total;//(total/pageSize = pages)

@property (nonatomic,strong) NSString *sectionString;

@end
