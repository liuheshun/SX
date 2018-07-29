//
//  SliceService ViewController.h
//  Emeat
//
//  Created by liuheshun on 2018/7/26.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ReturnSelectSliceBlock)(NSString *SliceStr ,NSString*serviceType ,NSString*slicePices ,NSString*totalPrice);

@interface SliceService_ViewController : SHLBaseViewController

@property (nonatomic,copy) ReturnSelectSliceBlock returnSelectSliceBlock;


@end
