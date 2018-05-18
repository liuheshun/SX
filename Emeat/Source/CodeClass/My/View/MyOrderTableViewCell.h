//
//  MyOrderTableViewCell.h
//  Emeat
//
//  Created by liuheshun on 2017/12/14.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderTableViewCell : UITableViewCell
//订单创建时间
@property (nonatomic,strong) UILabel *orderTimeLab;
//订单状态
@property (nonatomic,strong) UILabel *orderStated;
//订单商品图片
@property (nonatomic,strong) UIImageView *orderImv;
//订单详情
@property (nonatomic,strong) UILabel *orderDetailsLab;
//订单完成 评价按钮
@property (nonatomic,strong) UIButton *orderCommentBtn;
@property (nonatomic,strong) UIView *lineView;

////config
-(void)configWithOrderModel:(OrderModel*)model;

@end



@interface MyOrderTableCellConfig : NSObject
+ (MyOrderTableCellConfig*) myOrderTableCellConfig;

@property (nonatomic,strong) NSString *imageString;
@property (nonatomic,strong) NSString *titleString;
@property (nonatomic,strong) NSString *isShowCancelBtn;
@property (nonatomic,strong) NSArray  *orderImvArray;



@end





