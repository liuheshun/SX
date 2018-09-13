//
//  CardCenterViewController.h
//  Emeat
//
//  Created by liuheshun on 2018/8/15.
//  Copyright © 2018年 liuheshun. All rights reserved.
//卡券中心

#import <UIKit/UIKit.h>

typedef void(^SelectCardPrices)(NSMutableArray  *selectCardMarray);

@interface CardCenterViewController : SHLBaseViewController

@property (nonatomic,strong) NSString *isFromCardCenter;

@property (nonatomic,copy) SelectCardPrices selectCardPrice;


///订单类型 B C 
@property (nonatomic,strong) NSString *businessType;


@end
