//
//  SortListSegmentView.h
//  Emeat
//
//  Created by liuheshun on 2017/11/29.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^changeStatedBlock)(NSInteger sortNum);///sortNum 0为降序，1为升序

@interface SortListSegmentView : UIView
@property (nonatomic,strong) UIButton *countBtn;
@property (nonatomic,strong) UIButton *priceBtn;
@property (nonatomic,strong) UIButton *checkBtn;

@property (nonatomic,copy) changeStatedBlock countStatedBlock;
@property (nonatomic,copy) changeStatedBlock priceStatedBlock;
@property (nonatomic,copy) changeStatedBlock checkStatedBlock;



@end
