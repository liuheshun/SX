//
//  GlobalHelper.h
//  Emeat
//
//  Created by liuheshun on 2017/12/25.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^ReturnBlock)(BOOL isOpen);

@interface GlobalHelper : NSObject
+(GlobalHelper*)shareInstance;

@property (nonatomic,assign) NSInteger shoppingCartBadgeValue;//购物车角标
@property (nonatomic,strong) NSMutableArray *addShoppingCartMarray;
///登陆状态
@property (nonatomic,strong) NSString *isLoginState;

///选择的地址
@property (nonatomic,strong) NSString *selectAddressString;



///空状态view
-(void)emptyViewNoticeText:(NSString*)noticeText NoticeImageString:(NSString*)noticeImageString viewWidth:(CGFloat)width viewHeight:(CGFloat)height UITableView:(UITableView*)tableView;
-(void)removeEmptyView;
@property (nonatomic,strong) UIImageView *emptyImv;
@property (nonatomic,strong) UILabel *emptyLable;

///无网络,请求错误view
-(void)showErrorIView:(UIView*)superMainView errorImageString:(NSString*)errorImageString errorBtnString:(NSString*)errorBtnString errorCGRect:(CGRect)errorRect;

-(void)removeErrorView;
@property (nonatomic,strong) UIView *errorBgView;

@property (nonatomic,strong) UIImageView *errorImageView;
@property (nonatomic,strong) UIButton *errorLoadingBtn;

///我的订单 先加载所有订单问题暂时解决
@property (nonatomic,strong) NSString *isSelectFirstAllOrder;

-(void)openLocationServiceWithBlock:(ReturnBlock)returnBlock;

@end
