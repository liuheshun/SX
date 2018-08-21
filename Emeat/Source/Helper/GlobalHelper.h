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

@property (nonatomic,strong) NSMutableArray *specsListMarray;
@property (nonatomic,strong) NSString *homePageDetailsId;

///空状态view
-(void)emptyViewNoticeText:(NSString*)noticeText NoticeImageString:(NSString*)noticeImageString viewWidth:(CGFloat)width viewHeight:(CGFloat)height UITableView:(UITableView*)tableView isShowBottomBtn:(BOOL)isShowBottomBtn bottomBtnTitle:(NSString*)bottomBtnTitle;
-(void)removeEmptyView;
@property (nonatomic,strong) UIImageView *emptyImv;
@property (nonatomic,strong) UILabel *emptyLable;
@property (nonatomic,strong) UIButton *bottomBtn;


///无网络,请求错误view
-(void)showErrorIView:(UIView*)superMainView errorImageString:(NSString*)errorImageString errorBtnString:(NSString*)errorBtnString errorCGRect:(CGRect)errorRect;

-(void)removeErrorView;
@property (nonatomic,strong) UIView *errorBgView;

@property (nonatomic,strong) UIImageView *errorImageView;
@property (nonatomic,strong) UIButton *errorLoadingBtn;

///我的订单 先加载所有订单问题暂时解决
@property (nonatomic,strong) NSString *isSelectFirstAllOrder;

-(void)openLocationServiceWithBlock:(ReturnBlock)returnBlock;


///商户专区经常买 是否登录
@property (nonatomic,strong) NSString *merchantsIsLoginStated;
@property (nonatomic,strong) NSString *isMerchantsIsLoginEnter;


///
@property (nonatomic,strong) NSMutableArray *segmentTitleMarray;


@property (nonatomic,strong) NSString *isEnterDetails;
////商户专区首页分类数组
@property (nonatomic,strong) NSMutableArray *SortMarray;



@end
