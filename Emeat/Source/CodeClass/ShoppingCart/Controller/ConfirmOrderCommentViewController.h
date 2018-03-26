//
//  ConfirmOrderCommentViewController.h
//  Emeat
//
//  Created by liuheshun on 2017/11/10.
//  Copyright © 2017年 liuheshun. All rights reserved.
//订单备注

#import <UIKit/UIKit.h>
#import "SHLBaseViewController.h"

typedef void(^returnConmmentStringBlock)(NSString *conmmentStr);

@interface ConfirmOrderCommentViewController : SHLBaseViewController
@property (nonatomic,strong) NSString *conmmentString;

@property (nonatomic,copy) returnConmmentStringBlock conmmentStringBlcok;


@end
