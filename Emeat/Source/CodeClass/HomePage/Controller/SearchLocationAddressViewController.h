//
//  SearchLocationAddressViewController.h
//  Emeat
//
//  Created by liuheshun on 2017/12/12.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
typedef void(^ReturnSearchAddressBlock)(Location *location);

@interface SearchLocationAddressViewController : SHLBaseViewController

@property (nonatomic,copy) ReturnSearchAddressBlock returnSearchAddressBlock;


@end
