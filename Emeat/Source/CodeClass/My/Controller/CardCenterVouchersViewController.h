//
//  CardCenterVouchersViewController.h
//  Emeat
//
//  Created by liuheshun on 2018/9/20.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectCardPrices)(NSString  *selectCardString);

NS_ASSUME_NONNULL_BEGIN

@interface CardCenterVouchersViewController : SHLBaseViewController

@property (nonatomic,strong) NSString *isFromCardCenter;

@property (nonatomic,copy) SelectCardPrices selectCardPrice;


///订单类型 B C
@property (nonatomic,strong) NSString *businessType;

@end

NS_ASSUME_NONNULL_END
