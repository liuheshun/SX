//
//  MyAddressViewController.h
//  Emeat
//
//  Created by liuheshun on 2017/12/14.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^returnMyShippingAddress)(MyAddressModel* model);

@interface MyAddressViewController : SHLBaseViewController
@property (nonatomic,copy) returnMyShippingAddress myShippingAddressBlock;
@property (nonatomic,strong) NSString *fromConfirmVC;

@end
