//
//  GlobalHelper.h
//  Emeat
//
//  Created by liuheshun on 2017/12/25.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalHelper : NSObject
+(GlobalHelper*)shareInstance;

@property (nonatomic,assign) NSInteger shoppingCartBadgeValue;//购物车角标
@property (nonatomic,strong) NSMutableArray *addShoppingCartMarray;
///登陆状态
@property (nonatomic,strong) NSString *isLoginState;

///选择的地址
@property (nonatomic,strong) NSString *selectAddressString;



///空状态
-(void)emptyViewNoticeText:(NSString*)noticeText NoticeImageString:(NSString*)noticeImageString viewWidth:(CGFloat)width viewHeight:(CGFloat)height UITableView:(UITableView*)tableView;
-(void)removeEmptyView;
@property (nonatomic,strong) UIImageView *emptyImv;
@property (nonatomic,strong) UILabel *emptyLable;

///我的订单 先加载所有订单问题暂时解决
@property (nonatomic,strong) NSString *isSelectFirstAllOrder;


@end
