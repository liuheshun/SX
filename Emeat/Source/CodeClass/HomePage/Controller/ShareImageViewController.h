//
//  ShareImageViewController.h
//  Emeat
//
//  Created by liuheshun on 2018/7/16.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareImageViewController : SHLBaseViewController
///商品id
@property (nonatomic,strong) NSString *detailsId;
///分享商品图片
@property (strong,nonatomic)NSString *productImageURL;
///分享商品标题
@property (strong,nonatomic)NSString *productTitle;
///分享商品描述
@property (strong,nonatomic)NSString *productContent;
///分享商品单价
@property (strong,nonatomic)NSString *productPrices;
///app端所有商品对象里面添加一个对象 priceTypes （两个字段private Integer index用于判断直接定价还是按重量计价
@property (nonatomic,strong) NSString *priceTypes;
@end
