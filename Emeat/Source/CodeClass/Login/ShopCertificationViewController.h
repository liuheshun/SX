//
//  ShopCertificationViewController.h
//  Emeat
//
//  Created by liuheshun on 2018/4/18.
//  Copyright © 2018年 liuheshun. All rights reserved.
//
//店铺认证

#import <UIKit/UIKit.h>

@interface ShopCertificationViewController : SHLBaseViewController
///是否重新认证 1 为重新认证 0 为首次认证
@property (nonatomic,strong) NSString *isRemakeShopCerific;

@property (nonatomic,strong) MyModel *shopCertifiMyModel;


@end
