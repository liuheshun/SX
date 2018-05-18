//
//  GlobalHelper.m
//  Emeat
//
//  Created by liuheshun on 2017/12/25.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "GlobalHelper.h"

@implementation GlobalHelper

+(GlobalHelper *)shareInstance{
    static GlobalHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[GlobalHelper alloc] init];
        helper.addShoppingCartMarray = [NSMutableArray array];
        helper.isLoginState = @"0";
        helper.isSelectFirstAllOrder = @"100";
        
    });
    return helper;
}

#pragma mark = 空状态
-(void)emptyViewNoticeText:(NSString*)noticeText NoticeImageString:(NSString*)noticeImageString viewWidth:(CGFloat)width viewHeight:(CGFloat)height UITableView:(UITableView*)tableView{

    DLog(@"tale================================= = = = = %@" ,tableView);
    if (tableView) {
        UIImageView *emptyImv = [[UIImageView alloc] initWithFrame:CGRectMake((kWidth - width)/2, 200*kScale, width, height)];
        [tableView addSubview : emptyImv];
//        [emptyImv mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo([[UIApplication  sharedApplication ]keyWindow]);
//            make.top.equalTo([[UIApplication  sharedApplication ]keyWindow]).with.offset(275);
//            make.width.equalTo(@(width));
//            make.height.equalTo(@(height));
//
//        }];
        emptyImv.image = [UIImage imageNamed:noticeImageString];
        
        UILabel *emptyLable = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(emptyImv)+25*kScale, kWidth, 20*kScale)];
        emptyLable.font = [UIFont systemFontOfSize:15.0f*kScale];
        emptyLable.textColor = RGB(136, 136, 136, 1);
        emptyLable.text = noticeText;
        emptyLable.textAlignment = NSTextAlignmentCenter;
        [tableView addSubview:emptyLable];
//        [emptyLable mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.left.right.equalTo([[UIApplication  sharedApplication ]keyWindow]);
//            make.top.equalTo(emptyImv.mas_bottom).with.offset(25);
//            make.height.equalTo(@20);
//
//        }];
        
        self.emptyLable = emptyLable;
        self.emptyImv = emptyImv;
    }
   
}

-(void)removeEmptyView{
    [self.emptyLable removeFromSuperview];
    [self.emptyImv removeFromSuperview];
    
    
}


-(void)showErrorIView:(UIView*)superMainView errorImageString:(NSString*)errorImageString errorBtnString:(NSString*)errorBtnString errorCGRect:(CGRect)errorRect{
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [superMainView addSubview:bgView];
    
    UIImageView *errorImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:errorImageString]];
    [bgView addSubview:errorImage];
    
    UIButton *errorLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [errorLoadBtn setTitle:errorBtnString forState:0];
    errorLoadBtn.backgroundColor = RGB(231, 35, 36, 1);
    [errorLoadBtn setTitleColor:[UIColor whiteColor] forState:0];
    [bgView addSubview:errorLoadBtn];
    
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superMainView).with.offset(0);
        make.top.equalTo(superMainView.mas_top).with.offset(errorRect.origin.y);
        make.height.equalTo(@(errorRect.size.height));
    }];
    
    [errorImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).with.offset((errorRect.size.width-284*kScale)/2);
        make.top.equalTo(bgView.mas_top).with.offset(205*kScale);
        make.width.equalTo(@(284*kScale));
        make.height.equalTo(@(148*kScale));
    }];
    
    [errorLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(errorImage.mas_bottom).with.offset(55*kScale);
        make.height.equalTo(@(35*kScale));
        make.width.equalTo(@(100*kScale));
        make.left.equalTo(bgView.mas_left).with.offset((errorRect.size.width-100*kScale)/2);
    }];
    
    self.errorBgView = bgView;
    self.errorImageView = errorImage;
    self.errorLoadingBtn = errorLoadBtn;
    
    
}

-(void)removeErrorView{
    [UIView animateWithDuration:1 animations:^{
        
        [self.errorBgView removeFromSuperview];
        [self.errorImageView removeFromSuperview];
        [self.errorLoadingBtn removeFromSuperview];
    }];
}


#pragma mark ==== 检测是否开启定位权限
-(void)openLocationServiceWithBlock:(ReturnBlock)returnBlock
{
    BOOL isOPen = NO;
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        isOPen = YES;
    }
    if (returnBlock) {
        returnBlock(isOPen);
    }
}

@end
