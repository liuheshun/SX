//
//  SelectAddressViewController.h
//  Emeat
//
//  Created by liuheshun on 2017/12/4.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
typedef void(^selectAddressBlock)(Location *currentLocations);

@interface SelectAddressViewController : SHLBaseViewController
//我的收获地址
@property (nonatomic,strong) NSMutableArray *myAddressArray;
//附近地址
@property (nonatomic,strong) NSMutableArray *otherAddressArray;
///定位详细地址
@property (nonatomic,strong) Location *currentLocation;


//@property (nonatomic,strong) NSString *currentAddressString;
///定位区地址
@property (nonatomic,strong) NSString *currentAddressSubLocality;

@property (nonatomic,copy) selectAddressBlock selectAddressBL;

@end
