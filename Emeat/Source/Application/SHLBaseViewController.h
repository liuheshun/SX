//
//  SHLBaseViewController.h
//  Emeat
//
//  Created by liuheshun on 2017/11/13.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HomePageModel.h"

#import "HomePageTableViewCell.h"

#import "RealReachability.h"

typedef void(^clickRightItemBlock)(void);

@interface SHLBaseViewController : UIViewController
@property (nonatomic,strong) UIView *navBgView;


@property(nonatomic ,strong)  UINavigationBar *navBar;
@property(nonatomic ,strong)  UIBarButtonItem *leftButton;
@property(nonatomic ,strong)  UIBarButtonItem *rightButton;


@property(nonatomic ,strong)  UINavigationItem *navItem;
//状态栏
@property (nonatomic,strong) UIView *statusBarView;

@property (nonatomic,copy) clickRightItemBlock rightItemBlockAction;

@property (nonatomic,strong) NSString *rightButtonTitle;

-(void)setNavBar;
-(void)showNavBarLeftItem;
-(void)showNavBarItemRight;

-(void)leftItemAction;


- (NSString *)flattenHTML:(NSString *)html ;

#pragma mark 判断手机格式是否正确
-(BOOL)checkTel:(NSString *)tel;


//判断是否含有非法字符 yes 有  no没有 （非法字符是指 除数字 字母 文字以外的所有字符）
-(BOOL)containTheillegalCharacter:(NSString *)content;


///网络状态
@property (nonatomic,assign) ReachabilityStatus reachabilityStatus;


/**
 * 提示信息
 */
-(void)alertMessage:(NSString *)message willDo:(void(^)(void))result;

/**
 * 设置button角标
 */
-(void)setButtonBadgeValue:(UIButton*)btn badgeValue:(NSString *)badgeValue badgeOriginX:(CGFloat)X  badgeOriginY:(CGFloat)Y;

///哈希计算
- (NSString *) sha1:(NSString *)input;


///1970获取当前时间转为时间戳
- (NSString *)dateTransformToTimeSp;

///随机数
-(NSString *)ret32bitString;

///校验数据
#pragma mark == =校验数据

-(NSMutableDictionary*)checkoutData;
    

#pragma mark = 加入购物车数据

-(void)addCartPostDataWithProductId:(NSInteger)productId homePageModel:(HomePageModel*)model NSIndexPath:(NSIndexPath*)indexPath cell:(HomePageTableViewCell*)weakCell isFirstClick:(BOOL)isFirst tableView:(UITableView*)tableView;

#pragma mark = 从购物车减去

-(void)cutCartPostDataWithProductId:(NSInteger)productId  homePageModel:(HomePageModel*)model NSIndexPath:(NSIndexPath*)indexPath cell:(HomePageTableViewCell*)weakCell;

#pragma mark =====购物车数量
-(void)requestBadNumValue;

#pragma mark = 加入购物车商品数量为0时 删除整个商品

-(void)deleteProductPostDataWithProductId:(NSInteger)productId homePageModel:(HomePageModel*)model tableView:(UITableView*)tableView;





@end
