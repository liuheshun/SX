//
//  InvoiceListTableViewCell.h
//  Emeat
//
//  Created by liuheshun on 2018/6/21.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCartModel.h"
#import "Masonry.h"
#import "InvoiceListModel.h"
//16进制RGB的颜色转换
#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//R G B 颜色
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

//红色
#define BASECOLOR_RED [UIColor \
colorWithRed:((float)((0xED5565 & 0xFF0000) >> 16))/255.0 \
green:((float)((0xED5565 & 0xFF00) >> 8))/255.0 \
blue:((float)(0xED5565 & 0xFF))/255.0 alpha:1.0]

/**
 
 *
 *  cell是否被选中的回调
 *
 *  @param select 是否被选中
 */
typedef void(^LQQCartBlock)(BOOL select);

/**
 *
 *  数量改变的回调
 */
typedef void(^LQQNumChange)(void);

@interface InvoiceListTableViewCell : UITableViewCell



@property (nonatomic,assign)BOOL isSelected;
@property (nonatomic,copy)LQQCartBlock cartBlock;
@property (nonatomic,copy)LQQNumChange numAddBlock;
@property (nonatomic,copy)LQQNumChange numCutBlock;


///白色背景
@property (nonatomic,strong) UIView *bgView;


///选中按钮
@property (nonatomic,retain) UIButton *selectBtn;

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

@property (nonatomic,strong) UIButton *enterBtn;



////config
-(void)configWithOrderModel:(InvoiceListModel*)model;

@end



@interface InvoiceTableCellConfig : NSObject
+ (InvoiceTableCellConfig*) myOrderTableCellConfig;

@property (nonatomic,strong) NSString *imageString;
@property (nonatomic,strong) NSString *titleString;
@property (nonatomic,strong) NSString *isShowCancelBtn;
@property (nonatomic,strong) NSArray  *orderImvArray;










@end
